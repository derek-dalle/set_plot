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
if q_int && numel(d_i) > 0
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

