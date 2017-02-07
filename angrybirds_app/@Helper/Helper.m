classdef Helper < handle
    
    properties
        name
        photo
        fig
        wait
        chosen_game
    end
    
    methods
        function this = Helper(name, photo)
            this.name = name;
            this.photo = photo;
        end
        function new_features(this)
            this.create_figure('New features')
            this.fig.Resize = 'off';
            
            ha1 = axes;
            ha1.Units = 'normalized';
            ha1.Position = [0.05 0.7 0.25 0.25];
            image(imread('app_data/png/egerstedt_wardi.png'))
            axis off
            axis image
            
            ha2 = axes;
            ha2.Units = 'normalized';
            ha2.Position = [0.05 0.4 0.25 0.25];
            image(imread('app_data/png/armijo.png'))
            axis off
            axis image
            
            ha3 = axes;
            ha3.Units = 'normalized';
            ha3.Position = [0.05 0.1 0.25 0.25];
            image(imread('app_data/png/linux_mac.png'))
            axis off
            axis image
            
            hText1 = uicontrol('Style','text');
            hText1.String = 'Added optimal switching time problem';
            hText1.Units = 'normalized';
            hText1.FontUnits = 'normalized';
            hText1.FontSize = 0.25;
            hText1.Position = [0.3 0.65 0.6 0.2];
            
            hText2 = uicontrol('Style','text');
            hText2.String = 'Powered by Armijo';
            hText2.Units = 'normalized';
            hText2.FontUnits = 'normalized';
            hText2.FontSize = 0.25;
            hText2.Position = [0.3 0.35 0.6 0.2];
            
            hText3 = uicontrol('Style','text');
            hText3.String = 'Fixed issues with Macintosh';
            hText3.Units = 'normalized';
            hText3.FontUnits = 'normalized';
            hText3.FontSize = 0.25;
            hText3.Position = [0.3 0.05 0.6 0.2];
            
            hButton = uicontrol('Style', 'pushbutton');
            hButton.Units = 'normalized';
            hButton.Position = [0.85 0.05 0.1 0.1];
            hButton.Callback = @this.wait_button_callback;
            hButton.String = 'Thank you';
            
            this.show_figure_until_button_press()
        end
        function game = choose_game(this)
            this.create_figure_with_axes('Choose game')
            
            hButton1 = uicontrol('Style', 'pushbutton');
            hButton1.Units = 'normalized';
            hButton1.Position = [0.5 0.55 0.4 0.3];
            hButton1.Callback = @this.ic_game_button_callback;
            hButton1.String = 'Optimal initial conditions';
            
            hButton2 = uicontrol('Style', 'pushbutton');
            hButton2.Units = 'normalized';
            hButton2.Position = [0.5 0.15 0.4 0.3];
            hButton2.Callback = @this.ew_game_button_callback;
            hButton2.String = 'Optimal switching time';
            
            this.show_figure_until_button_press();
            
            game = this.chosen_game;
        end
        function intro(this)
            this.create_figure_with_axes('Intro')
            
            hText = uicontrol('Style','text');
            hText.String = ['Hello y''all, I''m ', this.name, '! I''ll be your guide in the wonderful world of OPTIMAL CONTROL, that is how Nature controls Her systems, basically ANGRY BIRDS!'];
            hText.Units = 'normalized';
            hText.FontUnits = 'normalized';
            hText.FontSize = 0.1;
            hText.Position = [0.48 0.25 0.5 0.5];
            
            hButton = uicontrol('Style', 'pushbutton');
            hButton.Units = 'normalized';
            hButton.Position = [0.6 0.15 0.3 0.2];
            hButton.Callback = @this.wait_button_callback;
            hButton.String = 'Start';
            
            this.show_figure_until_button_press()
        end
        function message_wait_button(this, pause_before, name, message, button_text, fontsize)
            pause(pause_before)
            this.create_figure_with_axes(name)
            
            hText = uicontrol('Style','text');
            hText.String = message;
            hText.Units = 'normalized';
            hText.FontUnits = 'normalized';
            hText.FontSize = fontsize;
            hText.Position = [0.48 0.25 0.5 0.5];
            
            hButton = uicontrol('Style', 'pushbutton');
            hButton.Units = 'normalized';
            hButton.Position = [0.6 0.15 0.3 0.2];
            hButton.Callback = @this.wait_button_callback;
            hButton.String = button_text;
            
            this.show_figure_until_button_press()
        end
        function info(this, pause_before, name, message, fontsize)
            pause(pause_before)
            this.create_figure_with_axes(name)
            
            hText = uicontrol('Style','text');
            hText.String = message;
            hText.Units = 'normalized';
            hText.FontUnits = 'normalized';
            hText.FontSize = fontsize;
            hText.Position = [0.48 0.15 0.5 0.5];
            
            this.show_figure(0)
        end
        function create_figure(this, name)
            this.fig = figure;
            this.fig.Visible = 'off';
            this.fig.Units = 'normalized';
            this.fig.Position = [0.2 0.2 0.6 0.6];
            this.fig.MenuBar = 'none';
            this.fig.NumberTitle = 'off';
            this.fig.Name = name;
        end
        function create_figure_with_axes(this, name)
            this.fig = figure;
            this.fig.Visible = 'off';
            this.fig.Units = 'normalized';
            this.fig.Position = [0.1 0.1 0.8 0.8];
            this.fig.MenuBar = 'none';
            this.fig.NumberTitle = 'off';
            this.fig.Name = name;
            
            ha = axes;
            ha.Units = 'normalized';
            ha.Position = [0.05 0.05 0.4 0.8];
            readImage = imread(this.photo);
            image(readImage)
            axis off
            axis image
        end
        function show_figure_until_button_press(this)
            movegui(this.fig, 'center')
            this.fig.Visible = 'on';
            
            this.wait = true;
            while this.wait
                pause(1e-6)
            end
            
            this.fig.Visible = 'off';
        end
        function show_figure(this, duration)
            movegui(this.fig, 'center')
            this.fig.Visible = 'on';
            pause(duration)
        end
        function wait_button_callback(this, source, eventdata)
            this.wait = false;
        end
        function ic_game_button_callback(this, source, eventdata)
            this.chosen_game = 'ic';
            this.wait = false;
        end
        function ew_game_button_callback(this, source, eventdata)
            this.chosen_game = 'ew';
            this.wait = false;
        end
    end
    
end
