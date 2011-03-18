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

% --- SUBFUNCTION 1: Test if two lines intersect ---
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
z_11 = [x_11, y_11];                         % point 1 of line 1
z_12 = [x_12, y_12];                         % point 2 of line 1
z_21 = [x_21, y_21];                         % point 1 of line 2
z_22 = [x_22, y_22];                         % point 2 of line 2
% Test for intersection of the two lines.
if nargin < 3
  % Rotation matrix
  A = [0,-1;1,0];
  % Line 1 normal
  n = A*(z_12-z_11)';
  % Dot products of line 1 with segments connecting z11 to z21 and z22
  c_1 = (z_21-z_11)*n;
  c_2 = (z_22-z_11)*n;
  % Test if line 1 straddles line 2. ( -\- or -- \ )
	if any(isnan([X(:); Y(:)]))
		% No line
		int_Q = false;
	elseif sum(abs(n)) <= tol
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
