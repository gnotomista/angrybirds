classdef Helper < handle
    
    properties
        name
        photo
        fig
        wait
    end
    
    methods
        function this = Helper(name, photo)
            this.name = name;
            this.photo = photo;
        end
        function create_figure(this, name)
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
            this.fig.Visible = 'on';
            
            this.wait = true;
            while this.wait
                pause(0.01)
            end
            
            this.fig.Visible = 'off';
        end
        function intro(this)
            this.create_figure('Intro')
            
            hText = uicontrol('Style','text');
            hText.String = ['Hello y''all, I''m ', this.name, '! I''ll be your guide in the wonderful world of OPTIMAL CONTROL, aka how Nature controls Her systems!'];
            hText.Units = 'normalized';
            hText.FontUnits = 'normalized';
            hText.FontSize = 0.1;
            hText.Position = [0.48 0.25 0.5 0.5];
            
            hButton = uicontrol('Style', 'pushbutton');
            hButton.Units = 'normalized';
            hButton.Position = [0.6 0.25 0.3 0.2];
            hButton.Callback = @this.wait_button_callback;
            hButton.String = 'Start';
            
            movegui(this.fig,'center')
            this.show_figure_until_button_press()
        end
        function pop_this_up(this, pause_before, name, message, button_text)
            pause(pause_before)
            this.create_figure(name)
            
            hText = uicontrol('Style','text');
            hText.String = message;
            hText.Units = 'normalized';
            hText.FontUnits = 'normalized';
            hText.FontSize = 0.1;
            hText.Position = [0.48 0.25 0.5 0.5];
            
            hButton = uicontrol('Style', 'pushbutton');
            hButton.Units = 'normalized';
            hButton.Position = [0.6 0.15 0.3 0.2];
            hButton.Callback = @this.wait_button_callback;
            hButton.String = button_text;
            
            this.show_figure_until_button_press()
        end
        function wait_button_callback(this, source, eventdata)
            this.wait = false;
        end
    end
    
end