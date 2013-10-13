function ierr = test_cmap
%TEST_CMAP Test basic set_colormap usage
%
% CALL:
%    ierr = test_cmap
%
% INPUTS:
%    (None)
%
% OUTPUTS:
%    ierr : error code
%
% This function creates a contour plot and proceeds to play with its
% colormap.
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
%  2013-10-13 @dalle   : First version


% Catcher.
try
	% Plot.
	h_f = figure();
	
	% Make a contour plot.
    contourf(peaks(51))
    % Turn the colorbar on.
    colorbar
    % Fix the margins.
    set_plot(h_f);
	
	% Save it as a PDF again.
	saveas(h_f, './peaks-jet.pdf')
	system('convert -density 300 peaks-jet.pdf peaks-jet.png');
    
    % Reverse the colormap.
    set_colormap reverse-jet
    saveas(h_f, './peaks-reverse.pdf')
    system('convert -density 300 peaks-reverse.pdf peaks-reverse.png');
    
    % Monochrome
    set_colormap('Blue')
    saveas(h_f, './peaks-blue.pdf')
    system('convert -density 300 peaks-blue.pdf peaks-blue.png');
    
    % Bichromic
    set_colormap('DarkSalmon')
    saveas(h_f, './peaks-mono.pdf')
    system('convert -density 300 peaks-mono.pdf peaks-mono.png');
    
    % Bichromic
    set_colormap({[0.7,0.2,0.1], 'w', 'DarkTurquoise'})
    saveas(h_f, './peaks-bi.pdf')
    system('convert -density 300 peaks-bi.pdf peaks-bi.png');
    
    % Get the caxis values.
    v = caxis;
    % Figure out where zero is.
    t = -v(1) / (v(2) - v(1));
    % Set the new colormap.
    set_colormap({0, 'DarkOrange'; t, 'w'; 1, 'Indigo'})
    saveas(h_f, './peaks-fix.pdf')
    system('convert -density 300 peaks-fix.pdf peaks-fix.png');
    
    % Dead zpme
    set_colormap({0, 'w'; t, 'w'; 1, 'Teal'})
    saveas(h_f, './peaks-dead.pdf')
    system('convert -density 300 peaks-dead.pdf peaks-dead.png');
    
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
