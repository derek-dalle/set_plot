function test_peaks
%
% test_peaks
%
% This function creates a basic contour plot, saves it, and then modifies
% it and saves it again.
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


% Catcher.
try
	% Plot.
	h_f = figure();
	
	% Simple contour plot.
	contour(peaks(50));
	
	% Save the figure (in this folder).
	saveas(h_f, './peaks-plain.png')
	
	% Now save it as a PDF (that will be a full sheet of paper).
	saveas(h_f, './peaks-page.pdf')
	% Convert that to a PNG for documentation.
	system('convert -density 300 peaks-page.pdf peaks-page.png');
	
	% Do the basic set_plot on it.
	set_plot(h_f)
	
	% Save it as a PDF again.
	saveas(h_f, './peaks-simple.pdf')
	system('convert -density 300 peaks-simple.pdf peaks-simple.png');
	
	% Now give it some style.
	set_plot(h_f, 'FigureStyle', 'journal')
	% Save it as a PDF again.
	saveas(h_f, './peaks-journal.pdf')
	system('convert -density 300 peaks-journal.pdf peaks-journal.png');
	
	% Close the figure.
	close(h_f)
	
	% Success message.
	fprintf('PASSED\n');
	
catch msg
	% Failure.
	disp(msg.message);
	
end
