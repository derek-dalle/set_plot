function ierr = test_lines
%TEST_LINES Test advanced line formatting with set_plot
%
% CALL:
%    ierr = test_plot
%
% INPUTS:
%    (None)
%
% OUTPUTS:
%    ierr : error code
%
% This function creates a basic plot and saves it.  It creates a basic
% (unformatted) image and a configured one.
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
	
	% Make fine and course linspaces.
    x1 = linspace(0, 1, 101);
    x2 = linspace(0, 1, 7);
    % Three plots
    hold('on')
    plot(x1, sinc(x1))
    plot(x1, 5*x1.*(0.75-x1));
    plot(x2, sinc(x2) - (x2-0.5).^2, '^');
	
	% Do the basic set_plot on it to get the margins fixed up.
	set_plot(h_f)
	
	% Save it and convert it.
	saveas(h_f, './lines-plain.pdf')
	system('convert -density 300 lines-plain.pdf lines-plain.png');
	
	% Now give it some style.
	set_plot(h_f, 'FigureStyle', 'fancy', 'Width', 3.1);
	% Save it as a PDF again.
	saveas(h_f, './lines-fancy.pdf')
	system('convert -density 300 lines-fancy.pdf lines-fancy.png');
    
    % Now run set-plot again.
    set_plot(h_f, 'LineWidth', 2)
    
    % Save it.
    saveas(h_f, './lines-clean.pdf')
    system('convert -density 300 lines-clean.pdf lines-clean.png');
	
	% Close the figure.
	close(h_f)
    
    % New figure.
    h_f = figure();
    
    % Make two plots.
    hold('on')
    plot(x1, x1, 'Color', [0.4,0,0.8], 'LineWidth', 2)
    plot(x1, 4*x1.*(1-x1), 'Color', [0.8,0.6,0.1], 'LineWidth', 2)
    
    % Format it.
    set_plot(h_f, 'FigureStyle','journal', 'PlotStyle','current', ...
        'ColorStyle','current')
    
    % Save it.
    saveas(h_f, './polys-clean.pdf')
    system('convert -density 300 polys-clean.pdf polys-clean.png')
    
    % Close it.
    close(h_f)
	
	% Success message.
	fprintf('PASSED\n');
    ierr = 0;
	
catch msg
	% Failure.
	disp(msg.message);
	ierr = 1;
    
end
