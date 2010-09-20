function [X,Y,x_hash,y_hash]=hash_points(x,y,varargin)
%
% [X,Y,x_hash,y_hash] = hash_points(x,y,varargin)
%
% INPUTS:
%         x   : list of x-coordinates in linear path
%         y   : list of y-coordinates in linear path
%
% OUTPUTS:
%         X      : cell array of x-coords for polygons that contain hashes
%         Y      : cell array of y-coords for polygons that contain hashes
%         x_hash : x-coordinates of hash endpoints
%         y_hash : y-coordinates of hash endpoints
%
% This function takes as input a series of line segments and an offset
% distance and returns a polygon.  The purpose is to essentially to draw a
% version of the line with thickness h.  The output is a polygon that
% starts with the original path and then contains an offset path in reverse
% order.
%

% Versions:
%  07/30/10 @Derek Dalle     : First version
%
% GNU Library General Public License

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

% Number of optional arguments
n_arg = numel(varargin);

% Make an options structure.
if n_arg > 0 && (isstruct(varargin{1}) || isempty(varargin{1}))
	% Struct
	options = varargin{1};
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
	theta_hash = 51*pi/180;
end
% Width of polygon containing hashes
if isfield(options, 'HashWidth')
	hash_width = options.HashWidth;
else
	hash_width = 0.03*L_scale;
end
% Separation between hashes
if isfield(options, 'HashSeparation')
	hash_sep = options.HashSeparation;
else
	hash_sep = 0.02*L_scale;
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


% --- SUBFUNCTION 1: Wide brush path ---
function [X,Y]=offset_path(x,y,h)
%
% [X,Y] = offset_path(x,y,h)
%
% INPUTS:
%         x : list of x-coordinates in linear path
%         y : list of y-coordinates in linear path
%         h : offset distance of new path
%
% OUTPUTS:
%         X : list of x-coordinates in offset path
%         Y : list of y-coordinates in offset path
%
% This function takes as input a series of line segments and an offset
% distance and returns a polygon.  The purpose is to essentially to draw a
% version of the line with thickness h.  The output is a polygon that
% starts with the original path and then contains an offset path in reverse
% order.
%

% Versions:
%  07/23/10 @Derek Dalle     : First version
%
% GNU Library General Public License
%

% Number of points in x
n_vertex = numel(x);

% Test input.
if n_vertex~=numel(y)
  error('geom:nopoly',...
     'Dimensions of x and y in offset_path(x,y) must match.');
end

% Find extrema of polygon if there is a polygon.
if n_vertex > 0
  X_min    = min(x);
  X_max    = max(x);
  Y_min    = min(y);
  Y_max    = max(y);
  % Decide minimum nonzero distance.
  tol      = 1e-8 * max(X_max - X_min, Y_max - Y_min);
end

% Combine points into one variable.
z = [x(:)'; y(:)'];


% Initialize polygon.
Z = nan(2, 4*n_vertex);

% Put first point into polygon.
z_2 = z(:,n_vertex);
Z(:,1) = z_2;

% Rotation matrix
A = [0, -1; 1, 0];

% This is the index of the last point that has been added.
i_cur  = 1;
n_edge = 0;

% Magnitude of h.
ah = abs(h);

% This is just a switch that alternates each time a path is trimmed.
trim_Q = true;

