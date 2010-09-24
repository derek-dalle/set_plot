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
%                         [ double | {input figure aspect ratio} ]
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
h_f = fig_handle;
figure(h_f);
h_a = gca;

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
	'AspectRatioMode', 'Auto', ...
	'AspectRatio', 4/3, ...
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

set(h_f, 'Units', 'centimeters', 'PaperUnits', 'centimeters');
set(h_a, 'Units', 'centimeters');

% The 'Format' field specifies the basic look and size of the figure.
if ischar(options.Format)
	switch deblank(lower(options.Format))
		case 'journal'
			LineWidth = 1;
			Color = 'black';	% I think that a colormap should be specified at some point
			Width = 8.2;		% [cm]
			FontSize = 9;		% [pt] this is mandated by AIAA
			Title = false;
		case 'presentation'
			LineWidth = 1;
			Color = 'color';	% I think that a colormap should be specified at some point
			Width = 8.2;		% [cm]
			FontSize = 16;		% [pt] should make things a little clearer in presentation
			Title = false;
		otherwise
			error('pretty_plot:UnkFormat', ...
				['Format ' options.Format ' not recognized.']);
	end
else
	error('pretty_plot:BadFormat', ...
		'Format should be text string.')
end
		
% The aspect ratio is the key parameter to set the height, since in most
% circumstances the width is limited by some external constraint.

% If a number is given for aspect ratio, use it.
if any(strcmpi(user_names, 'AspectRatio'))
	options.AspectRatioMode = 'auto';
end

if ischar(options.AspectRatioMode)
	switch deblank(lower(options.AspectRatioMode))
		case 'user'
			% Don't change the aspect ratio of the image the user has given,
			% but change the other properties.
			lbwh = get(h_f, 'Position');
			w = lbwh(3);
			h = lbwh(4);
			AR = w/h;
			
			Height = Width/AR;
			
		case 'auto'
			% Place the plot nicely using the aspect ratio provided.
			AR = options.AspectRatio;
			Height = Width/AR;
			
		otherwise
			error('pretty_plot:BadAspectRatio', ...
				['AspectRatio ' options.AspectRatio ' not recognized']);
	end
else
	error('pretty_plot:BadARMode', ...
		'Aspect Ratio Mode should be text string.')
end

%% First round of plotting.
% Make the figure the right size.
fig_pos = get(h_f, 'Position');

set(h_f, 'Position', [fig_pos(1), fig_pos(2), Width Height])

% Create all the labels
% No title for AIAA papers, this is taken care of in LaTex

haxes = get(h_a);
hxlabel = haxes.XLabel;
hylabel = haxes.YLabel;
hlegend = legend(h_a);

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

% Now test to see if the bounds are right
axes_pos = get(h_a, 'Position');
tight_inset = get(h_a, 'TightInset');

l_shift = tight_inset(1);
b_shift = tight_inset(2);
r_shift = tight_inset(3);
t_shift = tight_inset(4);

set(h_a, 'Position', ...
	[l_shift, b_shift, Width-l_shift-r_shift, Height-b_shift-t_shift])

tight_inset = get(h_a, 'TightInset');
w_shift = tight_inset(3);
h_shift = tight_inset(4);

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

set(h_f, 'PaperPosition', [0 0 width height]);

end
