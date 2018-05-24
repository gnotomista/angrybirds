classdef App < handle
    
    properties
        helper
        game
        simulation
        agents
        point_caught
        point_released
        point_move
        bird_caught
        bird_released
        bird_speed
        clicked
        fig
        slingshot
    end
    
    methods
        function this = App()
            this.helper = Helper('Taylor','app_data/png/taylor.png');
            this.simulation = Sim();
            this.point_caught = [NaN NaN];
            this.point_released = [NaN NaN];
            this.point_move = [NaN NaN];
            this.bird_caught = false;
            this.bird_released = false;
            this.bird_speed = [NaN NaN];
            this.clicked = false;
        end
        function start(this)
            this.helper.new_features()
            this.helper.intro()
            this.game = this.helper.choose_game();
            if strcmp(this.game, 'ic')
                this.play_pick_initial_conditions()
            elseif strcmp(this.game, 'ew')
                this.play_pick_switching_time()
            end
        end
        function play_pick_initial_conditions(this)
            this.agents = Agent('red', [0, 1], 0.2);
            N_pigs = 1;
            for n_pigs = 1 : N_pigs
                this.agents = [this.agents, Agent('pig', [2 + 3*rand(), 0], 0.5)];
            end
            
            this.helper.message_wait_button(0, 'Play', 'This is the basic bird: drag and drop it to fling it at the pig!', 'Let''s do it', 0.1)
            
            this.create_play_ic_figure('Play')
            this.plot_environment()
            this.drawAgents();
            
            while true
                if this.bird_caught
                    this.agents(1).move(this.point_move);
                    this.agents(1).update(this.fig);
                end
                if this.bird_released
                    for i = 1 : 2
                        delete(this.slingshot{i})
                    end
                    break
                end
                drawnow limitrate
                pause(0.03)
            end
            
            traj = this.simulation.run(this.bird_speed, this.point_released);
            for t = 1 : size(traj,2)
                this.agents(1).move(traj(:,t)');
                this.checkCollision();
                if traj(2,t) + min(this.agents(1).collision_shape(:,2)) < 0
                    traj(2,t) = - min(this.agents(1).collision_shape(:,2));
                    this.agents(1).move(traj(:,t)');
                    this.updateAgents();
                    drawnow limitrate
                    break
                end
                this.updateAgents();
                drawnow limitrate
                pause(0.03)
            end
            
            this.helper.message_wait_button(1, 'Optimal trajectory', 'Nice! But let''s have a look at the optimal solution obtained going back and forth in time in some strange spaces', 'Let''s see', 0.1)
            
            for agent = this.agents
                agent.setState(true);
            end
            this.deleteAgents();
            this.drawAgents();
            
            traj = this.simulation.run_optimal_ic(this.agents(2).position);
            for t = 1 : size(traj,2)
                this.agents(1).move(traj(:,t)');
                this.checkCollision()
                if traj(2,t) + min(this.agents(1).collision_shape(:,2)) < 0
                    traj(2,t) = traj(2,t) - min(this.agents(1).collision_shape(:,2));
                    this.agents(1).move(traj(:,t)');
                    this.updateAgents();
                    drawnow limitrate
                    break
                end
                this.updateAgents();
                drawnow limitrate
                pause(0.03)
            end
            
            this.helper.info(0.5, 'Touchdown', 'TOUCHDOWN!', 0.2)
            this.delete_play_figure(0)
        end
        function play_pick_switching_time(this)
            this.agents = Agent('yellow', [0, 1], 0.2);
            this.point_move = [0; 1];
            this.bird_speed = [1; 1];
            N_pigs = 1;
            for n_pigs = 1 : N_pigs
                this.agents = [this.agents, Agent('pig', [2 + 3*rand(), 0], 0.5)];
            end
            
            this.helper.message_wait_button(0, 'Play', 'This is the yellow bird: click on the figure to switch to accelerated mode!', 'Let''s do it', 0.1)
            
            this.create_play_ew_figure('Play')
            this.plot_environment()
            this.drawAgents();
            
            htcc = text(2, 1, '3',...
                'FontSize', 10,...
                'HorizontalAlignment', 'center');
            for cc = logspace(1, 3, 30)
                set(htcc, 'FontSize', cc);
                pause(0.03)
                drawnow limitrate
            end
            set(htcc, 'String', '2', 'FontSize', 10);
            for cc = logspace(1, 3, 30)
                set(htcc, 'FontSize', cc);
                pause(0.03)
                drawnow limitrate
            end
            set(htcc, 'String', '1', 'FontSize', 10);
            for cc = logspace(1, 3, 30)
                set(htcc, 'FontSize', cc);
                pause(0.03)
                drawnow limitrate
            end
            delete(htcc)
            
            while true
                if ~this.clicked
                    state_ip1 = this.simulation.run_A([this.point_move; this.bird_speed; 9.81], 1);
                else
                    state_ip1 = this.simulation.run_A([this.point_move; this.bird_speed; 9.81], 2);
                end
                this.point_move = state_ip1(1:2);
                this.bird_speed = state_ip1(3:4);
                this.agents(1).move(this.point_move');
                this.checkCollision();
                if this.point_move(2) + min(this.agents(1).collision_shape(:,2)) < 0
                    this.point_move(2) = - min(this.agents(1).collision_shape(:,2));
                    this.agents(1).move(this.point_move');
                    this.updateAgents();
                    drawnow limitrate
                    this.clicked = false;
                    break
                end
                this.updateAgents();
                drawnow limitrate
                pause(0.03)
            end
            
            this.helper.message_wait_button(1, 'Optimal trajectory', 'Cool, eh? Now let''s play with states and co-state to find the optimal trajectory!', 'Let''s see', 0.1)
            
            for agent = this.agents
                agent.setState(true);
                agent.light = false;
            end
            this.deleteAgents();
            this.drawAgents();
            
            [traj, tau_idx] = this.simulation.run_optimal_ew(this.agents(2).position);
            for t = 1 : 25 : size(traj,2)
                if t > tau_idx
                    this.agents(1).light = true;
                end
                this.agents(1).move(traj(:,t)');
                this.checkCollision()
                if traj(2,t) + min(this.agents(1).collision_shape(:,2)) < 0
                    traj(2,t) = traj(2,t) - min(this.agents(1).collision_shape(:,2));
                    this.agents(1).move(traj(:,t)');
                    this.updateAgents();
                    drawnow limitrate
                    break
                end
                this.updateAgents();
                drawnow limitrate
                pause(0.03)
            end
            traj(2,end) = - min(this.agents(1).collision_shape(:,2));
            this.agents(1).move(traj(:,end)');
            this.checkCollision()
            this.updateAgents();
            drawnow limitrate
            pause(0.03)
            
            this.helper.info(0.5, 'Touchdown', 'TOUCHDOWN!', 0.2)
            this.delete_play_figure(0)
        end
        function drawAgents(this)
            for agent = this.agents
                agent.draw(this.fig);
            end
        end
        function deleteAgents(this)
            for agent = this.agents
                agent.delete_handle();
            end
        end
        function updateAgents(this)
            for agent = this.agents
                agent.update(this.fig);
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
        function create_play_ic_figure(this, name)
            this.fig = figure;
            this.fig.Visible = 'off';
            this.fig.Units = 'normalized';
            this.fig.Position = [0.1 0.1 0.8 0.8];
            this.fig.MenuBar = 'none';
            this.fig.NumberTitle = 'off';
            this.fig.Name = name;
            this.fig.ButtonDownFcn = @this.onMouseDown;
            this.fig.WindowButtonUpFcn = @this.onMouseUp;
            this.fig.WindowButtonMotionFcn = @this.onMouseMove;
            
            ha = axes;
            ha.Units = 'normalized';
            ha.Position = [0.01 0.01 0.98 0.98];
            axis off
            
            movegui(this.fig, 'center')
            this.fig.Visible = 'on';
        end
        function create_play_ew_figure(this, name)
            this.fig = figure;
            this.fig.Visible = 'off';
            this.fig.Units = 'normalized';
            this.fig.Position = [0.1 0.1 0.8 0.8];
            this.fig.MenuBar = 'none';
            this.fig.NumberTitle = 'off';
            this.fig.Name = name;
            this.fig.ButtonDownFcn = @this.onMouseClicked;
            
            ha = axes;
            ha.Units = 'normalized';
            ha.Position = [0.01 0.01 0.98 0.98];
            axis off
            
            movegui(this.fig, 'center')
            this.fig.Visible = 'on';
        end
        function delete_play_figure(this, delay)
            pause(delay)
            close(this.fig)
        end
        function plot_environment(this)
            figure(this.fig)
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
        end
        function onMouseDown(this, object, eventdata)
            figure(this.fig)
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
            figure(this.fig)
            this.point_move = [1 0]*get(gca, 'CurrentPoint')*[1 0;0 1;0 0];
            if this.bird_caught && ~this.bird_released
                l1 = [this.point_move; 0.1 1.1];
                l2 = [this.point_move; -0.1 0.9];
                set(this.slingshot{1}, 'XData', l1(:,1), 'YData', l1(:,2));
                set(this.slingshot{2}, 'XData', l2(:,1), 'YData', l2(:,2));
            end
        end
        function onMouseClicked(this, object, eventdata)
            this.clicked = true;
            this.agents(1).light = true;
        end
    end
    
end
