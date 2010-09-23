function fh = pretty_plot(fig_handle, varargin)
%
% fh = pretty_plot(fig_handle, varargin)
%
% INPUTS:
%       fig_handle  : the figure whose properties we wish to change
%       varargin    : optional arguments, in option/value pairs
%
% OUTPUTS:
%       fh          : returned figure handle
%
% OPTIONS:
%       'Format'      : Format for the image
%                         [ {Journal} | Presentation ]
%       'Width'       : Width of the image
%                         [ {Column} | DoubleColumn | double ]
%       'AspectRatio' : Desired aspect ratio of the image
%                         [ {Auto} | double ]
%       'Color'       : Color scheme to use
%                         [ {black} | blue | color ]
%
% This function operates on a previously created plot, but prettifies it
% according to a number of standards for either journal or other purposes.
%
% Versions:
%  2010/02/15 @Sean Torrez    : First version
%  2010/03/09 @Sean Torrez    : Modified to use fig handles only
%  2010/09/23 @Sean Torrez    : Made more general/given greater scaling
%  options and capabilities
%

%% Process the inputs
f = fig_handle;
figure(f);
h = gca;

% Make an options structure.
if numel(varargin) > 1 && isstruct(varargin{1})
	user_options = varargin{1};
else
	user_options = struct(varargin{:});
end
user_names = fieldnames(user_options);

% Set the defaults.
options = struct('Format', 'Journal', ...
	'Width', 'Column', ...
	'AspectRatio', 'Auto', ...
	'Color', 'black');
opt_names = fieldnames(options);

% Process the inputs
n_arg = length(varargin);
if ~mod(n_arg, 2)
	% Arguments come in pairs, which is what we want.
	for i = 1:2:n_arg
		if ~ischar(varargin{i})
			error('pretty_plot:ArgNotText', ['The first argument of each ' ...
				'pair should be a property name']);
		else
			
			same = strcmpi(opt_names, user_names{i});
			if any(same)
				options.(opt_names{same}) = user_options.(opt_names{same});
			else
				error('pretty_plot:UnknownOpt', ...
				['Option ''' user_names{i} ''' not recognized']);
			end
			
		end
	end
else
	error('pretty_plot:NArguments', ['Property names and values ' ...
		'should come in pairs']);
end

%% Set all the parameters
% assume that the plots already contain all the information necessary and
% that we must only update the style of the plots



%% Create all the labels
% No title for AIAA papers, this is taken care of in LaTex

haxes = get(h);
hxlabel = haxes.XLabel;
hylabel = haxes.YLabel;
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
l_shift = 1.4;
b_shift = 1.2;
width = 8.2;
height = 6.0;
border = 0.7;
set(f, 'Units', 'centimeters', 'PaperUnits', 'centimeters', ...
   'PaperPosition', [0, 0, width+l_shift+border, height+b_shift+border], ...
   'PaperSize', [width+l_shift+border, height+b_shift+border], ...
   'Position', [5, 5, width+l_shift+border, height+b_shift+border], ...
   'ActivePositionProperty', 'outerposition');
set(h, 'Units', 'centimeters', 'Position', [l_shift b_shift width height]);

end
