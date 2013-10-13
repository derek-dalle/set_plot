function ierr = test_outputs
%TEST_OUTPUTS Test usage of set_plot outputs
%
% CALL:
%    ierr = test_outputs
%
% INPUTS:
%    (None)
%
% OUTPUTS:
%    ierr : error code
%
% This function creates a complicated plot and formats it.
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
	
	% Make a space.
    x = linspace(0, 1, 51);
    % Contour plot
    contour(x, x, peaks(51));
    % Line
    hold('on')
    plot(x, 0.1 + x.*(2-x)/2)
    % Turn the colorbar on.
    colorbar
	
    % Use a struct.
    keys.FigureStyle  = 'journal';
    keys.ContourStyle = 'smooth';
    keys.LineWidth    = 2;
    keys.ColorStyle   = 'current';
    keys.ColorMap     = 'g';
    
	% Do the basic set_plot on it to get the margins fixed up.
	h = set_plot(h_f, keys);
	
	% Save it as a PDF again.
	saveas(h_f, './output-contour.pdf')
	system('convert -density 300 output-contour.pdf output-contour.png');
    
    % Test the output a little bit.
    assert(isstruct(h))
    assert(isfield(h, 'colorbar'))
    assert(isfield(h, 'contour'))
    assert(isfield(h.contour, 'line'))
    assert(isempty(h.contour.line))
    assert(isfield(h, 'label'))
    assert(isfield(h.label, 'x'))
    assert(isnumeric(h.label.x))
    
    % Change one of the data sets.
    set(h.line, 'YData', x.^2);
    % Save it again.
    saveas(h_f, './output-altered.pdf')
    system('convert -density 300 output-altered.pdf output-altered.png');
	
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
