function set_colormap(varargin)
% 
% set_colormap(colorString)
% set_colormap(colorCell)
% set_colormap(colorMap)
% set_colormap(colorName1, colorName2, ...)
% set_colormap(colorVal1, colorName1, ...)
% set_colormap(colorVals, colorName1, ...)
% set_colormap(h_f, ...)
% cmap = set_colormap(...)
%
% INPUTS:
%         h_f         : figure handle (default is gcf)
%         colorString : name of custom or built-in colormap (notes 1-3)
%         colorCell   : cell array of colors or colors and values (note 7)
%         colorMap    : Nx3 or Nx4 matrix (note 4)
%         colorName1  : RGB color or HTML color (note 5)
%         colorVal1   : scalar for interpolation (note 6)
%         colorVals   : list of scalars for interpolation (note 6)
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
% The user can also use a pre-defined colormap using the following command.
%
%     set_colormap(cmap)
%
% Here cmap is an Nx3 or Nx4 matrix of RGB colors.  Finally, this function
% provides several ways to construct a colormap manually.  The following
% example shows how to construct a map that goes through a certain range of
% colors based on common names.
%
%     set_colormap('Navy', 'Blue', 'White')
%
% The user may also change the values to which each color corresponds.
%
%     set_colormap({0, 'Navy', 0.2, 'Blue', 1, 'White'})
%
% The function will recognize any of the typical web browser color names.
%
% NOTES:
%       (1) The built-in colormaps can be viewed by looking at "colormap"
%           the Matlab help browser.  They are autumn, bone, colorcube,
%           cool, copper, flag, gray, hot, hsv, jet, lines, pink, prism,
%           spring, summer, white, and winter.
%
%       (2) The custom colormaps defined here are black, blue, cyan, green,
%           magenta, red, white, and yellow.  They can also be aliased
%           using the single-character abbreviations k, b, c, g, m, r, w,
%           and y, respectively.
%
%       (3) Any of the string colormaps can be reversed by prepending the
%           string with 'reverse-', for example, reverse-jet and reverse-b.
%
%       (4) The colormap can also be described using a matrix.  This matrix
%           can be an Nx3 matrix, which is the typical format for Matlab
%           colormaps.  In this case each row refers to a red,green,blue
%           color.  The matrix can also be an Nx4 matrix, in which case the
%           first column gives a value to associate with each color.
%
%       (5) Colors listed individually can be either an RGB color, which is
%           a 1x3 double, or an HTML color, which is a string containing
%           the name of a common color.  A full list can be found at
%           <http://www.w3schools.com/html/html_colornames.asp>.
%
%       (6) The colormap associates a color for each number in the range of
%           0 to 1.  By default, the colors are spaced out equally, but
%           this may not always be what the user wants.  The values can be
%           given alternating with the colors or a list of interpolation
%           values followed by a list of colors.
%
%       (7) A cell array can also be used.  The cell array consists of
%           either a list of colors or a column of values and a column of
%           colors or a row of values and a row of colors.
%

% Versions:
%  2010/11/04 @Derek Dalle    : Branched from set_plot
%  2010/11/05 @Derek Dalle    : First version
%
% Public domain

% Number of varargs
n_arg = length(varargin);
% Check first input.
if n_arg > 0 && isnumeric(varargin{1}) && numel(varargin{1})==1
	% First input is figure handle.
	h_f = varargin{1};
	% Move to next argument.
	i_arg = 2;
else
	% Just use gcf.
	h_f = gcf;
	% Set index of current input.
	i_arg = 1;
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

% Don't reverse the colormap by default.
q_cmap_reverse = false;

