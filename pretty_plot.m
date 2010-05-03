function pretty_plot(fig_handle, varargin)
%% pretty_plot(fig_handle)
%
% INPUTS:
%       fig_handle  : the figure whose properties we wish to change
%
% OUTPUTS:
%       NULL
%
% This function takes a figure that has already been created and changes a
% bunch of parameters on it so that it is acceptable for journal usage. The
% defaults used here are for AIAA journals.
%
% To use pretty_plot, simply plot the data series, assign x- and y-labels,
% assign legend entries and axis limits and then call pretty_plot.
% Everything will be prettified.
%
% Versions:
%  02/15/10 @Sean Torrez   : First version
%  03/9/10  @Sean Torrez   : Modified to use fig handles only
%  04/30/10 @Sean Torrez   : Updated to have full AIAA functionality
%
% University of Michigan/MACCCS
%

%% Assign figure
% Assume that the plots already contain all the information necessary and
% that we must only update the style of the plots
f = fig_handle;
figure(f);
h = gca;

%% Parse the inputs
for i = 1:2:length(varargin)
   name = varargin{i};
   value = varargin{i+1};
   switch name
      case 'format'
         % check if the format is AIAA. This is the only style allowed at
         % present
         if ~(strcmpi(value, 'AIAA') || strcmpi(value, 'aiaa'))
            error('In pretty_plot.m: this function does not current support formats other than AIAA.');
         end
      case 'size'
         switch value
            case 'singlecolumn'
               width = 8.2;   % [cm]
               ticklength = [0.02 0.02];
            case 'doublecolumn'
               width = 15.5;  % [cm]
               ticklength = [0.012 0.012];
            otherwise
               error(['In pretty_plot.m: size ' value ' is not allowed']);
         end
      otherwise
         error(['In pretty_plot.m: ' name ' is not a valid parameter']);
   end
end

%% Create all the labels
% No title for AIAA papers, this is taken care of in LaTex

axes = get(h);
hxlabel = axes.XLabel;
hylabel = axes.YLabel;
hlegend = legend(h);

set([hxlabel, hylabel]          , ...
   'FontName'  , 'Times'       , ...
   'FontSize'   , 9           , ...
   'Interpreter', 'latex'      );
set( hlegend                    , ...
   'FontName'  , 'Times'       , ...
   'FontSize'   , 9           , ...
   'Interpreter', 'latex'      , ...
   'Box'       , 'off'         , ...
   'Location'  , 'Best'        );

set(h, ...
   'FontName'    , 'Times'   , ...
   'FontUnits'   , 'points'  , ...
   'FontSize'    , 9         , ...
   'Box'         , 'off'     , ...
   'TickDir'     , 'out'     , ...
   'TickLength'  , ticklength , ...
   'XMinorTick'  , 'on'      , ...
   'YMinorTick'  , 'on'      , ...
   'XColor'      , [.1 .1 .1], ...
   'YColor'      , [.1 .1 .1], ...
   'YTickLabelMode', 'auto'  , ...
   'LineWidth'   , 1         );

%% Size the figure properly
% this gives the figure a minimum of white space. You could add something
% that tries to determine if anything has been cut off, but this might be
% pretty hard.
l_shift = 1.5;
b_shift = 1.5;
height = 3.8; % this should be calculated from the figure aspect ratio as it is sent to pretty_plot
border = 0.2;
set(gcf, 'Units', 'centimeters', 'PaperUnits', 'centimeters', ...
   'PaperPosition', [0, 0, width+l_shift+border, height+b_shift+border], ...
   'PaperSize', [width+l_shift+border, height+b_shift+border], ...
   'Position', [5, 5, width+l_shift+border, height+b_shift+border], ...
   'ActivePositionProperty', 'outerposition');
set(gca, 'Units', 'centimeters', 'Position', [l_shift b_shift width height]);

end
