function ierr = test_colorbar
%
% test_keys
%
% This function tests the formatting of a colorbar.
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
    [x, y] = meshgrid(linspace(-1,1,101));
    contourf(x, y, sin(2*pi*x) + sin(2*pi*y));
    % Turn the colorbar on.
    colorbar;
	
	% Do the basic set_plot on it to get the margins fixed up.
	set_plot(h_f, 'FigureStyle','journal', 'ContourStyle','fill');
	
	% Save it as a PDF again.
	saveas(h_f, './cbar-journal.pdf')
	system('convert -density 300 cbar-journal.pdf cbar-journal.png');
	
	% Try a fancy colorbar.
    set_plot(h_f, 'FigureStyle', 'fancy', 'ContourStyle', 'fill');
    % Save it.
    saveas(h_f, './cbar-fancy.pdf')
	system('convert -density 300 cbar-fancy.pdf cbar-fancy.png');
	
	% Close the figure.
	close(h_f)
	
	% Success message.
	fprintf('PASSED\n');
	
    ierr = 0;
    
catch msg
	% Failure.
	disp(msg.message);
	ierr = 1;
end
