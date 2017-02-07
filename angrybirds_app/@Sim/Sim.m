classdef Sim < handle
    
    properties
        traj
        A
        A1
        A2
        T
        dt
    end
    
    methods
        function this = Sim()
            A4 = [zeros(2) eye(2);
                zeros(2) zeros(2)];
            this.A = [A4 [0;0;0;-1];
                zeros(1,4), 0];
            this.A1 = [A4 [0;0;0;-1];
                zeros(1,4), 0];
            this.A2 = [A4 [0;0;10;-1];
                zeros(1,4), 0];
            this.T = 2;
            this.dt = 0.025;
            this.traj = NaN(5, this.T/this.dt+1);
        end
        function traj_player = run(this, v0, p0)
            this.traj(:, 1) = [p0(1); p0(2); v0(1); v0(2); 9.81];
            
            for t = 0 : this.dt : this.T - this.dt
                idx = int32((t+this.dt)/this.dt);
                xDot = this.A * this.traj(:,idx);
                this.traj(:,idx+1) = this.traj(:,idx) + xDot * this.dt;
            end
            
            traj_player = this.traj(1:2, :);
        end
        function traj_optimal = run_optimal_ic(this, pDes)
            gamma = 0.1;
            x0 = [0; 1; 1; 1; 9.81];
            xDes = [pDes(1); pDes(2); 0; 0; 9.81];
            W = blkdiag(eye(2), zeros(3));
            I010 = blkdiag(zeros(2), eye(2), 0);
            x = zeros(5,this.T/this.dt+1);
            l = zeros(5,this.T/this.dt+1);
            while abs(norm(x(1:2, end) - xDes(1:2))) > 0.1
                x(:, 1) = x0;
                % state FORWARD
                for t = 0 : this.dt : this.T - this.dt
                    idx = int32((t+this.dt)/this.dt);
                    xDot = this.A * x(:,idx);
                    x(:,idx+1) = x(:,idx) + xDot * this.dt;
                end
                % lagrange multipliers BACKWARD
                for t = this.T : -this.dt : this.dt
                    idx = int32((t+this.dt)/this.dt);
                    lDot = - W * this.A * x(:,idx) - this.A' * W * (x(:,idx) - xDes) - this.A' * l(:,idx);
                    l(:,idx-1) = l(:,idx) - lDot * this.dt;
                end
                x0 = x0 - gamma * I010 * l(:, 1);
            end
            traj_optimal = x(1:2, :);
        end
        function p_ip1 = run_A(this, p_i, i)
            if i == 1
                xDot = this.A1 * p_i;
            elseif i == 2
                xDot = this.A2 * p_i;
            end
            p_ip1 = p_i + xDot * this.dt;
        end
        function [traj_optimal, tau_idx] = run_optimal_ew(this, pDes)
            this.dt = 0.001;
            x0 = [0; 1; 1; 1; 9.81];
            xDes = [pDes(1); pDes(2); 0; 0; 9.81];
            Tmax = 5;
            tau = 0;
            W = blkdiag(eye(2), zeros(3));
            alpha = 0.5;
            beta = 0.7;
            while true
                % state FORWARD
                x = [];
                x(:, 1) = x0;
                this.T = Tmax;
                for t = 0 : this.dt : Tmax
                    if t < tau
                        xDot = this.A1 * x(:,end);
                    else
                        xDot = this.A2 * x(:,end);
                    end
                    x(:,end+1) = x(:,end) + xDot * this.dt;
                    if x(2,end) < 0
                        x(:,end) = x(:,end-1);
                        this.T = t;
                        break
                    end
                end
                % lagrange multipliers BACKWARD
                l = [];
                l(:, 1) = zeros(5, 1); % l is ordered backward w.r.t. the optimal ic algorithm
                for t = this.T : -this.dt : tau + this.dt
                    idx = int32((t+this.dt)/this.dt);
                    lDot = - W * this.A2 * x(:,idx) - this.A2' * W * (x(:,idx) - xDes) - this.A2' * l(:,end);
                    l(:,end+1) = l(:,end) - lDot * this.dt;
                end
                % update tau for next iteration
                Dg = l(:, end)' * (this.A1 - this.A2) * x(:, idx);
                g = this.evaluate_cost(x0, tau, xDes, W);
                i = 1;
                while this.evaluate_cost(x0, tau - beta^i*Dg, xDes, W) - g > - alpha * beta ^ i * norm(Dg)^2
                    i = i + 1;
                    if i > 100
                        break
                    end
                end
                tau = tau - beta ^ i * Dg';
                if norm(x(1:2, end) - xDes(1:2)) < 0.05
                    break
                end
            end
            traj_optimal = x(1:2, :);
            tau_idx = tau / this.dt;
        end
        function cost = evaluate_cost(this, x0, tau, xDes, W)
            x = [];
            x(:, 1) = x0;
            for t = 0 : this.dt : this.T
                if t < tau
                    xDot = this.A1 * x(:,end);
                else
                    xDot = this.A2 * x(:,end);
                end
                x(:,end+1) = x(:,end) + xDot * this.dt;
                if x(2,end) < 0
                    x(:,end) = x(:,end-1);
                    break
                end
            end
            cost = 1/2 * (x(:, end) - xDes)' * W * (x(:, end) - xDes);
        end
    end
    
end