% Loop through edges, starting from the end.
for j=1:n_vertex-1
	% End points
	z_1 = z_2;
	z_2 = z(:,end-j);
	% Calculate tangent vector of the segment.
	t = z_2 - z_1;
	% Length of the vector.
	l = norm(t);
	% Check for zero length.
	if abs(l) > tol
		% Unit tangent
		t = t/l;
		% Unit normal
		n = A*t;
		
		% Add first point.
		if i_cur == 1
			% First endpoint of offset path
			r_4 = z_1 + h*n;
		else
			% First endpoint of offset path
			r_4 = z_1 - ah*t + h*n;
		end
		
		% Last point of offset path
		if j == n_vertex - 1
			% For the last segment, don't go beyond the endpoint.
			r_3 = z_2 + h*n;
		else
			% Otherwise, go past the end of the segment.
			r_3 = z_2 + ah*t + h*n;
		end
	end
	
	% New line segment endpoints
	y_1 = Z(:,i_cur);
	y_2 = r_4;
	% Blindly add r_4 and worry about intersections later.
	i_cur  = i_cur  + 1;
	n_edge = n_edge + 1;
	Z(:,i_cur) = r_4;
	% Check intersections between new edge and existing edges.
	k_int = false(1, n_edge-2);
	z_int = nan(2, n_edge-2);
	% First point
	x_2 = Z(:,1);
	% Loop through available edges.
	for k=1:n_edge-2
		% Find endpoints of segment k.
		x_1 = x_2;
		x_2 = Z(:,k+1);
		% Calculate intersection.
		[k_int(k), z_int(:,k)] = ...
			line_int_line_pt(x_1, x_2, y_1, y_2);
	end
	
	% New line segment endpoints
	y_1 = y_2;
	y_2 = r_3;
	% Blindly add r_3 and worry about intersections later.
	i_cur  = i_cur  + 1;
	n_edge = n_edge + 1;
	Z(:,i_cur) = r_3;
	% Check intersections between new edge and existing edges.
	k_int = false(1, n_edge-2);
	z_int = nan(2, n_edge-2);
	% First point
	x_2 = Z(:,1);
	% Loop through available edges.
	for k=1:n_edge-2
		% Find endpoints of segment k.
		x_1 = x_2;
		x_2 = Z(:,k+1);
		% Calculate intersection.
		[k_int(k), z_int(:,k)] = ...
			line_int_line_pt(x_1, x_2, y_1, y_2);
	end
	
	% Indices of edges intersecting edges
	i_int = find(k_int);
	% Number of intersections
	n_int = numel(i_int);
	% Find the last segment if there are any intersections.
	if n_int > 0
		% Find previous endpoint of input path
		z_0 = z(:,end-j+2);
		% Calculate the cross product between the last two path vectors.
		c_1 = cross([z_1-z_0; 0], [z_2-z_1; 0]);
		% Calculate the cross product between the last two offset vectors.
		c_2 = cross([y_1-x_2; 0], [y_2-y_1; 0]);
	end
	
	% Delete the most recent segments if drawing the new segment causes 
	% the polygon to cross itself.  This will be the case if the last segment
	% traces in a direction opposite to that of the input path.
	if n_int >0 && c_1(3)*c_2(3) <= 0
		% Index of point to be replaced
		i_rep = i_int(end) + 1;
		% Replace the relevant point with the newly found intersection.
		Z(:,i_rep) = z_int(:,i_int(end));
		% Indices of points to be deleted
		i_del = i_rep+1:n_edge;
		n_del = numel(i_del);
		% Delete the points.
		Z(:,i_del) = [];
		i_cur  = i_cur  - n_del;
		n_edge = n_edge - n_del;
		n_int  = n_int  - 1;
	end
	
	% Loop through remaining pairs of intersections.
	for k=n_int:-2:2
		% Indices of edges that intersect current edge.
		i_1 = i_int(k-1);
		i_2 = i_int(k);
		% Replace first endpoint.
		Z(:,i_1+1) = z_int(:,i_1);
		if i_2 - i_1 > 1
			% Replace second endpoint.
			Z(:,i_2  ) = z_int(:,i_2);
			% Indices to delete
			i_del = i_1+1:i_2-2;
			% Delete the points.
			Z(:,i_del) = [];
			i_cur  = i_cur  - n_del;
			n_edge = n_edge - n_del;
		else
			% Shift points down one spot.
			Z(:,i_2+2:i_cur+1) = Z(:,i_2+1:i_cur);
			% Insert new endpoint.
			i_cur  = i_cur  + 1;
			n_edge = n_edge + 1;
			Z(:,i_2+1) = z_int(:,i_2);
		end
	end
	
	% If there is still an intersection left over, trim the current segment.
	if mod(n_int, 2) == 1
		% Index of intersection
		i_1 = i_int(1);
		% Replace the newest endpoint.
		if trim_Q
			Z(:,i_cur) = z_int(:,i_1);
		else
			Z(:,i_cur-1) = z_int(:,i_1);
		end
		% Toggle the switch of which point to remove.
		trim_Q = ~trim_Q;
	end
end

