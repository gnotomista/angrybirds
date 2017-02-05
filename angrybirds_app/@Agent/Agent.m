classdef Agent < handle
    
    properties
        type
        position
        state
        shape
        traslated_shape
        collision_shape
        traslated_collision_shape
        dimension
        handle
        shape_colors
    end
    
    methods
        function this = Agent(varargin)
            ip = inputParser;
            validateType = @(x) ischar(x);
            validationPosition = @(x) isvector(x);
            validationDimension = @(x) isnumeric(x);
            addRequired(ip, 'Type', validateType)
            addRequired(ip, 'Position', validationPosition)
            addRequired(ip, 'Dimension', validationDimension)
            parse(ip,varargin{:})
            
            this.type = ip.Results.Type;
            this.position = ip.Results.Position;
            this.dimension = ip.Results.Dimension;
            
            this.dress_me_as(this.type)
            
            this.state = true;
            this.move(this.position)
        end
        function setState(this, state_value)
            this.state = state_value;
        end
        function move(this, traslate_position)
            this.position = traslate_position;
            for i = 1 : length(this.shape)
                this.traslated_shape{i} = repmat(this.position, size(this.shape{i},1), 1) + this.shape{i};
            end
            this.traslated_collision_shape = repmat(this.position, 4, 1) + this.collision_shape;
        end
        function draw(this, fig_handle)
            figure(fig_handle)
            this.handle = cell(1,length(this.shape));
            for i = 1 : length(this.shape)
                this.handle{i} = fill(this.traslated_shape{i}(:,1), this.traslated_shape{i}(:,2), this.shape_colors{i});
                set(this.handle{i}, 'HitTest', 'off')
            end
        end
        function update(this, fig_handle)
            if this.state
                figure(fig_handle)
                for i = 1 : length(this.shape)
                    set(this.handle{i}, 'XData', this.traslated_shape{i}(:,1), 'YData', this.traslated_shape{i}(:,2))
                end
            else
                for i = 1 : length(this.shape)
                    delete(this.handle{i})
                end
            end
        end
        function inside = clicked_inside(this, p)
            inside = inpolygon(p(1), p(2), this.traslated_collision_shape(:,1), this.traslated_collision_shape(:,2));
        end
        function delete_handle(this)
            for i = 1 : length(this.shape)
                delete(this.handle{i})
            end
        end
        function dress_me_as(this, dress)
            load([dress, '.mat'])
            this.shape = cellfun(@(x) x * this.dimension, shape, 'un', 0);
            this.shape_colors = shape_colors;
            clear color shape
            
            xMax = -Inf;
            xMin = +Inf;
            yMax = -Inf;
            yMin = +Inf;
            for i = 1 : length(this.shape)
                if max(this.shape{i}(:,1)) > xMax
                    xMax = max(this.shape{i}(:,1));
                end
                if min(this.shape{i}(:,1)) < xMin
                    xMin = min(this.shape{i}(:,1));
                end
                if max(this.shape{i}(:,2)) > yMax
                    yMax = max(this.shape{i}(:,2));
                end
                if min(this.shape{i}(:,2)) < yMin
                    yMin = min(this.shape{i}(:,2));
                end
            end
            this.collision_shape = [xMax yMax;
                xMin yMax;
                xMin yMin;
                xMax yMin];
            
            this.traslated_shape = this.shape;
            this.traslated_collision_shape = this.collision_shape;
        end
    end
    
end