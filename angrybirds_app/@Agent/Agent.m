classdef Agent < handle
    
    properties
        type
        position
        state
        light
        shape
        traslated_shape
        collision_shape
        traslated_collision_shape
        dimension
        handle
        handle_light
        shape_colors
        vertex
        face
        vertexColor
        faceColor
        N
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
            this.light = false;
            this.move(this.position)
            
            this.N = 36;
            for i = 1 : this.N+1
                this.vertex(3*(i-1)+1:3*(i-1)+3,:) = 1.5 * this.dimension * [0 0; cos(pi/2+(i-1)/this.N*2*pi) sin(pi/2+(i-1)/this.N*2*pi); cos(pi/2+i/this.N*2*pi) sin(pi/2+i/this.N*2*pi)];
            end
            for i = 1 : this.N
                this.face(i,:) = [3*(i-1)+1, 3*(i-1)+2, 3*(i-1)+3];
            end            
            this.vertexColor = repmat([1 1 0; 0.96 0.96 0.96; 0.96 0.96 0.96],this.N+1,1);
            this.faceColor = 'interp';
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
            this.handle_light = cell(1,length(this.shape));
            for i = 1 : length(this.shape)
                this.handle{i} = fill(this.traslated_shape{i}(:,1), this.traslated_shape{i}(:,2), this.shape_colors{i});
                this.handle_light{i} = [];
                set(this.handle{i}, 'HitTest', 'off')
            end
        end
        function update(this, fig_handle)
            if this.state
                figure(fig_handle)
                for i = 1 : length(this.shape)
                    if this.light
                        if isempty(this.handle_light{i})
                            this.handle_light{i} = patch('Faces', this.face,...
                                'Vertices', repmat(this.position, (this.N+1)*3, 1) + repmat([0 0], (this.N+1)*3, 1) + this.vertex,...
                                'FaceVertexAlphaData', repmat([1;0;0],this.N+1,1), ...
                                'FaceAlpha', 'interp', ...
                                'FaceVertexCData', this.vertexColor,...
                                'FaceColor', 'interp',...
                                'EdgeColor', 'none',...
                                'EdgeAlpha', 'interp');
                            uistack(this.handle_light{i},'bottom');
                        else
                            set(this.handle_light{i},...
                                'Faces', this.face,...
                                'Vertices', repmat(this.position, (this.N+1)*3, 1) + repmat([0 0], (this.N+1)*3, 1) + this.vertex);
                        end
                    end
                    set(this.handle{i}, 'XData', this.traslated_shape{i}(:,1), 'YData', this.traslated_shape{i}(:,2))
                end
            else
                for i = 1 : length(this.shape)
                    delete(this.handle{i})
                    delete(this.handle_light{i})
                end
            end
        end
        function inside = clicked_inside(this, p)
            inside = inpolygon(p(1), p(2), this.traslated_collision_shape(:,1), this.traslated_collision_shape(:,2));
        end
        function delete_handle(this)
            for i = 1 : length(this.shape)
                delete(this.handle{i})
                delete(this.handle_light{i})
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