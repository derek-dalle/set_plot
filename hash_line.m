function [h_1,h_2,h_3]=hash_line(x,y,varargin)
%
% hash_line(x,y, ... )
% [h_1,h_2,h_3] = hash_line(x,y, ... )
%
% INPUTS:
%         x   : list of x-coordinates in linear path
%         y   : list of y-coordinates in linear path
%
% OUTPUTS:
%         h_1 : handle for the main line
%         h_2 : handle for the hash line figure
%         h_3 : vector of handles for background polygons
%
% This function takes as input a series of line segments and an offset
% distance and returns a polygon.  The purpose is to essentially to draw a
% version of the line with thickness h.  The output is a polygon that
% starts with the original path and then contains an offset path in reverse
% order.
%

% Versions:
%  07/29/10 @Derek Dalle     : First version
%
% GNU Library General Public License
%

% Ensure column.
x = x(:);
y = y(:);

% Find a length scale to use when setting defaults.
x_min = min(x);
x_max = max(x);
y_min = min(y);
y_max = max(y);

% Default length scale
L_scale  = norm([x_max-x_min; y_max-y_min]);

% Default option values
theta_hash     = 51*pi/180;
hash_width     = 0.03*L_scale;
hash_sep       = 0.02*L_scale;
hash_thickness = 1;
line_thickness = 3;

% Find the thickness of the hash region normal to the input.
for i=1:2:numel(varargin)
	switch varargin{i}
		case 'HashAngle'
			theta_hash = mod(varargin{i+1}, 2*pi);
		case 'HashWidth'
			hash_width = varargin{i+1};
		case 'HashLineWidth'
			hash_thickness = varargin{i+1};
		case 'HashSeparation'
			hash_sep = varargin{i+1};
		case 'LineWidth'
			line_thickness = varargin{i+1};
	end
end

% Find locations of NaN's, which represent breaks in the path.
i_nan = isnan(x);

% Find the transitions
i_nan = [true; i_nan; true];
i_1   = find( i_nan(1:end-2) & ~i_nan(2:end-1));
i_2   = find(~i_nan(2:end-1) &  i_nan(3:end  ));

% Number of disjoint paths
n_path = numel(i_1);
% Total number of edges
n_edge = 0;

% Initialize the paths.
X = cell(n_path, 1);
Y = cell(n_path, 1);
h_3 = zeros(n_path, 1);

% Loop through the segments.
for k = 1:n_path
	% Indices of current segment
	j_1 = i_1(k);
	j_2 = i_2(k);
	% Get the width of the hash region normal to the input path.
	if numel(hash_width) == n_path
		h_w = hash_width(k);
	else
		h_w = hash_width;
	end
	% First draw the offset path.
	[X{k}, Y{k}] = offset_path(x(j_1:j_2), y(j_1:j_2), h_w);
	% Draw the first polygon.
	h_3(k) = fill(X{k}, Y{k}, 'w', 'EdgeAlpha', 0);
	% Count up number of edges.
	n_edge = n_edge + numel(X{k});
	% Check for a bigger box.
	x_min = min(x_min, min(X{k}));
	x_max = max(x_max, max(X{k}));
	y_min = min(y_min, min(Y{k}));
	y_max = max(y_max, max(Y{k}));
end

% Rotation matrix (for coordinate transforms)
A = [cos(theta_hash) sin(theta_hash); -sin(theta_hash) cos(theta_hash)];

% Calculate coordinates 
r = A*[x_min, x_max, x_max, x_min; y_min, y_min, y_max, y_max];

% Extrema in new coordinates
s_min = min(r(1,:));
s_max = max(r(1,:));
n_min = min(r(2,:));
n_max = max(r(2,:));

% Maximum number of hashes
n_hash = floor((n_max-n_min)/hash_sep);

% Initialize hash output.
x_hash = nan(2 * n_hash * n_edge, 1);
y_hash = nan(2 * n_hash * n_edge, 1);

% Index of next point
j = 0;

% Loop through all of the hash lines in the box.
for n = n_min:hash_sep:n_max
	% Find endpoits of hash.
	z_1 = A'*[s_min; n];
	z_2 = A'*[s_max; n];
	
	% Initialize line-path intersections.
	x_int = zeros(1, 2*n_edge);
	y_int = zeros(1, 2*n_edge);
	n_int = 0;
	% Loop through brush-width polygons.
	for k = 1:n_path
		% Find intersection points.
		[intr_Q, x_k, y_k] = path_int_line(X{k}, Y{k}, ...
			[z_1(1); z_2(1)], [z_1(2); z_2(2)]);
		% If there are intersections, add them.
		if intr_Q
			% Number of intersections
			n_k = numel(x_k);
			% Add the points.
			x_int(n_int + (1:n_k)) = x_k;
			y_int(n_int + (1:n_k)) = y_k;
			% Increase the number of intersections.
			n_int = n_int + n_k;
		end
	end
	% Contract the intersection set to ones that were found.
	x_int = x_int(1:n_int);
	y_int = y_int(1:n_int);
	
	% Rotate and sort the intersection points.
	r_int = sort(A*[x_int; y_int], 2);
	% Rotate them back.
	z_int = A'*r_int;
	
	% Find it yourself.
	for i = 1:2:n_int-1
		% Add the first point.
		j = j + 1;
		x_hash(j) = z_int(1, i);
		y_hash(j) = z_int(2, i);
		% Add the second point.
		j = j + 1;
		x_hash(j) = z_int(1, i+1);
		y_hash(j) = z_int(2, i+1);
		% Leave a gap after the segment.
		j = j + 1;
	end
	
end

% Trim the remaining NaNs out of the hash line.
x_hash = x_hash(1:j-1);
y_hash = y_hash(1:j-1);

% Overlay the new graphics.
hold on

% Draw the main line.
h_1 = plot(x, y, 'LineWidth', line_thickness, 'Color', 'k');

% Draw the hashes.
h_2 = plot(x_hash, y_hash, 'LineWidth', hash_thickness, 'Color', 'k');

