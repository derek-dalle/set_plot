function h = hash_poly(x, y, varargin)
%
% hash_poly(x, y)
% hash_poly(x, y, 'OptionName', optValue, ... )
% hash_poly(x, y, options)
% h = hash_poly(x, y, ... )
%
% INPUTS:
%         x : list of x-coordinates in linear path
%         y : list of y-coordinates in linear path
%
% OUTPUTS:
%         h : struct containing handle for the main line and the hashes
%
% OPTIONS:
%             HashAngle: [ scalar {51 degrees} ]
%             HashWidth: [ scalar or vector ]
%        HashSeparation: [ scalar ]
%         HashLineWidth: [ scalar {1} ]
%             LineWidth: [ scalar {3} ]
%
% This function takes as input a path or set of paths and draws a hashed
% line to one side of that path.  It returns handles to the graphics it
% generates so that the user may change properties later.  The properties
% that are not part of Matlab's usual set must be set using the function
% set_hash or here.
%
% To specify a set of paths, separate the paths in x and y with at least
% one NaN.  This is consistent with the behavior of Matlab's functions such
% as plot.
%

% Versions:
%  2010.07.29 @Derek Dalle     : First version
%  2011.03.18 @Derek Dalle     : Customized for polygons
%
% GNU Library General Public License

% Ensure column.
x = x(:);
y = y(:);

% Number of optional arguments
n_arg = numel(varargin);

% Make an options structure.
if n_arg > 0 && (isstruct(varargin{1}) || isempty(varargin{1}))
	% Struct
	options = varargin{1};
elseif n_arg > 0 && iscell(varargin{1})
	% Cell array
	options = struct(varargin{1}{:});
elseif mod(n_arg, 2) == 1
	% Odd number of option value/name arguments
	error('hash_line:OptionNumber', ['Optional arguments ', ...
		'must be either a struct or pairs of option names and values.']);
else
	% Option name/value pairs
	options = struct(varargin{:});
end

% Process the options.
% Thickness of each hash.
if isfield(options, 'HashLineWidth')
	hash_thickness = options.HashLineWidth;
else
	hash_thickness = 1;
end
% Thickness of boundary line.
if isfield(options, 'LineWidth')
	line_thickness = options.LineWidth;
else
	line_thickness = 3;
end

% Overlay the new graphics.
hold on

% Find locations of NaN's, which represent breaks in the path.
i_nan = isnan(x);

% Find the transitions
i_nan = [true; i_nan; true];
i_1   = find( i_nan(1:end-2) & ~i_nan(2:end-1));
i_2   = find(~i_nan(2:end-1) &  i_nan(3:end  ));

% Number of polygons
n_poly = numel(i_1);
% Total number of edges
n_edge = 0;

% Split up the polygons.
x_p = nan(2*numel(x), 1);
y_p = nan(2*numel(x), 1);
% Loop through the polygons.
for k = 1:n_poly
	% Number of points in polygon k.
	n_k = i_2(k) - i_1(k) + 2;
	% Sotre the points
	x_p(n_edge + (1:n_k)) = [x(i_1(k):i_2(k)); x(i_1(k))];
	y_p(n_edge + (1:n_k)) = [y(i_1(k):i_2(k)); y(i_1(k))];
	% Number of edges
	n_edge = n_edge + n_k + 1;
end

% Contract the polygon path.
x_p = x_p(1:n_edge-1);
y_p = y_p(1:n_edge-1);

% Draw the main line.
h_p = plot(x_p, y_p, 'LineWidth', line_thickness, 'Color', 'k');

% Get an axes handle.
r_lim = axis;
% Default length scale based on current axis window.
L_scale = max([r_lim(2) - r_lim(1), r_lim(4) - r_lim(3)]);
% Set the default inset distance.
hash_width = 0.02 * L_scale;
% Set the default distance between hashes.
hash_sep = 0.02 * L_scale;
	
% Store the options.
if ~isfield(options, 'HashWidth')
	options.HashWidth = hash_width;
end
if ~isfield(options, 'HashSeparation')
	options.HashSeparation = hash_sep;
end

% Calculate the relevant geometry.
[x_hash, y_hash] = hash_points_poly(x, y, options);

