function cmap = set_colormap(varargin)
%SET_COLORMAP Customize color mapping
%
% CALL:
%    set_colormap(cmapName)
%    set_colormap(cmapCell)
%    set_colormap(cmapMat)
%    set_colormap({colName1, colName2, ...})
%    set_colormap({colVal1, colName1, ...})
%    set_colormap(h_f, ...)
%    cmap = set_colormap(...)
%
% INPUTS:
%    h_f      : figure handle (default is gcf)
%    cmapName : name of custom or built-in colormap (notes 1-3)
%    cmapCell : cell array of colors or colors and values (note 7)
%    cmapMat  : Nx3 or Nx4 matrix (note 4)
%    colName1 : RGB color or HTML color (note 5)
%    colVal1  : scalar for interpolation (note 6)
%    colVals  : list of scalars for interpolation (note 6)
%
% OUTPUTS:
%    cmap : the Nx3 colormap used
%
% This function edits a colormap with dramatically more options than the
% built-in colormap function.  In addition to the built-in colormaps, this
% function recognizes eight monochromatic that are based on the primary and
% secondary colors and black and white.  Thus the following example will
% produce a colormap going from White to Blue to DarkBlue.
%
%     >> set_colormap blue
%
% There is also the option to reverse any colormap by using a prefix.
%
%     >> set_colormap reverse-blue
%     >> set_colormap reverse-jet
%
% The user can also use a pre-defined colormap using the following command.
%
%     >> set_colormap(cmap)
%
% Here cmap is an Nx3 or Nx4 matrix of RGB colors.  Finally, this function
% provides several ways to construct a colormap manually.  The following
% example shows how to construct a map that goes through a certain range of
% colors based on common names.
%
%     >> set_colormap('Navy', 'Blue', 'White')
%
% The user may also change the values to which each color corresponds.
%
%     >> set_colormap({0, 'Navy', 0.2, 'Blue', 1, 'White'})
%
% The function will recognize any of the typical web browser color names.
%
% NOTES:
%    (1) The built-in color maps can are described by <a href="matlab: doc colormap">colormap</a>
%        in the Matlab help browser.  They are 'autumn', 'bone', 'colorcube',
%        'cool', 'copper', 'flag', 'gray', 'hot', 'hsv', 'jet', 'lines',
%        'pink', 'prism', 'spring', 'summer', 'white', and 'winter'.
%
%    (2) The custom colormaps defined here are black, blue, cyan, green,
%        magenta, red, white, and yellow.  They can also be aliased
%        using the single-character abbreviations 'k', 'b', 'c', 'g', 'm',
%        'r', 'w', and 'y', respectively.
%
%    (3) Any of the string colormaps can be reversed by prepending the
%        string with 'reverse-', for example, 'reverse-jet' and 'reverse-b'.
%
%    (4) The colormap can also be described using a matrix.  This matrix
%        can be an Nx3 matrix, which is the typical format for Matlab
%        colormaps.  In this case each row refers to a red,green,blue
%        color.  The matrix can also be an Nx4 matrix, in which case the
%        first column gives a value to associate with each color.
%
%    (5) Colors listed individually can be either an RGB color, which is
%        a 1x3 double, or an HTML color, which is a string containing
%        the name of a common color.  A full list can be found at
%        http://www.w3schools.com/html/html_colornames.asp. See
%        <a href="matlab: help html2rgb">html2rgb</a> for more information.
%
%    (6) The colormap associates a color for each number in the range of
%        0 to 1.  By default, the colors are spaced out equally, but
%        this may not always be what the user wants.  The values can be
%        given alternating with the colors or a list of interpolation
%        values followed by a list of colors.
%
%    (7) A cell array can also be used.  The cell array consists of
%        either a list of colors or a column of values and a column of
%        colors or a row of values and a row of colors.
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
%  2010-11-04 @dalle   : Branched from set_plot
%  2010-11-05 @dalle   : First version

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

% List of built-in colormaps.
cmap_builtin = {
    'autumn', 'bone', 'colorcube', 'cool', ...
    'copper', 'flag', 'gray',      'hot', ...
    'hsv',    'jet',  'lines'};


% Check for a simple string input.
if ischar(s_cmap)
    % Check if string begins with 'reverse-'.
    if strncmpi(s_cmap, 'reverse-', 8)
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
    elseif any(strcmpi(s_cmap, cmap_builtin))
        % No custom map found.
        q_cmap_custom = false;
        % Find the current axes
        h_a = get(h_f, 'CurrentAxes');
        % Try to apply the built-in colormap.
        colormap(h_a, s_cmap);
    else
        % Make a simple map based on the available.
        s_cmap = {'White', s_cmap};
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
            % Store the color.
            v_cmap(i,:) = v_cur;
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

% Check for outputs.
if nargout > 0
    cmap = v_cmap;
end
