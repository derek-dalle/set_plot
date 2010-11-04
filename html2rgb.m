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
	erro('html2rgb:NotString', 'Input must be a string.');
end

% Begin searching
if strcmpi(s_html, 'AliceBlue')
	
end