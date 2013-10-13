function v_rgb = html2rgb(s_html)
%HTML2RGB Convert color specification to RGB values
%
% CALL:
%    rgb = html2rgb(cName)
%    rgb = html2rgb(fRGB)
%    rgb = html2rgb(iRGB)
%    rgb = html2rgb(fGray)
%    rgb = html2rgb(iGray)
%
% INPUTS:
%    cName : name of an HTML color                         [char]
%    fRGB  : red, green, blue components between 0 and 1   [1x3 double]
%    iRGB  : red, green, blue components between 0 and 255 [1x3 double]
%    fGray : grayscale component between 0 and 1           [1x1 double]
%    iGray : grayscale component between 0 and 255         [1x1 double]
%
% OUTPUTS:
%    rgb   : red, green, blue components between 0 and 1   [1x3 double]
%
% This function converts an HTML color name to a RGB color.  If the input
% an error is produced.
%
% EXAMPLES:
% The usage is usually straightforward.
%
%     >> html2rgb('Navy')
%     ans =
%              0         0    0.5020
%
% The few built-in MATLAB colors are appended to the list of standard HTML
% colors.  For example, this gives a cyan color.
%
%     >> html2rgb('c')
%     ans =
%          0     1     1
%
% If a 1x3 color is given as input to `html2rgb`, it simply returns the
% color.  This prevents inconvenient errors from trying to convert a color
% that has already been converted.
%
%     >> html2rgb([0,0,1])
%     ans =
%          0     0     1
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
%  2010-11-04 @dalle    : First version
%  2013-10-09 @dalle    : Cleaned up and expanded help

% Check for sufficient inputs.
if nargin < 1
    error('set_plot:NotEnoughInputs', 'Not enough inputs');
end

% Check for an input color.
if isnumeric(s_html)
    % Check the size.
    if numel(s_html) == 3
        % Use the color.
        v_rgb = s_html(:).';
    elseif isscalar(s_html)
        % Make a grayscale color.
        v_rgb = s_html * [1,1,1];
    end
    % Normalize if 255-based.
    if max(v_rgb)>1, v_rgb = v_rgb/255; end
    % Check for validity.
    if min(v_rgb) < 0 || max(v_rgb) > 1
        error('set_plot:InvalidRGB', ...
            'RGB color components must be between 0 and 1.');
    end
    return
end

% Check that the input is a string.
if ~ischar(s_html)
    error('set_plot:NonChar', 'Input must be a char.');
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
    'DarkOrange',            [248, 128,  23];
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
i_html = find(strcmpi(s_colors(:,1), s_html));

% Check if a match was found.
if numel(i_html) == 1
    % Normalize colors into [0,1] range.
    v_rgb = s_colors{i_html,2} / 255;
else
    % No color was found.
    error('set_plot:ColorName', ...
        'Color named ''%s'' was not found.', s_html);
end