% Check for a simple string input.
if ischar(s_cmap)
	% Check if string begins with 'reverse-'.
	if numel(s_cmap) > 7 && strcmpi(s_cmap(1:8), 'reverse-')
		% Drop the first few characters.
		s_cmap = s_cmap(9:end);
		% Store parameter to reverse the colormap.
		q_cmap_reverse = true;
	end
	
	% Try to use a custom colormap.
	q_cmap_custom = true;
	% Look for the eight custom colormaps.
	if strcmpi(s_cmap, 'b') || strcmpi(s_cmap, 'blue')
		% White - Blue - DarkBlue map
		s_cmap = {'White', 'Blue', 'DarkBlue'};
	elseif strcmpi(s_cmap, 'r') || strcmpi(s_cmap, 'red')
		% White - Red - Black map
		s_cmap = {'White', 'Red', 'Black'};
	elseif strcmpi(s_cmap, 'g') || strcmpi(s_cmap, 'green')
		% White - Green - Black map
		s_cmap = {'White', 'Lime', 'Black'};
	elseif strcmpi(s_cmap, 'y') || strcmpi(s_cmap, 'yellow')
		% White - Yellow - Gold map
		s_cmap = {'White', 'Yellow', 'Gold'};
	elseif strcmpi(s_cmap, 'm') || strcmpi(s_cmap, 'magenta')
		% White - Magenta - DarkMagenta map
		s_cmap = {'White', 'Magenta', 'DarkMagenta'};
	elseif strcmpi(s_cmap, 'c') || strcmpi(s_cmap, 'cyan')
		% White - Cyan - Blue map
		s_cmap = {'White', 'Cyan', 'Blue'};
	elseif strcmpi(s_cmap, 'w')
		% White - LightGrey - Grey map
		s_cmap = {'White', 'LightGray', 'Gray'};
	elseif strcmpi(s_cmap, 'k') || strcmpi(s_cmap, 'black')
		% LightGrey - DarkGray - Black map
		s_cmap = {'LightGray', 'DarkGray', 'Black'};
	else
		% No custom map found.
		q_cmap_custom = false;
		% Find the current axes
		h_a = get(h_f, 'CurrentAxes');
		% Try to apply the built-in colormap.
		colormap(h_a, s_cmap);
	end
end



% Check the type of the variable.
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
	% Prevent overflow.
	v_cmap = max(0, min(1, v_cmap));
	% Apply it.
	set(h_f, 'ColorMap', v_cmap);
	
elseif ischar(s_cmap) && ~q_cmap_custom
	% Do nothing.
	
else
	% Bad input
	error('set_colormap:ColorMap', ['ColorMap must be a ', ...
		'cell array, recognized string, or an Nx3 matrix.']);
	
end
	
% Check if the colormap should be reversed.
if q_cmap_reverse
	% Get the current colormap.
	v_cmap = get(h_f, 'ColorMap');
	% Apply the reversed version.
	set(h_f, 'ColorMap', flipud(v_cmap));
end


% --- SUBFUNCTION 1: Convert HTML color string to RGB color triple ---
function v_rgb = html2rgb(s_html)
%
% v_rgb = html2rgb(s_html)
%
% INPUTS:
%         s_html : name of an HTML color (string)
%
% OUTPUTS:
%         v_rgb  : 1x3 vector corresponding to red, green, and blue
%
% This function converts an HTML color name to a RGB color.  If the input
% is not recognized, the returned color is nan(1,3).
%

% Versions:
%  2010/11/04 @Derek Dalle    : First version
%
% Public domain

% Check for sufficient inputs.
if nargin < 1
	error('html2rgb:NotEnoughInputs', 'Not enough inputs');
end

% Check that the input is a string.
if ~ischar(s_html)
	error('html2rgb:NotString', 'Input must be a string.');
end

