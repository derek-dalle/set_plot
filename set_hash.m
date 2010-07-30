function set_hash(h_1,h_2,h_3,varargin)
%
% set_hash(h_1,h_2,h_3,varargin)
%
% INPUTS:
%         h_1 : handle for the main line
%         h_2 : handle for the hash line figure
%         h_3 : vector of handles for background polygons
%
% OUTPUTS:
%
% OPTIONS:
%             HashAngle: [ scalar {51 degrees} ]
%             HashWidth: [ scalar or vector ]
%        HashSeparation: [ scalar ]
%         HashLineWidth: [ scalar {1} ]
%             LineWidth: [ scalar {3} ]
%
% This function is meant to alter properties of a hash-line drawing
% produced by hash_line.  It is required to alter some of the properties
% associated with the drawing that cannot normally be accessed from the
% graphics handles.  This includes the angle of the hashes, for instance.
%
% Its usage is very similar to that of set, except that the user must
% specify all handles pertaining to the drawing.
%

% Versions:
%  07/29/10 @Derek Dalle     : First version
%
% GNU Library General Public License
%

% Ensure column.
x = get(h_1, 'XData');
y = get(h_1, 'YData');

% Find the thickness of the hash region normal to the input.
for i=1:2:numel(varargin)
	switch varargin{i}
		case 'HashLineWidth'
			% Get the value.
			hash_thickness = varargin{i+1};
			% Set it.
			set(h_2, 'LineWidth', hash_thickness);
		case 'LineWidth'
			% Get the value.
			line_thickness = varargin{i+1};
			% Set it.
			set(h_1, 'LineWidth', line_thickness);
	end
end

% Calculate the relevant geometry.
[X, Y, x_hash, y_hash] = hash_points(x, y, varargin{:});

% Number of disjoint paths
n_path = numel(h_3);

% Loop through the segments.
for k = 1:n_path
	% Update the first polygon.
	set(h_3(k), 'XData', X{k}, 'YData', Y{k});
end

% Draw the new hashes.
set(h_2, 'XData', x_hash, 'YData', y_hash);

