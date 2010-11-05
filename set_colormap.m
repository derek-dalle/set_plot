function set_colormap(varargin)
% 
% set_colormap('ColorScheme')
% set_colormap(h_f, 'ColorScheme')
% cmap = set_colormap(...)
%
% INPUTS:
%         h_f : figure handle (default is gcf)
%
% 
% OUTPUTS:
%         cmap : the Nx3 colormap used
%
% This function edits a colormap with dramatically more options than the
% built-in colormap function.  In addition to the built-in colormaps, this
% function recognizes eight monochromatic that are based on the primary and
% secondary colors and black and white.  Thus the following example will
% produce a colormap going from White to Blue to DarkBlue.
%
%     set_colormap blue
%
% There is also the option to reverse any colormap by using a prefix.
%
%     set_colormap reverse-blue
%     set_colormap reverse-jet
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
if n_arg < i_arg
	% Not enough inputs
	error('set_colormap:NotEnoughInputs', 'No colormap input.');
elseif n_arg - i_arg > 1
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
		error('set_colormap:ColorMap', ['ColorMap must be a ', ...
			'cell array, recognized string, or an Nx3 matrix.']);
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
		error('set_colormap:ColorMap', ['ColorMap must be a ', ...
			'cell array, recognized string,, cell array, or an Nx3 matrix.']);
	end
	
	% Apply the new color map.
	set(h_f, 'ColorMap', v_cmap)

elseif iscell(s_cmap)
	% Dimensions of cell array.
	s_cell = size(s_cmap);
	% Determine the type 
	if isempty(s_cmap) || numel(s_cell) ~= 2
		% Bad input
		error('set_colormap:BadCell', ['Cell array colormap ', ...
			'must be either one- or two-dimensional.']);
	elseif min(s_cell) == 1
		% One-dimensional cell array
		% First element
		s_1 = s_cmap{1};
		% Check the first element.
		if isnumeric(s_1)
			% If it's a 1x3 vector, it's a color.
			if all(size(s_1) == [1 3])
				% List of colors
				c_cmap = s_cmap;
				% Regular interpolation
				i_cmap = linspace(0, 1, numel(c_cmap));
			elseif numel(s_1) == numel(s_cmap) - 1
				% List of colors
				c_cmap = s_cmap(2:end);
				% Manual interpolation
				i_cmap = s_1;
			elseif numel(s_1) == 1
				% Alternating interpolation values and colors
				% List of colors
				c_cmap = s_cmap(2:2:end);
				% Manual interpolation
				i_cmap = [ s_cmap{1:2:end} ];
			else
				% Bad input
				error('set_colormap:BadColorList', ['First element ', ...
					'of cell array must be a color or list of ', ...
					'interpolation values.']);
			end
		else
			% List of colors
			c_cmap = s_cmap;
			% Regular interpolation
			i_cmap = linspace(0, 1, numel(c_cmap));
		end
	elseif min(s_cell) > 2
		% Too large of color array.
		error('set_colormap:BadCell2', ['Two-dimensional cell ', ...
			'array must be Nx2 or 2xN.']);
	else
		% Two-dimensional cell array
		% Three critical elements
		s_11 = s_cmap{1,1};
		s_12 = s_cmap{1,2};
		s_21 = s_cmap{2,1};
		% Test if each is a scalar.
		q_11 = isnumeric(s_11) && numel(s_11) == 1;
		q_12 = isnumeric(s_12) && numel(s_12) == 1;
		q_21 = isnumeric(s_21) && numel(s_21) == 1;
		% Test these to find the interpolation values.
		if q_11 && q_12
			% Top row
			% List of colors
			c_cmap = s_cmap(2,:);
			% Manual interpolation
			i_cmap = [ s_cmap{1,:} ];
		elseif q_11 && q_21
			% Left column
			% List of colors
			c_cmap = s_cmap(:,2);
			% Manual interpolation
			i_cmap = [ s_cmap{:,1} ];
		elseif q_12
			% Bottom row
			% List of colors
			c_cmap = s_cmap(1,:);
			% Manual interpolation
			i_cmap = [ s_cmap{2,:} ];
		elseif q_21
			% Right column
			% List of colors
			c_cmap = s_cmap(:,1);
			% Manual interpolation
			i_cmap = [ s_cmap{:,1} ];
		else
			error('set_colormap:BadCell2', ['One of the rows or ', ...
				'columns must consist entirely of scalars.']);
		end
	end
	
	% Initialize rgb colors
	v_cmap = zeros(numel(c_cmap), 3);
	% Convert each color into a rgb color.
	for i = 1:numel(c_cmap)
		% Current color
		c_cur = c_cmap{i};
		% Check if it already is an rgb color.
		if isnumeric(c_cur)
			% Check if it has the right size
			if numel(c_cur) == 3
				% Store it.
				v_cmap(i,:) = c_cur(:)';
			else
				% Bad color
				error('set_colormap:BadColor', ['Each color must be ', ...
					'either a built-in color string, an HTML color name, ', ...
					'or a three-element vector.']);
			end
		elseif ischar(c_cur)
			% Check for a conversion.
			v_cur = html2rgb(c_cur);
			% Check for success.
			if any(isnan(v_cur))
				% Bad color
				error('set_colormap:NoColor', ['Color named %s ', ...
					'was not recognized.'], c_cur);
			else
				% Store the color.
				v_cmap(i,:) = v_cur;
			end
		else
			% Bad color
			error('set_colormap:BadColor', ['Each color must be ', ...
				'either a built-in color string, an HTML color name, ', ...
				'or a three-element vector.']);
		end
	end
	
	% Expand the colormap.
	v_cmap = interp1(i_cmap, v_cmap, linspace(0, 1, 64));
	% Apply it.
	set(h_f, 'ColorMap', v_cmap);
	
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
	error('set_colormap:ColorMap', ['ColorMap must be a ', ...
		'cell array, recognized string, or an Nx3 matrix.']);
	
end