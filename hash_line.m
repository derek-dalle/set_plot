function [h_1,h_2]=hash_line(x,y,varargin)
%
% hash_line(x,y, ... )
% [h_1,h_2] = hash_line(x,y, ... )
%
% INPUTS:
%         x   : list of x-coordinates in linear path
%         y   : list of y-coordinates in linear path
%
% OUTPUTS:
%         h_1 : handle for the hash line figure
%         h_2 : handle for background polygon
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
hash_width     = 0.05*L_scale;
hash_sep       = 0.02*L_scale;
hash_thickness = NaN;
line_thickness = NaN;

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

% Initialize the paths.
X = cell(n_path, 1);
Y = cell(n_path, 1);

% Loop through the segments.
for k = 1:n_path
	% Indices of current segment
	j_1 = i_1(k);
	j_2 = i_2(k);
	% First draw the offset path.
	[X{k}, Y{k}] = offset_path(x(j_1:j_2), y(j_1:j_2), hash_width);
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

keyboard


