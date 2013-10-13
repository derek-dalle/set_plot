function ierr = test_text
%TEST_TEXT Test formatting for text and legends
%
% CALL:
%    ierr = test_text
%
% INPUTS:
%    (None)
%
% OUTPUTS:
%    ierr : error code
%
% This function creates a basic plot and adds some text to it.
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
    % Put some labels
    xlabel('Length, $x$')
    ylabel('Amplitude, $\hat{A}_i$')
    % Legend
    legend('Theory', 'Lower bound, $A_L$', 'Experiment')
	
	% Do the basic set_plot on it to get the margins fixed up.
	set_plot(h_f)
	
	% Now give it some style.
	h = set_plot(h_f, 'FigureStyle','journal', 'PlotStyle','fancy');
	% Save it as a PDF again.
	saveas(h_f, './legend-bad.pdf')
	system('convert -density 300 legend-bad.pdf legend-bad.png');
    
    % Move the legend over.
    p = get(h.legend, 'Position');
    p(1) = 0.7;
    p(2) = 0.6;
    set(h.legend, 'Position', p);
    
    % Save it.
    saveas(h_f, './legend-fixed.pdf')
    system('convert -density 300 legend-fixed.pdf legend-fixed.png');
    
    % Change the font styles.
    set_plot(h_f, 'FontStyle','sans-serif', 'Interpreter','auto')
    % Save it.
    saveas(h_f, './legend-sans.pdf')
    system('convert -density 300 legend-sans.pdf legend-sans.png');
	
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
