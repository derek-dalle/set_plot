function h_t = xtick_vertical(s_x, h_a)
%XTICK_VERTICAL Produce vertical tick labels on the x-axis
%
% CALL:
%    xtick_vertical(s_x)
%    xtick_vertical(s_x, h_a)
%    h_t = xtick_vertical(s_x, h_a)
%
% INPUTS:
%    s_x : cell array of strings for x-axis tick labels
%    h_a : (optional) axis handle; GCA used if only one input
%
% OUTPUTS:
%    h_t : handle to tick label object
%
% This function facilitates vertical labels for the x-axis.  To use it,
% simply specify the list of strings to use for the labels.  However, the
% number of strings in s_x should match the number of ticks on the existing
% x-axis.  If the number of strings does not match the number of existing
% ticks, the function will attempt to match as many labels as possible to
% integer x-coordinates.
%

%----------------------------------------------------------------------
% Copyright (c) 2011-2013
%   Derek J. Dalle <derek.dalle@gmail.com> and
%   Sean M. Torrez <smtorrez@umich.edu>
%
% Distributed under the terms of the Modified BSD License.
%
% The full license is available in the file LICENSE, distributed with
% this software package in the top-level directory.
%----------------------------------------------------------------------

% Versions:
%  2012-04-20 @dalle   : First version

% Check for enough inputs.
if nargin < 1
	% Not enough inputs
	error('MATLAB:minrhs', 'Not enough inputs.')
end

% Check for an axis handle.
if nargin < 2
	% Use GCA.
	h_a = gca;
end

% Check the type of the first input.
if iscell(s_x)
	% Ensure column
	s_x = s_x(:);
	% Number of strings
	n_s = numel(s_x);
elseif ischar(s_x)
	% Number of rows
	n_s = size(s_x, 1);
else
	% Bad type
	error('set_plot:BadStringInput', ['Input must be either a ', ...
		'cell array of strings or a char array.']);
end

% Get the ticks
t_x = get(h_a, 'XTick');

% Clear out the existing tick labels.
set(h_a, 'XTickLabel', []);

% Number of ticks
n_t = numel(t_x);

% Options for the TEXT command
o_text = struct( ...
	'HorizontalAlignment', 'right', ...
	'Rotation'           , 90     , ...
	'Parent'             , h_a    );

% Get the limits of the y-axis
y_lim = get(h_a, 'YLim');

% Position of upper limit of the labels
if strcmp(get(h_a, 'YScale'), 'log')
	% Logarithmic y-axis
	y_p = y_lim(1)*10^(-0.025*diff(log10(y_lim)));
else
	% Linear y-axis
	y_p = y_lim(1) - 0.025*diff(y_lim);
end

% Check for matching number of ticks
if n_t == n_s
	% Draw the labels where they are.
	h = text(t_x, y_p*ones(1,n_t), s_x, o_text);
else
	% Get the range of integers.
	i_x = ceil(t_x(1)) : floor(t_x(end));
	% Number of integers
	n_i = numel(i_x);
	% Check if this exceeds the number of labels.
	if n_i < n_s
		% Cut out some of the labels.
		s_x = s_x(1:n_i);
	elseif n_i > n_s
		% Chop some of the integers.
		i_x = i_x(1:n_s);
		% Change the number of ticks.
		n_i = n_s;
	end
	% Draw the labels at the first available integers.
	h = text(i_x, y_p*ones(1,n_i), s_x, o_text);
	% Delete the other ticks.
	set(h_a, 'XTick', i_x);
end

% Check for an output.
if nargout > 0
	% Assign the output.
	h_t = h;
end
