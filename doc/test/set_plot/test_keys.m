function test_keys
%
% test_keys
%
% This function creates a fancy contour plot in two formats to test the
% input processing.
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
%  2013-10-11 @dalle   : First version


% Catcher.
try
	% Plot.
	h_f = figure();
	
	% Make a contour plot.
    contourf(peaks(50))
	
	% Do the basic set_plot on it to get the margins fixed up.
	set_plot('FigureStyle', 'journal', 'ContourStyle', 'fancy')
	
	% Save it as a PDF again.
	saveas(h_f, './peaks-fancy.pdf')
	system('convert -density 300 peaks-fancy.pdf peaks-fancy.png');
	
	% Make a keyValue struct.
    keys = struct( ...
        'FigureStyle',  'journal', ...
        'FontStyle',    'presentation', ...
        'ContourStyle', 'fancy', ...
        'ColorMap',     'reverse-jet');
    
    % Apply it.
    set_plot(h_f, keys);
    % Save it.
    saveas(h_f, './peaks-keys.pdf')
	system('convert -density 300 peaks-keys.pdf peaks-keys.png');
	
	% Close the figure.
	close(h_f)
	
	% Success message.
	fprintf('PASSED\n');
	
catch msg
	% Failure.
	disp(msg.message);
	
end