% Draw the hashes.
h_h = plot(x_hash, y_hash, 'LineWidth', hash_thickness, ...
	'Color', 'k');

% Check for outputs.
if nargout > 0
	h = struct('line', h_p, 'hash', h_h);
end


% --- SUBFUNCTION 1: Get hash geometry ---
function [X, Y] = hash_points_poly(x, y, varargin)
%
% [X, Y] = hash_points_poly(x, y)
% [X, Y] = hash_points_poly(x, y, 'OptionName', 'optValue', ...)
% [X, Y] = hash_points_poly(x, y, options)
%
% INPUTS:
%         x : list of x-coordinates in polygon
%         y : list of y-coordinates in polygon
%
% OUTPUTS:
%         X : x-coordinates of hash endpoints
%         Y : y-coordinates of hash endpoints
%
% This function takes as input a series of line segments and an offset
% distance and returns a polygon.  The purpose is to essentially to draw a
% version of the line with thickness h.  The output is a polygon that
% starts with the original path and then contains an offset path in reverse
% order.
%

% Versions:
%  2010.07.30 @Derek Dalle     : First version
%  2011.03.18 @Derek Dalle     : Customized for polygons
%
% GNU Library General Public License

% Ensure column.
x = x(:);
y = y(:);

% Find a length scale to use when setting defaults.
x_min = min(x); x_max = max(x);
y_min = min(y); y_max = max(y);
% Default length scale
L_scale = max([x_max-x_min; y_max-y_min]);
% Minimum nonzero length
x_tol = 1e-8 * L_scale;

% Number of optional arguments
n_arg = numel(varargin);

% Make an options structure.
if n_arg > 0 && (isstruct(varargin{1}) || isempty(varargin{1}))
	% Struct
	options = varargin{1};
elseif n_arg > 0 && iscell(varargin{1})
	% Cell array
	options = struct(varargin{1}{:});
elseif mod(n_arg, 2) == 1
	% Odd number of option value/name arguments
	error('hash_points:OptionNumber', ['Optional arguments ', ...
		'must be either a struct or pairs of option names and values.']);
else
	% Option name/value pairs
	options = struct(varargin{:});
end

% Process the options.
% Angle of hash lines.
if isfield(options, 'HashAngle')
	theta_hash = options.HashAngle;
else
	theta_hash = 51;
end
% Width of polygon containing hashes
if isfield(options, 'HashWidth')
	hash_width = options.HashWidth;
else
	hash_width = 0.025*L_scale;
end
% Separation between hashes
if isfield(options, 'HashSeparation')
	hash_sep = options.HashSeparation;
else
	hash_sep = 0.025*L_scale;
end

% Find locations of NaN's, which represent breaks in the path.
i_nan = isnan(x);

% Find the transitions
i_nan = [true; i_nan; true];
i_1   = find( i_nan(1:end-2) & ~i_nan(2:end-1));
i_2   = find(~i_nan(2:end-1) &  i_nan(3:end  ));

% Number of polygons
n_poly = numel(i_1);
% Total number of edges
n_edge = 0;

% Split up the polygons.
X_P = cell(n_poly, 1); Y_P = cell(n_poly, 1);
% Initialize offset polygons.
X_O = cell(n_poly, 1); Y_O = cell(n_poly, 1);
% Loop through the polygons.
for k = 1:n_poly
	% Nominal points in polygon k
	x_P = [x(i_1(k):i_2(k)); x(i_1(k))];
	y_P = [y(i_1(k):i_2(k)); y(i_1(k))];
	% Delete duplicates.
	i_delete = [(abs(diff(x_P))<=x_tol & abs(diff(y_P))<=x_tol); false];
	x_P = x_P(~i_delete);
	y_P = y_P(~i_delete);
	% Get the offset paths.
	[X_O{k}, Y_O{k}] = inset_poly(x_P, y_P, hash_width);
	% Save the points.
	X_P{k} = x_P; Y_P{k} = y_P;
	% Number of edges
	n_edge = n_edge + numel(x_P) + numel(X_O{k}) - 2;
end

% Rotation matrix (for coordinate transforms)
A = [cosd(theta_hash) sind(theta_hash); ...
	-sind(theta_hash) cosd(theta_hash)];

