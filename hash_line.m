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
%  07/29/10 @Derek Dalle     : First version
%
% GNU Library General Public License

% Ensure column.
x = x(:);
y = y(:);

% Default option values
hash_thickness = 1;
line_thickness = 3;

% Find the thickness of the hash region normal to the input.
for i=1:2:numel(varargin)
	switch varargin{i}
		case 'HashLineWidth'
			hash_thickness = varargin{i+1};
		case 'LineWidth'
			line_thickness = varargin{i+1};
	end
end

% Calculate the relevant geometry.
[X, Y, x_hash, y_hash] = hash_points(x, y, varargin{:});

% Number of disjoint paths
n_path = numel(X);

% Initialize the handles.
h_3 = zeros(n_path, 1);

% Overlay the new graphics.
hold on

% Loop through the segments.
for k = 1:n_path
	% Draw the first polygon.
	h_3(k) = fill(X{k}, Y{k}, 'w', 'EdgeAlpha', 0);
end

% Draw the main line.
h_1 = plot(x, y, 'LineWidth', line_thickness, 'Color', 'k');

% Draw the hashes.
h_2 = plot(x_hash, y_hash, 'LineWidth', hash_thickness, 'Color', 'k');

