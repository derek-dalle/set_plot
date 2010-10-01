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
% figure(h_f);
set(h_f, 'visible', 'on');
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
	for i = 1:n_arg/2
		if ~ischar(varargin{2*i-1})
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

% The 'Width' field specifies the Width, which was previously specified by
% Format. Therefore, specifying a Width in addition to a Format means it
% can be superseded.
if ischar(options.Width)
	switch deblank(lower(options.Width))
		case 'column'
			Width = 8.2;		% [cm]
		case 'doublecolumn'
			Width = 15.2;		% [cm]
		otherwise
			error('pretty_plot:UnkWidth', ...
				['Width ' options.Width ' not recognized.']);
	end
else
	Width = options.Width;
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

% The 'Color' option sets the overall color look of the plot. It's
% basically like setting a color map. This is optimized for printing in
% black, because the printer has essentially a different range of blacks
% from what the screen does.
if ischar(options.Color)
	switch deblank(lower(options.Color))
		case 'black'
			% Change the color information of the image to be black only
			TextColor = [0.1 0.1 0.1];
			map = repmat(linspace(0.75, 1, 64)', [1 3]);
			colormap(map);
		case 'color'
			% Do nothing for now
			
		otherwise
			error('pretty_plot:BadColorValue', ...
				['Color ' options.Color ' not recognized']);
	end
else
	error('pretty_plot:BadColor', ...
		'Color should be text string.')
end

%% Internal options

% Set the tick length. This is always constant, which MATLAB doesn't really
% want to do, but you can force it.
TickLength = 0.2;	% [cm]
% Find the longest dimension
Longest = max(Height, Width);
TickLength = TickLength/Longest;

%% First round of plotting.
% Make the figure the right size.
fig_pos = get(h_f, 'Position');

set(h_f, 'Position', [fig_pos(1), fig_pos(2), Width Height])

% Create all the labels
% No title for AIAA papers, this is taken care of in LaTex

haxes = get(h_a);
hlabels = [haxes.XLabel; haxes.YLabel; haxes.ZLabel];
hlegend = legend(h_a);

% Get the text and position from each label.
labels  = get(hlabels);
strings = {labels.String};
pos     = reshape([labels.Position],3,3)';
set(hlabels, 'Units', 'centimeters');

% Determine the system in order to display the fonts properly
if ispc
	font_interpreter = 'latex';
else
	% Don't use latex because it will mess everything up.
	font_interpreter = 'latex';
% 	latexlabels = {};
	
	for i = 1:3
		[unitstr mathstr unittoken] = regexp(strings{1,i}, '([\({\[].*?[\)}\]])', 'match', 'split');
		if ~isempty(unitstr)
			texunits{i} = unitstr(1,:);
		end
		if ~isempty(mathstr)
			latexmath{i} = mathstr(1,:);
		end
		if ~isempty(unittoken)
			textokens{i} = unittoken(1,:);
		end
		set(hlabels(i), 'String', latexmath{i}{1}, 'Position', pos(i,:));
		extents(i,:) = get(hlabels, 'Extent');
		
		for j = 1:length(latexmath{i})
			new_pos = [extents{i}(1)+extents{i}(3), extents{i}(1)+extents{i}(2), pos(i,3)];
			if j > 1
				% First do the math string.
				text(new_pos(1), new_pos(2), new_pos(3), latexmath{i,j}, ...
					'interpreter', 'latex');
			end
			% Then do the units string; use tex interpreter.
			text(new_pos(1), new_pos(2), new_pos(3), texunits{i,j}, ...
				'interpreter', 'tex');
		end
		
	end
	
	for i = 1:3
		[mathstr nonmath mathtoken] = regexp(strings{1,i}, '(\$.*?\$)', 'match', 'split');
		if ~isempty(mathstr)
			latexlabels{i} = mathstr(1,:);
		end
		if ~isempty(nonmath)
			texunits{i} = nonmath(1,:);
		end
		if ~isempty(mathtoken)
			textokens{i} = mathtoken(1,:);
		end
		set(hlabels(i), 'String', latexlabels{i}{:}, 'Units', 'centimeters');
	end
	
	set(hlabels, 'String', latexlabels, 'Units', 'centimeters');
	extents = get(hlabels, 'Extent');
	
	[mathstr nonmath mathtoken] = regexp(xstring, '(\[.*\])', 'match', 'split');
	
end

set([hxlabel, hylabel, hzlabel]             , ...
	'FontName'   , 'times new roman', ...
	'FontSize'   , 9                , ...
	'Interpreter', font_interpreter , ...
   'Color'      , TextColor       );
set( hlegend                       , ...
	'FontName'   , 'times new roman', ...
	'FontSize'   , 9                , ...
	'Interpreter', font_interpreter , ...
	'Box'        , 'off'            , ...
	'Location'   , 'Best'           , ...
   'Color'      , TextColor       );

set(h_a, ...
	'FontName'      , 'times new roman', ...
	'FontUnits'     , 'points'         , ...
	'FontSize'      , 9                , ...
	'Box'           , 'off'            , ...
	'TickDir'       , 'out'            , ...
	'XMinorTick'    , 'on'             , ...
	'YMinorTick'    , 'on'             , ...
	'TickLength'    , [TickLength TickLength], ...
	'XColor'        , TextColor        , ...
	'YColor'        , TextColor        , ...
	'YTickLabelMode', 'auto'           , ...
	'LineWidth'     , 1                );

% Now test to see if the bounds are right
axes_pos = get(h_a, 'Position');
tight_inset = get(h_a, 'TightInset');

l_shift = tight_inset(1);
b_shift = tight_inset(2);
r_shift = tight_inset(3);
t_shift = tight_inset(4);

set(h_a, 'Position', ...
	[l_shift, b_shift, Width-l_shift-r_shift, Height-b_shift-t_shift])

set(h_f, 'PaperPosition', [0 0 Width Height], ...
	'PaperSize', [Width Height]);

print(['-f' num2str(fig_handle)], '-dpdf', 'test.pdf');

end