% Calculate coordinates 
r = A*[x_min, x_max, x_max, x_min; y_min, y_min, y_max, y_max];

% Extrema in new coordinates
s_min = min(r(1,:)); s_max = max(r(1,:));
n_min = min(r(2,:)); n_max = max(r(2,:));

% Maximum number of hashes
n_hash = floor((n_max-n_min)/hash_sep);

% Initialize hash output.
X = nan(2 * n_hash * n_edge, 1);
Y = nan(2 * n_hash * n_edge, 1);

% Index of next point
j = 0;

% Loop through all of the hash lines in the box.
for n = n_min:hash_sep:n_max
	% Find endpoits of hash.
	z_1 = A'*[s_min; n];
	z_2 = A'*[s_max; n];
	% Coordinates
	x_l = [z_1(1), z_2(1)];
	y_l = [z_1(2), z_2(2)];
	
	% Initialize line-path intersections.
	x_i = zeros(1, 2*n_edge);
	y_i = zeros(1, 2*n_edge);
	n_i = 0;
	% Loop through brush-width polygons.
	for k = 1:n_poly
		% Find intersections with input polygons.
		[q_p, x_p, y_p] = path_int_line(...
			X_P{k}, Y_P{k}, x_l, y_l);
		% Find intersections with offset polygons.
		[q_o, x_o, y_o] = path_int_line(...
			X_O{k}, Y_O{k}, x_l, y_l);
		% Store the intersections with the polygon.
		if q_p
			% Number of intersections
			n_p = numel(x_p);
			% Add the points.
			x_i(n_i + (1:n_p)) = x_p;
			y_i(n_i + (1:n_p)) = y_p;
			% Update number of intersections.
			n_i = n_i + n_p;
		end
		% Store the intersections with the offset.
		if q_o
			% Number of intersections
			n_o = numel(x_o);
			% Add the points.
			x_i(n_i + (1:n_o)) = x_o;
			y_i(n_i + (1:n_o)) = y_o;
			% Update number of intersections.
			n_i = n_i + n_o;
		end
	end
	% Contract the intersection set to ones that were found.
	x_i = x_i(1:n_i);
	y_i = y_i(1:n_i);
	
	% Rotate and sort the intersection points.
	r_i = sort(A*[x_i; y_i], 2);
	% Rotate them back.
	z_i = A'*r_i;
	
	% Find it yourself.
	for i = 1:2:n_i-1
		% Add the first point.
		j = j + 1;
		X(j) = z_i(1, i);
		Y(j) = z_i(2, i);
		% Add the second point.
		j = j + 1;
		X(j) = z_i(1, i+1);
		Y(j) = z_i(2, i+1);
		% Leave a gap after the segment.
		j = j + 1;
	end
	
end

% Trim the remaining NaNs out of the hash line.
X = X(1:j-1);
Y = Y(1:j-1);


% --- SUBFUNCTION 2: Wide brush path ---
function [X, Y] = inset_poly(x, y, h)
%
% [X, Y] = inset_poly(x, y, h)
%
% INPUTS:
%         x : list of x-coordinates of single polygon vertices
%         y : list of y-coordinates of single polygon vertices
%         h : offset distance
%
% OUTPUTS:
%         X : list of x-coordinates of inset path(s)
%         Y : list of y-coordinates of inset path(s)
%
%
% This function takes a set of polygon vertices as input and returns a
% polygon that is a constant offset h inward from the original polygon.
%

% Versions:
%   2011/03/17 @Derek Dalle   : First version
%
% Public domain

% Test the input
if numel(x) ~= numel(y)
	% Uneven number of vertices
	error('inset_poly:UnevenVertices', ...
		'Number of vertices in x and y must be equal.');
elseif any(isnan(x)) || any(isnan(y))
	% Multiple segments
	error('inset_poly:MultipleSegments', ...
		'The function offset_poly only works on a single patch.');
end

% Ensure column and add last segment.
x = [x(:); x(1)];
y = [y(:); y(1)];

% Find duplicates.
i_delete = [(diff(x) == 0 & diff(y) == 0); false];
% Eliminate them.
x = x(~i_delete);
y = y(~i_delete);
% Number of vertices
n_vertex = numel(x) - 1;

