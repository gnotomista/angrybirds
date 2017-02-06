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
        function traj_optimal = run_optimal(this, pDes)
            gamma = 0.1;
            x0 = [0; 1; 1; 1; 9.81];
            xDes = [pDes(1); pDes(2); 0; 0; 9.81];
            W = blkdiag(eye(2), zeros(3));
            I010 = blkdiag(zeros(2), eye(2), 0);
            x = zeros(5,this.T/this.dt+1);
            l = zeros(5,this.T/this.dt+1);
            while abs(norm(x(1:2, end) - xDes(1:2))) > 0.1
                x(:, 1) = x0;
                for t = 0 : this.dt : this.T - this.dt
                    idx = int32((t+this.dt)/this.dt);
                    xDot = this.A * x(:,idx);
                    x(:,idx+1) = x(:,idx) + xDot * this.dt;
                end
                
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
    end
    
end

