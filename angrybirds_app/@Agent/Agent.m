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
            if strcmp(this.type, 'bird')
                load bird
                this.shape = {this.dimension*[x0Bird, y0Bird], this.dimension*[x1Bird, y1Bird], ...
                    this.dimension*[x2Bird, y2Bird], this.dimension*[x3Bird, y3Bird], ...
                    this.dimension*[x4Bird, y4Bird], this.dimension*[x5Bird, y5Bird], ...
                    this.dimension*[x6Bird, y6Bird]};
                this.shape_colors = colorBird;
            elseif strcmp(this.type, 'pig')
                load pig
                this.shape = {this.dimension*[x0Pig, y0Pig], this.dimension*[x1Pig, y1Pig], ...
                    this.dimension*[x2Pig, y2Pig], this.dimension*[x3Pig, y3Pig], ...
                    this.dimension*[x4Pig, y4Pig], this.dimension*[x5Pig, y5Pig], ...
                    this.dimension*[x6Pig, y6Pig], this.dimension*[x7Pig, y7Pig]};
                this.shape_colors = colorPig;
            end
            this.traslated_shape = this.shape;
            this.collision_shape = [max(this.shape{1}(:,1)) max(this.shape{1}(:,2));
                min(this.shape{1}(:,1)) max(this.shape{1}(:,2));
                min(this.shape{1}(:,1)) min(this.shape{1}(:,2));
                max(this.shape{1}(:,1)) min(this.shape{1}(:,2))];
            this.traslated_collision_shape = this.collision_shape;
            this.state = true;
            this.move(this.position)
        end
        function setState(this, state_value)
            this.state = state_value;
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
        function move(this, traslate_position)
            this.position = traslate_position;
            for i = 1 : length(this.shape)
                this.traslated_shape{i} = repmat(this.position, size(this.shape{i},1), 1) + this.shape{i};
            end
            this.traslated_collision_shape = repmat(this.position, 4, 1) + this.collision_shape;
        end
        function inside = clicked_inside(this, p)
            inside = inpolygon(p(1), p(2), this.traslated_shape{1}(:,1), this.traslated_shape{1}(:,2));
        end
        function delete_handle(this)
            for i = 1 : length(this.shape)
                delete(this.handle{i})
            end
        end
%         function dress_agent_as_bird(this)
%             this.shape = 
%         end
    end
    
end