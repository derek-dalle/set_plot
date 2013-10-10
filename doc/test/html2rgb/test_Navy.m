function test_Navy
%
% test_Navy
%
% This function tests the `html2rgb` function by printing the blue
% component of the color 'Navy'.
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
%  2013-10-09 @dalle   : First version

% Get the rgb color spec.
col = html2rgb('Navy');

% Print the color.
fprintf('%06.4f', col(3));