% Get a tolerance distance
if n_vertex > 1
	% Use the size of the polygon.
	x_min = min(x); x_max = max(x);
	y_min = min(y); y_max = max(y);
	% Smallest nonzero distance
	x_tol = 1e-8 * max(x_max - x_min, y_max - y_min);
else
	% Trivial
	x_tol = 0;
end

% Check for self-intersecting polygon.
for i = 1:n_vertex-1
	% Edges to test with
	if i == 1
		j_cur = 3:n_vertex;
	else
		j_cur = i+2:n_vertex+1;
	end
	% Test for intersection
	if path_int_line(x(j_cur), y(j_cur), x(i:i+1), y(i:i+1))
		error('inset_poly:SelfIntersect', ...
			'Self-intersecting polygon.');
	end
end

% Midpoint of the first segment.
if n_vertex > 1
	x_0 = (x(1) + x(2)) / 2;
	y_0 = (y(1) + y(2)) / 2;
end
% Point along right perpindicular.
x_1 = x_0 + (y(2) - y(1));
y_1 = y_0 - (x(2) - x(1));
% Find intersections between this line and the polygon.
[q_int, x_i, y_i] = path_int_line(x, y, [x_0; x_1], [y_0; y_1]);
% 1-norm to each point.
d_i = abs(x_i - x_0) + abs(y_i - y_0);
% Deselect the x_0 point
d_i = d_i(d_i > 0);
% Find closest intersection point.
if q_int && numel(d_i) > x_tol
	% Index of closest
	i = find(d_i == min(d_i), 1);
	% Select that point
	x_1 = (x_i(i) + x_0) / 2;
	y_1 = (y_i(i) + y_0) / 2;
end
% Test if (x_1, y_1) is inside the polygon.
if inpolygon(x_1, y_1, x(2:end), y(2:end))
	% Inset is to the right.
	A = [0, 1; -1, 0];
else
	% Inset is to the left.
	A = [0, -1; 1, 0];
end

% Maximum possible number of vertices in an offset path
i_max = 2 * n_vertex + 1;
% Maximum possible number of separate offset paths
k_max = ceil(n_vertex / 2);
% Current number of paths
k_cur = 0;

% Initialize the offset paths.
X = nan(i_max, k_max);
Y = nan(i_max, k_max);

% Current number of points in each offset path.
m_path = zeros(1, k_max);

% Endpoints of initial offsets.
X_o = nan(3, n_vertex);
Y_o = nan(3, n_vertex);

% Vector along each segment.
U = [diff(x)'; diff(y)'];
% Length of each segment.
L = sqrt(sum(U.*U));
% Unit vectors.
U = U ./ [L; L];

% Loop through the edges to generate the possible offset paths.
for i = 1:n_vertex
	% Endpoints
	r_1 = [x(i)  ; y(i)  ];
	r_2 = [x(i+1); y(i+1)];
	% Vector from vertex i to vertex i+1
	u = U(:,i);
	% Rotate.
	n = A * u;
	% Offset endpoints.
	z_1 = r_1 + h*(n - u);
	z_2 = r_2 + h*(n + u);
	% Line coordinates
	X_o(1:2,i) = [z_1(1), z_2(1)];
	Y_o(1:2,i) = [z_1(2), z_2(2)];
end

