function test_Navy
%
% test_Navy
%
% This function tests the `html2rgb`
%

% Versions:
%  2013-10-09 @dalle   : First version

% Get the rgb color spec.
col = html2rgb('Navy');

% Print the color.
fprintf('%06.4f', col(3));
