classdef App < handle
    
    properties
        helper
        handle_play
        handle_figure
        slingshot
        simulation
        agents
        point_caught
        point_released
        point_move
        bird_caught
        bird_released
        bird_speed
    end
    
    methods
        function this = App()
            this.agents = Agent('bird', [0, 1], 0.5);
            N_pigs = 1; % round(10*rand());
            for n_pigs = 1 : N_pigs
                this.agents = [this.agents, Agent('pig', [2 + 3*rand(), 0], 0.5)];
            end
            this.simulation = Sim();
            this.point_caught = [NaN NaN];
            this.point_released = [NaN NaN];
            this.point_move = [NaN NaN];
            this.bird_caught = false;
            this.bird_released = false;
            this.bird_speed = [NaN NaN];
        end
        function start(this)
            this.helper = ui_helper('units', 'normalized', 'position', [0.05 0.3 0.55 0.55]);
        end
        function play(this)
            this.handle_play = play('units', 'normalized', 'position', [0.1 0.1 0.8 0.8]);
            
            ax1 = findobj('Tag', 'axes1_play');
            set(ax1, 'Visible','off')
            this.handle_figure = findobj('Tag', 'figure1_play');
            figure(this.handle_figure)
            hold on
            axis equal
            axis([-1 5 -0.5 2.5])
            line([-5 5], [-0.01 -0.01], 'LineWidth', 3, 'Color', 'k')
            line([0 0], [0 0.8], 'LineWidth', 3, 'Color', 'k')
            line([0 -0.1], [0.8 0.7], 'LineWidth', 3, 'Color', 'k')
            line([0 0.1], [0.8 0.9], 'LineWidth', 3, 'Color', 'k')
            line([-0.1 -0.1], [0.7 0.9], 'LineWidth', 3, 'Color', 'k')
            line([0.1 0.1], [0.9 1.1], 'LineWidth', 3, 'Color', 'k')
            l1 = [0 1.0; 0.1 1.1];
            l2 = [0 1.0; -0.1 0.9];
            this.slingshot{1} = plot(l1(:,1), l1(:,2), 'k');
            this.slingshot{2} = plot(l2(:,1), l2(:,2), 'k');
            set (this.handle_figure, 'ButtonDownFcn', @this.onMouseDown);
            set (this.handle_figure, 'WindowButtonUpFcn', @this.onMouseUp);
            set (this.handle_figure, 'WindowButtonMotionFcn', @this.onMouseMove);
            
            this.drawAgents();
            while true
                if this.bird_caught
                    this.agents(1).move(this.point_move);
                    this.agents(1).update(this.handle_figure);
                end
                if this.bird_released
                    for i = 1 : 2
                        delete(this.slingshot{i})
                    end
                    break
                end
                drawnow
                pause(0.03)
            end
            
            traj = this.simulation.run(this.bird_speed, this.point_released);
            for t = 1 : size(traj,2)
                this.agents(1).move(traj(:,t)');
                this.checkCollision();
                if traj(2,t) < 0
                    traj(2,t) = 0;
                    this.agents(1).move(traj(:,t)');
                    this.updateAgents();
                    break
                end
                this.updateAgents();
                drawnow
                pause(0.03)
            end
            
            pause(2)
            
            apushbutton = findobj('Tag', 'apushbutton');
            callbackCell = get(apushbutton,'Callback');
            callbackCell(apushbutton,[]);
            
            for agent = this.agents
                agent.setState(true);
            end
            this.deleteAgents();
            this.drawAgents();
            
            traj = this.simulation.run_optimal(this.agents(2).position);
            for t = 1 : size(traj,2)
                this.agents(1).move(traj(:,t)');
                this.checkCollision()
                if traj(2,t) < 0
                    traj(2,t) = 0;
                    this.agents(1).move(traj(:,t)');
                    this.updateAgents();
                    drawnow
                    break
                end
                this.updateAgents();
                drawnow
                pause(0.03)
            end
            
            pause(2)
            
            touchbutton = findobj('Tag', 'touchbutton');
            callbackCell = get(touchbutton,'Callback');
            callbackCell(touchbutton,[]);
        end
        function drawAgents(this)
            for agent = this.agents
                agent.draw(this.handle_figure);
            end
        end
        function deleteAgents(this)
            for agent = this.agents
                agent.delete_handle();
            end
        end
        function updateAgents(this)
            for agent = this.agents
                agent.update(this.handle_figure);
            end
        end
        function onMouseDown(this, object, eventdata)
            figure(this.handle_figure)
            this.point_caught = [1 0]*get(gca, 'CurrentPoint')*[1 0;0 1;0 0];
            if this.agents(1).clicked_inside(this.point_caught)
                this.bird_caught = true;
            end
        end
        function onMouseUp(this, object, eventdata)
            if this.bird_caught
                this.point_released = [1 0]*get(gca, 'CurrentPoint')*[1 0;0 1;0 0];
                this.bird_speed = 10 * (this.point_caught - this.point_released);
                this.bird_caught = false;
                this.bird_released = true;
            end
        end
        function onMouseMove(this, object, eventdata)
            figure(this.handle_figure)
            this.point_move = [1 0]*get(gca, 'CurrentPoint')*[1 0;0 1;0 0];
            if this.bird_caught && ~this.bird_released
                l1 = [this.point_move; 0.1 1.1];
                l2 = [this.point_move; -0.1 0.9];
                set(this.slingshot{1}, 'XData', l1(:,1), 'YData', l1(:,2));
                set(this.slingshot{2}, 'XData', l2(:,1), 'YData', l2(:,2));
            end
        end
        function checkCollision(this)
            b1 = this.agents(1).traslated_collision_shape;
            for agent = this.agents(2:end)
                b2 = agent.traslated_collision_shape;
                if any(inpolygon(b1(:,1), b1(:,2), b2(:,1), b2(:,2))) || any(inpolygon(b2(:,1), b2(:,2), b1(:,1), b1(:,2)))
                    agent.setState(false);
                end
            end
        end
    end
    
end