% Loop through the nominal offset lines
for i = 1:n_vertex
	
	% Line endpoints.
	x_o = X_o(1:2,i);
	y_o = Y_o(1:2,i);
	
	% Find the intersections with the polygon.
	[q_p, x_p, y_p] = path_int_line(x, y, x_o, y_o);
	% Find the intsersections with all the other segments.
	[q_l, x_l, y_l] = path_int_line(X_o(:), Y_o(:), x_o, y_o);
	
	% Combine the intersection points.
	if q_p && q_l
		% Intersections with polygon and path
		x_i = [x_o', x_p', x_l'];
		y_i = [y_o', y_p', y_l'];
	elseif q_p
		% Intersections with polygon
		x_i = [x_o', x_p'];
		y_i = [y_o', y_p'];
	elseif q_l
		% Intersections with other nominal paths
		x_i = [x_o', x_l'];
		y_i = [y_o', y_l'];
	else
		% No intersections
		x_i = x_o';
		y_i = y_o';
	end
	
	% Unit vector along path
	u = U(:,i);
	% Coordinate along the current path direction
	l_i = u' * [x_i; y_i];
	% Sort
	[l_i, o_i] = sort(l_i);
	x_i = x_i(o_i);
	y_i = y_i(o_i);
	% Delete duplicates.
	i_delete = [diff(l_i) <= x_tol, false];
	x_i = x_i(~i_delete);
	y_i = y_i(~i_delete);
	
	% Find the distance from each point to the polygon.
	d_i = point_line_distance(x_i, y_i, x, y)';
	% Check each distance.
	q_off = (d_i >= h - x_tol) & (d_i <= h*sqrt(2) + x_tol);
	% Test if each point is in the polygon
	q_poly = inpolygon(x_i, y_i, x, y);
	% Keep the points that pass both tests.
	x_i = x_i(q_poly & q_off);
	y_i = y_i(q_poly & q_off);
	
	% Get each midpoint.
	x_m = (x_i(1:end-1) + x_i(2:end)) / 2;
	y_m = (y_i(1:end-1) + y_i(2:end)) / 2;
	% Check if the midpoint is in the polygon.
	q_poly = inpolygon(x_m, y_m, x, y);
	% Get the distance to the polygon.
	d_m = point_line_distance(x_m, y_m, x, y);
	% Check the distance to the polygon.
	q_off = abs(d_m' - h) <= x_tol;
	% Valid segments
	q_seg = q_poly & q_off;
	
	% Loop through the remaining points.
	for j = 1:numel(x_i)-1
		% Check if it is a valid segment.
		if q_seg(j)
			% Current point.
			x_j = x_i(j);
			y_j = y_i(j);
			% Path index
			k = 0;
			% Whether or not link has been found.
			q_link = false;
			% Loop through the existing paths.
			while k < k_cur && ~q_link
				% Move to next path.
				k = k + 1;
				% Number of points in that path.
				m = m_path(k);
				% Get the midpoint of point j and the last point of path k.
				x_k = (x_j + X(m,k)) / 2;
				y_k = (y_j + Y(m,k)) / 2;
				% Test the midpoint.
				q_poly = inpolygon(x_k, y_k, x, y);
				q_off  = point_line_distance(x_k, y_k, x, y) >= h - x_tol;
				q_link = q_poly && q_off;
			end
			
			% Test if a link was found.
			if q_link
				% Current point is linked to existing offset path.
				m_cur = m_path(k) + 1;
				% Check if we need to add both points.
				if sum(abs([x_j-x_k, y_j-y_k])) > x_tol
					% Store the first point.
					X(m_cur, k) = x_i(j);
					Y(m_cur, k) = y_i(j);
					% Add a new point.
					m_cur = m_cur + 1;
				end
				% Store the new point.
				X(m_cur, k) = x_i(j+1);
				Y(m_cur, k) = y_i(j+1);
				% Update the number of points in that path.
				m_path(k) = m_cur;
				
			else
				% No link: new path
				k_cur = k_cur + 1;
				% Start the new path.
				m_cur = m_path(k_cur) + 1;
				% Store the start of the segment.
				X(m_cur, k_cur) = x_i(j);
				Y(m_cur, k_cur) = y_i(j);
				% Increase the number of points in that path to two.
				m_cur = m_cur + 1;
				% Store the end of the segment.
				X(m_cur, k_cur) = x_i(j+1);
				Y(m_cur, k_cur) = y_i(j+1);
				% Update the number of points in that path.
				m_path(k_cur) = m_cur;
				
			end
		end
	end
end

% Remove paths that weren't used.
X = X(:, m_path>0);
Y = Y(:, m_path>0);

% Combine to a single path.
X = X(:); Y = Y(:);

% Find all the NaNs.
XI = isnan(X);
% Keep the 
XI = [~XI(2:end) | ~XI(1:end-1); false];
% Only keep entries that are not followed by Nans.
X = X(XI);
Y = Y(XI);


% --- SUBFUNCTION 3: Intesection of polygon and line segment ---
function [intr_Q,x_intr,y_intr]=path_int_line(X,Y,x,y)
%
% intr_Q = path_int_line(X,Y,x,y)
% [intr_Q,x_intr,y_intr] = path_int_line(X,Y,x,y)
%
% INPUTS:
%         X      : array of x-coordinates of polygon
%         Y      : array of y-coordinates of polygon
%         x      : x-coordinates of line segment endpoints
%         y      : y-coordinates of line segment endpoints
%
% OUTPUTS:
%         intr_Q : true if the line has at least one intersection with the
%                   edge of the polygon
%         x_intr : x-coordinates of intersection points
%         y_intr : y-coordinates of intersection points
%
% This function returns a "true" output if a simple line segment (a path
% consisting of just two endpoints) has at least one intersection with the
% edges of a polygon.  It also returns the coordinates of the
% intersections.  If there are no intersection points, the coordinates will
% be returned as NaN.
%
% This function is almost exactly the same as poly_int_line, except that
% intersections with vertices are intentionally double-counted in this
% function.
%
% Versions:
%  07/29/10 @Derek Dalle     : First version
%
% GNU Library General Public License
%

% Initialize intersection test.
intr_Q   = false;

% Number of edges of polygon
n_edge   = numel(X);

% Initialize intersection list
x_intr   = zeros(n_edge, 1);
y_intr   = zeros(n_edge, 1);
n_intr   = 0;

% Check for valid number of inputs.
if nargin<4
  error('poly_int_line:NotEnoughInputs', ['Not enough input ', ...
    'arguments; at least 4 inputs are required']);
end
% Check for valid polygon.
if numel(Y) ~= n_edge
  error('poly_int_line:poly', ['Input polygon does not have the ', ...
    'same number of x- and y-coordinates']);
end
% Check for valid line
if numel(x)~=2 || numel(y)~=2
  error('poly_int_line:line', ['Input path must be a list of ', ...
    'exactly two points']);
end

% First polygon edge point.
x_2      = X(1);
y_2      = Y(1);

% Append first polygon vertex to end of list to get complete set of edges.
X        = [X(:); x_2];
Y        = [Y(:); y_2];

% Ensure column for line segment.
x        = x(:);
y        = y(:);

% Find the smallest rectangle containing the line segment.
x_min    = min(x); y_min    = min(y);
x_max    = max(x); y_max    = max(y);
% Find the smallest rectangle containing the polygon.
X_min    = min(X); Y_min    = min(Y);
X_max    = max(X); Y_max    = max(Y);

% Check if the rectangles containing the two paths overlap.
if ~(x_min>X_max || X_min>x_max || y_min>Y_max || Y_min>y_max)
  % Loop through edges of polygon
  for i=1:n_edge
    % Get edge endpoints.
    x_1 = x_2;
    y_1 = y_2;
    x_2 = X(i+1);
    y_2 = Y(i+1);
    % Check for intersection point of segment and edge.
    [int_Q,x_cur,y_cur] = line_int_line([x_1; x_2; x], [y_1; y_2; y]);
    
    % Store the point if necessary.
    if int_Q
      % Change intersection test to pass.
      intr_Q = true;
      % Increase the number of intersections.
      n_intr = n_intr + 1;
      % Store to the correct location
      x_intr(n_intr) = x_cur;
      y_intr(n_intr) = y_cur;
    end
  end
end

% Delete trailing zeros.
x_intr(n_intr+1:end) = [];
y_intr(n_intr+1:end) = [];


% --- SUBFUNCTION 4: Intersection of two lines ---
function [int_Q,x,y]=line_int_line(X,Y,int_Q)
%
% int_Q = line_int_line(X,Y)
% int_Q = line_int_line(X,Y,int_Q)
% [int_Q,x,y] = line_int_line(X,Y)
% [int_Q,x,y] = line_int_line(X,Y,int_Q)
%
% INPUTS:
%         X     : 4x1 or 1x4 array, [x11, x12, x21, x22]
%         Y     : 4x1 or 1x4 array, [y11, y12, y21, y22]
%         int_Q : (optional) whether or not the two lines intersect
%
% OUTPUTS:
%         int_Q : true if and only if the two lines intersect
%         x     : x-coordinate of intersection point
%         y     : y-coordinate of intersection point
%
% This function finds the intersection point of two line segments.  The
% first line has the vertices (x11,y11) and (x12,y12), and the second line
% has the vertices (x21,y21) and (x22,y22).  If the two line segments do
% not intersect, the returned intersection point is [NaN NaN].  If the two
% segments share a segment, the output is simply one of the points along
% the shared segment.
%
% The optional input can be used to save the time of the program checking
% if the two segments intersect, or it can be used to force the function to
% find the intersection of non-parallel lines (where the intersection point
% might not be part of either line segment).  The function can be used as
% an intersection test on its own using the second output.
%
% Versions:
%  04/03/09 @Derek Dalle     : First version
%  03/01/10 @Derek Dalle     : Changed the input format
%
% GPL Library license
%

% Smallest non-zero dot product
tol = 1e-8*max(max(X(:))-min(X(:)), max(Y(:))-min(Y(:)));
% Distribute points in the lines to points.
x_11 = X(1);                                  % x, point 1 of line 1
x_12 = X(2);                                  % x, point 2 of line 1
x_21 = X(3);                                  % x, point 1 of line 2
x_22 = X(4);                                  % x, point 2 of line 2
y_11 = Y(1);                                  % y, point 1 of line 1
y_12 = Y(2);                                  % y, point 2 of line 1
y_21 = Y(3);                                  % y, point 1 of line 2
y_22 = Y(4);                                  % y, point 2 of line 2
% Distribute points in the lines to points.
z_11  = [x_11, y_11];                         % point 1 of line 1
z_12  = [x_12, y_12];                         % point 2 of line 1
z_21  = [x_21, y_21];                         % point 1 of line 2
z_22  = [x_22, y_22];                         % point 2 of line 2
% Test for intersection of the two lines.
if nargin<3
  % Rotation matrix
  A     = [0,-1;1,0];
  % Line 1 normal
  n     = A*(z_12-z_11)';
  % Dot products of line 1 with segments connecting z11 to z21 and z22
  c_1   = (z_21-z_11)*n;
  c_2   = (z_22-z_11)*n;
  % Test if line 1 straddles line 2. ( -\- or -- \ )
	if sum(abs(n)) <= tol
		% Null input line
		int_Q = (norm(z_21-z_11) + norm(z_22-z_11)) == norm(z_22-z_21);
	elseif abs(c_1)<tol && abs(c_2)<tol
    % Parallel segments on same line ( --- or -- -- )
    int_Q =          ((z_21-z_11)*(z_21-z_12)'<=0);
    int_Q = int_Q || ((z_22-z_11)*(z_22-z_12)'<=0);
    int_Q = int_Q || ((z_21-z_11)*(z_22-z_11)'<=0);
    int_Q = int_Q || ((z_21-z_12)*(z_22-z_12)'<=0);
  elseif c_1*c_2 <= tol
    % Line 1 straddles line 2.
    % Line 2 normal
    n     = A*(z_22-z_21)';
    % Test if line 2 straddles line 1.
    int_Q = ((z_12-z_21)*n)*((z_11-z_21)*n) <= tol;
  else
    % Line 1 does not straddle line 2.
    int_Q = false;
  end
end
% Apply correct case.
if int_Q && nargout>1
  % Test if each line is vertical.
  vert_1 = abs(x_12-x_11)<tol;                % test if line 1 is vertical
  vert_2 = abs(x_22-x_21)<tol;                % test if line 2 is vertical
  % Calculate slopes for non-vertical lines.
  if ~vert_1
    m_1  = (y_12-y_11)/(x_12-x_11);           % slope of line 1
  end
  if ~vert_2
    m_2  = (y_22-y_21)/(x_22-x_21);           % slope of line 2
  end
  % Calculate intersection point.
  if (vert_1 && vert_2) || (~(vert_1 || vert_2) && (abs(m_1-m_2)<=tol))
    % Lines are parallel.
    % Try both endpoints of line 1.
    L_1  = norm(z_11 - z_12);                 % length of first segment
    L_2  = norm(z_21 - z_22);                 % length of second segment
    L_11 = norm(z_11 - z_21);                 % length from z_11 to z_21
    L_12 = norm(z_11 - z_22);                 % length from z_11 to z_22
    L_21 = norm(z_12 - z_21);                 % length from z_12 to z_21
    L_22 = norm(z_12 - z_22);                 % length from z_12 to z_22
    % Test if point (x_11,y_11) is on line 2 by comparing lengths.
    if abs(L_11 + L_12 - L_2) <= tol
      x     = x_11;
      y     = y_11;
    elseif abs(L_21 + L_22 - L_2) <= tol
      x     = x_12;
      y     = y_12;
    elseif abs(L_11 + L_21 - L_1) <= tol
      x     = x_21;
      y     = y_21;
    else
      x     = NaN;
      y     = NaN;
      int_Q = false;
    end
  elseif vert_1
    % Line 1 is vertical.
    x    = x_11;                              % x, intersection point
    y    = y_21+m_2*(x-x_21);                 % y, intersection point
  elseif vert_2
    % Line 2 is vertical.
    x    = x_21;                              % x, intersection point
    y    = y_11+m_1*(x-x_11);                 % y, intersection point
  else
    % Neither line is vertical
    y_10 = y_11 - m_1*x_11;                   % y-intercept, line 1
    y_20 = y_21 - m_2*x_21;                   % y-intercept, line 2
    x    = (y_20-y_10)/(m_1-m_2);             % x, intersection point
    y    = y_11 + m_1*(x-x_11);               % y, intersection point
  end
else
  % Lines do not intersect
  x      = NaN;
  y      = NaN;
end


% --- SUBFUNCTION 5: Distance from point to path ---
function d = point_line_distance(x, y, X, Y)
%
% d = point_line_distance(x, y, X, Y)
%
% INPUTS:
%         x : x-coordinates of points to test
%         y : y-coordinates of points to test
%         X : x-coordinates of path
%         Y : y-coordinates of path
%
% OUTPUTS:
%         d : shortest distance from each point to the path
%
% This function calculates the distance of the shortest line connecting
% each vertex to one of the paths.
%

% Versions:
%   2011.03.17 @Derek Dalle   : First version
%
% Public domain

% Ensure column
X = X(:); Y = Y(:);
x = x(:); y = y(:);

% Check for errors.
if numel(X) ~= numel(Y)
	% Mismatched number of points in path
	error('point_line_distance:MismatchPath', ...
		'Path has uneven number of points.');
elseif numel(x) ~= numel(y)
	% Mismatched number of points
	error('point_line_distance:MismatchPoitns', ...
		'Not matching number of x- and y-coordinates.');
end

% Find duplicates.
i_delete = [(diff(X) == 0 & diff(Y) == 0); false];
% Eliminate them.
X = X(~i_delete);
Y = Y(~i_delete);

% Grid of vertices
[xp, XP] = ndgrid(x, X);
[yp, YP] = ndgrid(y, Y);
% Coordinates of each point relative to each vertex
dx = xp - XP;
dy = yp - YP;
% Distance from each point to each vertex
D = sqrt(dx.*dx + dy.*dy);

% Vector along each segment.
U = [diff(X)'; diff(Y)'];
% Length of each segment.
L = sqrt(sum(U.*U));
% Unit vectors.
U = U ./ [L; L];
% Unit normals
N = [0, -1; 1, 0] * U;

% Number of points
n_points = numel(x);

% Grid for coordinates of unit vectors
UX = repmat(U(1,:), n_points, 1);
UY = repmat(U(2,:), n_points, 1);
% Grid for coordinates of unit normals
NX = repmat(N(1,:), n_points, 1);
NY = repmat(N(2,:), n_points, 1);

% Scaled streamwise coordinate of each point along each segment
S = (UX.*dx(:,1:end-1) + UY.*dy(:,1:end-1)) ./ repmat(L, n_points, 1);
% Normal coordinate of each point along each segment
N = abs((NX.*dx(:,1:end-1) + NY.*dy(:,1:end-1)));

% Delete normal coordinates for each segment that is not between the
% endpoints of a given segment.
N(S<0) = NaN;
N(S>1) = NaN;

% Calculate the minimum distance.
d = min([D, N], [], 2);
