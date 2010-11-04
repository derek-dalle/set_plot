function set_colormap(varargin)
% 
% set_colormap('ColorScheme')
% set_colormap(h_f, 'ColorScheme')
%
% INPUTS:
%         h_f : figure handle (default is gcf)
%
% 
% OUTPUTS:
%
%
% 
%

% Versions:
%  2010/11/04 @Derek Dalle    : Branched from set_plot
%
% Public domain

% Number of varargs
n_arg = length(varargin);
% Set index of current input.
i_arg = 1;
% Check first input.
if n_arg > 0 && isnumeric(varargin{1})
	% First input is figure handle.
	h_f = varargin{1};
	% Move to next argument.
	i_arg = 2;
else
	% Just use gcf.
	h_f = gcf;
end

% Check the number of remaining arguments.
if n_arg - i_arg > 1
	% Get the first argument.
	s_cmap = varargin(i_arg:n_arg);
else
	% Only one value.
	s_cmap = varargin{i_arg};
end



% Check the type of the variable
if isnumeric(s_cmap)
	% Number of rows in matrix
	size_cmap = size(s_cmap);
	% Check if the matrix has the right number of columns.
	if numel(size_cmap) ~= 2
		% Bad input
		error('set_plot:ColorMap', ['ColorMap must be a ', ...
			'recognized string or an Nx3 matrix.']);
	elseif size_cmap(2) == 3
		% Check if only one color is given.
		if size(s_cmap, 1) == 1
			% Interpolate from black.
			v_cmap = interp1([0, 1], s_cmap, linspace(0, 1, 64));
		elseif size(s_cmap, 1) < 32
			% Equal intervals from 0 to 1
			i_cmap = linspace(0, 1, size_cmap(1));
			% Interpolate the colors.
			v_cmap = interp1(i_cmap, s_cmap, linspace(0, 1, 64));
		end
	elseif size(c_style, 2) == 4
		% Interpolate based on the first column.
		i_cmap = s_cmap(:,1);
		v_cmap = s_cmap(:,2:4);
		% Prepend the map if necessary.
		if abs(i_cmap(1)) > 1e-8
			% Get the prepend color.
			v_1_cmap = v_cmap(:,1) >= 0.5;
			% Prepend.
			i_cmap = [0; i_cmap];
			v_cmap = [v_1_cmap; v_cmap];
		end
		% Append the map if necessary.
		if abs(i_cmap(end) - 1) > 1e-8
			% Get the append color.
			v_1_cmap = v_cmap(:,end) >= 0.5;
			% Append.
			i_cmap = [i_cmap; 1];
			v_cmap = [v_cmap; v_1_cmap];
		end
		% Interpolate the colors.
		v_cmap = interp1(i_cmap, v_cmap, linspace(0, 1, 64));
	else
		% Bad input
		error('set_plot:ColorMap', ['ColorMap must be a ', ...
			'recognized string, cell array, or an Nx3 matrix.']);
	end
	
	% Apply the new color map.
	set(h_f, 'ColorMap', v_cmap)

elseif iscell(s_cmap)
	
	
elseif ischar(s_cmap)
	% Check if string begins with 'reverse-'.
	if numel(s_cmap) > 7 && strcmpi(s_cmap(1:8), 'reverse-')
		% Drop the first few characters.
		s_cmap = s_cmap(9:end);
		% Store parameter to reverse the colormap.
		q_cmap_reverse = true;
	else
		% Don't reverse the colormap.
		q_cmap_reverse = false;
	end
	
	% Try to use a custom colormap.
	q_cmap_custom = true;
	% Look for the eight custom colormaps.
	if strcmpi(s_cmap, 'b') || strcmpi(s_cmap, 'blue')
		% White - Blue - DarkBlue map
		v_cmap = [1, 1, 1; 0, 0, 1; 0, 0, 139/255];
	elseif strcmpi(s_cmap, 'r') || strcmpi(s_cmap, 'red')
		% White - Red - Black map
		v_cmap = [1, 1, 1; 1, 0, 0; 0, 0, 0];
	elseif strcmpi(s_cmap, 'g') || strcmpi(s_cmap, 'green')
		% White - Green - Black map
		v_cmap = [1, 1, 1; 0, 1, 0; 0, 0, 0];
	elseif strcmpi(s_cmap, 'y') || strcmpi(s_cmap, 'yellow')
		% White - Yellow - Gold map
		v_cmap = [1, 1, 1; 1, 1, 0; 1, 215/255, 0];
	elseif strcmpi(s_cmap, 'm') || strcmpi(s_cmap, 'magenta')
		% White - Magenta - DarkMagenta map
		v_cmap = [1, 1, 1; 1, 0, 1; 139/255, 0, 139/255];
	elseif strcmpi(s_cmap, 'c') || strcmpi(s_cmap, 'cyan')
		% White - Cyan - Blue map
		v_cmap = [1, 1, 1; 0, 1, 1; 0, 0, 1];
	elseif strcmpi(s_cmap, 'w')
		% White - LightGrey - Grey map
		v_cmap = [255, 255, 255; 211, 211, 211; 128, 128, 128]/255;
	elseif strcmpi(s_cmap, 'k') || strcmpi(s_cmap, 'black')
		% LightGrey - DarkGray - Black map
		v_cmap = [211, 211, 211; 169, 169, 169; 0, 0, 0]/255;
	else
		% No custom map found.
		q_cmap_custom = false;
	end
	
	% Check if a custom colormap was found.
	if q_cmap_custom
		% Spacing for initial map.
		i_cmap = linspace(0, 1, size(v_cmap, 1));
		% Interpolate into a full map.
		v_cmap = interp1(i_cmap, v_cmap, linspace(0, 1, 64));
		% Apply the colormap.
		set(h_f, 'ColorMap', v_cmap);
	else
		% Find the current axes
		h_a = get(h_f, 'CurrentAxes');
		% Try to apply the built-in colormap.
		colormap(h_a, s_cmap);
	end
	
	% Check if the colormap should be reversed.
	if q_cmap_reverse
		% Get the current colormap.
		v_cmap = get(h_f, 'ColorMap');
		% Apply the reversed version.
		set(h_f, 'ColorMap', flipud(v_cmap));
	end
	
else
	% Bad input
	error('set_plot:ColorMap', ['ColorMap must be a ', ...
		'recognized string or an Nx3 matrix.']);
	
end