% Color table
s_colors = {
	'AliceBlue',             [240, 248, 255];
	'AntiqueWhite',          [250, 235, 215];
	'Aqua',                  [  0, 255, 255];
	'Aquamarine',            [127, 255, 212];
	'Azure',                 [240, 255, 255];
	'B',                     [  0,   0, 255];
	'Beige',                 [245, 245, 220];
	'Bisque',                [255, 228, 196];
	'Black',                 [  0,   0,   0];
	'BlanchedAlmond',        [255, 235, 205];
	'Blue',                  [  0,   0, 255];
	'BlueViolet'             [138,  43, 226];
	'Brown',                 [165,  42,  42];
	'BurlyWood',             [222, 184, 135];
	'C',                     [  0, 255, 255];
	'CadetBlue',             [ 95, 158, 160];
	'Chartreuse',            [127, 255,   0];
	'Chocolate',             [210, 105,  30];
	'Coral',                 [255, 127,  80];
	'CornflowerBlue',        [100, 149, 237];
	'Cornsilk',              [255, 248, 220];
	'Crimson',               [220,  20,  60];
	'Cyan',                  [  0, 255, 255];
	'DarkBlue',              [  0,   0, 139];
	'DarkCyan',              [  0, 139, 139];
	'DarkGoldenRod',         [184, 134,  11];
	'DarkGray',              [169, 169, 169];
	'DarkGrey',              [169, 169, 169];
	'DarkGreen',             [  0, 100,   0];
	'DarkKhaki',             [189, 183, 107];
	'DarkMagenta',           [139,   0, 139];
	'DarkOliveGreen',        [ 85, 107,  47];
	'DarkOrange',            [  0, 100,   0];
	'DarkOrchid',            [153,  50, 204];
	'DarkRed',               [139,   0,   0];
	'DarkSalmon',            [233, 150, 122];
	'DarkSeaGreen',          [143, 188, 143];
	'DarkSlateBlue',         [ 72,  61, 139];
	'DarkSlateGray',         [ 47,  79,  79];
	'DarkTurquoise',         [  0, 206, 209];
	'DarkViolet',            [148,   0, 211];
	'DeepPink',              [255,  20, 147];
	'DeepSkyBlue',           [  0, 191, 255];
	'DimGray',               [105, 105, 105];
	'DodgerBlue',            [ 30, 144, 255];
	'FireBrick',             [178,  34,  34];
	'FloralWhite',           [255, 250, 240];
	'ForestGreen',           [ 34, 139,  34];
	'Fuchsia',               [255,   0, 255];
	'G',                     [  0, 128,   0];
	'Gainsboro',             [220, 220, 220];
	'GhostWhite',            [248, 248, 255];
	'Gold',                  [255, 215,   0];
	'GoldenRod',             [218, 165,  32];
	'Gray',                  [128, 128, 128];
	'Grey',                  [128, 128, 128];
	'Green',                 [  0, 128,   0];
	'GreenYellow',           [173, 255,  47];
	'HoneyDew',              [240, 255, 240];
	'HotPink',               [255, 105, 180];
	'IndianRed',             [205,  92,  92];
	'Indigo',                [ 75,   0, 130];
	'Ivory',                 [255, 255, 240];
	'K',                     [  0,   0,   0];
	'Khaki',                 [240, 230, 140];
	'Lavender',              [230, 230, 250];
	'LavenderBlush',         [255, 240, 245];
	'LawnGreen',             [124, 252,   0];
	'LemonChiffon',          [255, 250, 205];
	'LightBlue',             [173, 216, 230];
	'LightCoral',            [240, 128, 128];
	'LightCyan',             [224, 255, 255];
	'LightGoldenRodYellow',  [250, 250, 210];
	'LightGray',             [211, 211, 211];
	'LightGrey',             [211, 211, 211];
	'LightGreen',            [144, 238, 144];
	'LightPink',             [255, 182, 193];
	'LightSalmon',           [255, 160, 122];
	'LightSeaGreen',         [ 32, 178, 170];
	'LightSkyBlue',          [135, 206, 250];
	'LightSlateGray',        [119, 136, 153];
	'LightSteelBlue',        [176, 196, 222];
	'LightYellow',           [255, 255, 224];
	'Lime',                  [  0, 255,   0];
	'LimeGreen',             [ 50, 205,  50];
	'Linen',                 [250, 240, 240];
	'M',                     [255,   0, 255];
	'Magenta',               [255,   0, 255];
	'Maroon',                [128,   0,   0];
	'MediumAquaMarine',      [102, 205, 170];
	'MediumBlue',            [  0,   0, 170];
	'MediumOrchid',          [186,  85, 211];
	'MediumPurple',          [147, 112, 216];
	'MediumSeaGreen',        [ 60, 179, 113];
	'MediumSlateBlue',       [123, 104, 238];
	'MediumSpringGreen',     [  0, 250, 154];
	'MediumTurquoise',       [ 72, 209, 204];
	'MediumVioletRed',       [199,  21, 133];
	'MidnightBlue',          [ 25,  25, 112];
	'MintCream',             [245, 255, 250];
	'MistyRose',             [255, 228, 225];
	'Moccasin',              [255, 228, 181];
	'NavajoWhite',           [255, 222, 173];
	'Navy',                  [  0,   0, 128];
	'OldLace',               [253, 245, 230];
	'Olive',                 [128, 128,   0];
	'OliveDrab',             [107, 142,  35];
	'Orange',                [255, 165,   0];
	'OrangeRed',             [255,  69,   0];
	'Orchid',                [218, 112, 214];
	'PaleGoldenRod',         [238, 232, 170];
	'PaleGreen',             [152, 251, 152];
	'PaleTurquoise',         [175, 238, 238];
	'PaleVioletRed',         [216, 112, 147];
	'PapayaWhip',            [255, 239, 213];
	'PeachPuff',             [255, 218, 185];
	'Peru',                  [205, 133,  63];
	'Pink',                  [255, 192, 204];
	'Plum',                  [221, 160, 221];
	'PowderBlue',            [172, 224, 230];
	'Purple',                [128,   0, 128];
	'R',                     [255,   0,   0];
	'Red',                   [255,   0,   0];
	'RosyBrown',             [188, 143, 188];
	'RoyalBlue',             [ 65, 105, 225];
	'SaddleBrown',           [139,  69,  19];
	'Salmon',                [250, 128, 114];
	'SandyBrown',            [244, 164,  96];
	'SeaGreen',              [ 46, 139,  87];
	'SeaShell',              [255, 245, 238];
	'Sienna',                [160,  82,  45];
	'Silver',                [192, 192, 192];
	'SkyBlue',               [135, 206, 235];
	'SlateBlue',             [106,  90, 205];
	'SlateGray',             [112, 128, 144];
	'Snow',                  [255, 250, 250];
	'SpringGreen',           [  0, 255, 127];
	'SteelBlue',             [ 70, 130, 180];
	'Tan',                   [210, 180, 140];
	'Teal',                  [  0, 128, 128];
	'Thistle',               [216, 191, 216];
	'Tomato',                [255,  99,  71];
	'Turquoise',             [ 64, 224, 208];
	'Violet',                [238, 130, 238];
	'W',                     [255, 255, 255];
	'Wheat',                 [245, 222, 179];
	'White',                 [255, 255, 255];
	'WhiteSmoke',            [245, 245, 245];
	'Y',                     [255, 255,   0];
	'Yellow',                [255, 255,   0];
	'YellowGreen',           [154, 205,  50];
	};

% Find the location of the string in the first column.
i_html = cell_position_string(s_colors(:,1), s_html);

% Check if a match was found.
if numel(i_html) == 1
	% Normalize colors into [0,1] range.
	v_rgb = s_colors{i_html,2} / 255;
else
	% No color was found.
	v_rgb = nan(1,3);
end


% --- SUBFUNCTION 2: Find the location of the matching string ---
function i=cell_position_string(S,str)
%
% i=position(S,x,tol)
%
% INPUTS:
%         S   : cell array of strings
%         str : targeted string
%
% OUTPUTS:
%         i   : indices of locations of str in S
%
% This function finds the location of entries in S that match the string
% str.  The function assumes S is a cell array of strings.
%

% Initialize output.
n_cell = numel(S);                              % number of strings in S
i      = zeros(1,n_cell);                       % maximum size of i
n_find = 0;                                     % number of matches

% Loop through S.
for j=1:n_cell
  % Check for match of jth cell with str
  if strcmpi(S{j},str) 
    % Increase number of finds.
    n_find    = n_find + 1;
    % Save index.
    i(n_find) = j;
  end
end

% Delete extra entries of i.
i = i(1:n_find);