% If the last segment was trimmed, also trim the last segment.
if ~trim_Q
	% Endpoints of last segment
	y_1 = y_2;
	y_2 = z(:,1);
	% Endpoints of trimming segment
	x_1 = Z(:,i_1);
	x_2 = Z(:,i_1+1);
	% Find intersection.
	[k_int, z_int] = line_int_line_pt(x_1, x_2, y_1, y_2);
	% Append this point to the end.
	if k_int
		i_cur  = i_cur  + 1;
		Z(:,i_cur) = z_int;
	end
end

% Output
X = [x(:); Z(1,2:i_cur)'];
Y = [y(:); Z(2,2:i_cur)'];


% --- SUBFUNCTION 2: Intersection of two line segments ---
function [int_Q,z_0]=line_int_line_pt(z_1,z_2,z_3,z_4,int_Q)
%
% int_Q = line_int_line_pt(z_1,z_2,z_3,z_4)
% [int_Q,z_0] = line_int_line_pt(z_1,z_2,z_3,z_4)
% int_Q = line_int_line_pt(z_1,z_2,z_3,z_4,int_Q)
% [int_Q,z_0] = line_int_line_pt(z_1,z_2,z_3,z_4,int_Q)
%
% INPUTS:
%         z_1   : vertex of first segment
%         z_2   : vertex of first segment
%         z_3   : vertex of second segment
%         z_4   : vertex of second segment
%         int_Q : (optional) whether or not the two lines intersect
%
% OUTPUTS:
%         int_Q : true if and only if the two lines intersect
%         z_0   : intersection point
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
tol = 1e-8*max(norm(z_2-z_1), norm(z_4-z_3));
% Distribute points in the lines to points.
x_11 = z_1(1);                                % x, point 1 of line 1
x_12 = z_2(1);                                % x, point 2 of line 1
x_21 = z_3(1);                                % x, point 1 of line 2
x_22 = z_4(1);                                % x, point 2 of line 2
y_11 = z_1(2);                                % y, point 1 of line 1
y_12 = z_2(2);                                % y, point 2 of line 1
y_21 = z_3(2);                                % y, point 1 of line 2
y_22 = z_4(2);                                % y, point 2 of line 2
% Distribute points in the lines to points.
z_11  = [x_11, y_11];                         % point 1 of line 1
z_12  = [x_12, y_12];                         % point 2 of line 1
z_21  = [x_21, y_21];                         % point 1 of line 2
z_22  = [x_22, y_22];                         % point 2 of line 2
% Test for intersection of the two lines.
if nargin < 5
  % Rotation matrix
  A     = [0,-1;1,0];
  % Line 1 normal
  n     = A*(z_12-z_11)';
  % Dot products of line 1 with segments connecting z11 to z21 and z22
  c_1   = (z_21-z_11)*n;
  c_2   = (z_22-z_11)*n;
  % Test if line 1 straddles line 2. ( -\- or -- \ )
  if abs(c_1)<tol && abs(c_2)<tol
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
if int_Q && nargout > 1
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
      z_0(1) = x_11;
      z_0(2) = y_11;
    elseif abs(L_21 + L_22 - L_2) <= tol
      z_0(1) = x_12;
      z_0(2) = y_12;
    elseif abs(L_11 + L_21 - L_1) <= tol
      z_0(1) = x_21;
      z_0(2) = y_21;
    else
      z_0(1) = NaN;
      z_0(2) = NaN;
      int_Q  = false;
    end
  elseif vert_1
    % Line 1 is vertical.
    z_0(1) = x_11;                              % x, intersection point
    z_0(2) = y_21+m_2*(x_11-x_21);                 % y, intersection point
  elseif vert_2
    % Line 2 is vertical.
    z_0(1) = x_21;                              % x, intersection point
    z_0(2) = y_11+m_1*(x_21-x_11);                 % y, intersection point
  else
    % Neither line is vertical
    y_10   = y_11 - m_1*x_11;                   % y-intercept, line 1
    y_20   = y_21 - m_2*x_21;                   % y-intercept, line 2
    x      = (y_20-y_10)/(m_1-m_2);             % x, intersection point
		z_0(1) = x;
    z_0(2) = y_11 + m_1*(x-x_11);               % y, intersection point
  end
else
  % Lines do not intersect
  z_0(1) = NaN;
  z_0(2) = NaN;
end


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