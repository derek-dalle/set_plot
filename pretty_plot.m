function pretty_plot(fig_handle, varargin)
%
% pretty_plot(x, y)
%
% INPUTS:
%       fig_handle  : the figure whose properties we wish to change
%
% OUTPUTS:
%       NULL
%
% This function is similar in usage to the original plot function in
% MATLAB, but it creates journal-quality stuff
%
% Versions:
%  02/15/10 @Sean Torrez    : First version
%  03/9/10  @Sean Torrez    : Modified to use fig handles only
%
% University of Michigan/MACCCS
%

f = fig_handle;
figure(f);
h = gca;

% assume that the plots already contain all the information necessary and
% that we must only update the style of the plots

%% Create all the labels
% No title for AIAA papers, this is taken care of in LaTex

axes = get(h);
hxlabel = axes.XLabel;
hylabel = axes.YLabel;
hlegend = legend(h);

set([hxlabel, hylabel]          , ...
    'FontName'  , 'Times New Roman'       , ...
    'FontSize'   , 9           , ...
    'Interpreter', 'latex'      );
set( hlegend                    , ...
    'FontName'  , 'Times New Roman'       , ...
    'FontSize'   , 9           , ...
    'Interpreter', 'latex'      , ...
    'Box'       , 'off'         , ...
    'Location'  , 'Best'        );

set(h, ...
  'FontName'    , 'Times New Roman'   , ...
  'FontUnits'   , 'points'  , ...
  'FontSize'    , 9         , ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'XColor'      , [.1 .1 .1], ...
  'YColor'      , [.1 .1 .1], ...
  'YTickLabelMode', 'auto'  , ...
  'LineWidth'   , 1         );

% set the sizes of everything

end
