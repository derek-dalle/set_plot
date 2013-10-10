function test_plot
%
% test_plot
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
%  2013-10-10 @dalle   : First version


% Catcher.
try
	% Plot.
	h_f = figure();
	
	% Make a simple plot.
    x = linspace(0, 6, 121);
    plot(x, sin(x), x, cos(x+sin(4*x))/2)
    xlabel('Time [s]')
    ylabel('Amplitude')
	
	% Do the basic set_plot on it to get the margins fixed up.
	set_plot(h_f)
	
	% Save it as a PDF again.
	saveas(h_f, './sine-plain.pdf')
	system('convert -density 300 sine-plain.pdf sine-plain.png');
	
	% Now give it some style.
	set_plot(h_f, 'FigureStyle', 'fancy')
	% Save it as a PDF again.
	saveas(h_f, './sine-fancy.pdf')
	system('convert -density 300 sine-fancy.pdf sine-fancy.png');
	
	% Close the figure.
	close(h_f)
	
	% Success message.
	fprintf('PASSED\n');
	
catch msg
	% Failure.
	disp(msg.message);
	
end
