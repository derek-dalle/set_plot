function h = set_plot(varargin)
%
% set_plot
% set_plot(optionName, optionValue, ...)
% set_plot(options)
% set_plot(h_f, ...)
% h = set_plot(...)
%
% INPUTS:
%         h_f         : figure handle
%         optionName  : string, name of option
%         optionValue : value of corresponding option
%         options     : struct containing options
%
% OUTPUTS:
%         h           : struct containing all handles used
%
% This function is used to specify several options simultaneously to a
% figure.  The most basic task performed by this function is to alter the
% paper size so that figures saved using SaveAs have the expected size
% without any cropping.
%
% The simple command
% 
%     set_plot(h_f)
%
% will take a figure (with the handle h_f) and decrease its handles to zero
% if possible.  The function does its other useful work using options.  The
% following command will do nothing to the figure other than change the
% paper size.
%
%     set_plot(h_f, 'MarginStyle', 'loose')
%
% The following command is perhaps the most useful one.  It changes all
% aspects of the figure to make it look fairly good without any extra work.
%
%     set_plot(h_f, 'FigureStyle', 'pretty')
%
% In addition to changing the formatting of the figure, the following
% command also changes the size of the figure so that it will fit in a
% two-column article.
%
%     set_plot(h_f, 'FigureStyle', 'twocol')
%
% The function utilizes a system of cascading options, meaning that the
% values of some of the options affect the default values of some other
% options.  It is possible to use these broad options like 'FigureStyle' or
% much more detailed options like 'FontSize'.
%
%     set_plot(h_f, 'FigureStyle', 'fancy', 'FontSize', 9.5)
%
% Options can also be specified using a struct, which is useful if the same
% options are going to be used for a series of figures.
%
%     opts = struct('FigureStyle', 'fancy', 'FontSize', 9.5);
%     set_plot(h_f, opts)
%
% A fill list of options and their possible values is shown below.  A chart
% of the cascading options and their affects on the detailed options is
% below that.
%
% OPTIONS:
%         AspectRatio
%            [ {auto} | positive scalar ]
%            Aspect ratio to use for figure.  The 'auto' option tells the
%            function to use the aspect ratio of the current figure window.
%         AxesStyle
%            [ {current} | pretty | fancy | simple | smart | plain ]
%            Scheme to use for axes.  This is a cascading style.
%         Box
%            [ {current} | on | off ]
%            Whether or not to draw a box around the plot.
%         ColorBarStyle
%            [ {current} | pretty | fancy | plain ]
%            Style to use for colorbar.  This is a cascading style.
%         ColorBarBox
%            [ {current} | on | off ]
%            Whether or not to draw a box around the colorbar.
%         ColorBarMinorTick
%            [ {current} | on | off ]
%            Whether or not to use minor ticks on the colorbar.
%         ColorBarTickDir
%            [ {current} | in | out ]
%            Direction to draw ticks on the colorbar
%         ColorBarWidth
%            [ {current} | positive scalar ]
%            Width of colorbar, not including labels and ticks.
%         ColorBarGrid
%            [ {current} | on | off ]
%            Whether or not to draw grid lines in the colorbar.
%         ColorBarGridLineStyle
%            [ {current} | : | - | -- | -. ]
%            Style for grid lines in colorbar.
%         ColorBarGap
%            [ {0.1} | positive scalar ]
%            Distance between box containing plot and box containing
%            colorbar.
%         ColorMap
%            [ {current} | string | Nx3 double | Nx4 double | cell array ]
%            The colormap can consist of either a label to a standard
%            Matlab colormap or use a matrix of colors.  An additional
%            option is to use a cell array of colors.  Each color can be
%            either a 1x3 RGB color or an HTML color string such as
%            'OliveGreen'.  An example might be
%                {'Navy', 'RoyalBlue', [0.95, 0.9, 0.85]}.
%         ColorSequence
%            [ {current} | plain | default | gray | black | blue | dark
%               | bright | Nx3 matrix | cell array ]
%            Sequence of colors for plot lines.
%         ColorStyle
%            [ {current} | pretty | plain | gray | grayscale ]
%            Overall color theme.  This is a cascading style.
%            Color to use for labels in contour plots
%         ContourFill
%            [ {current} | on | off ]
%            Whether or not contours plots should be filled in.
%         ContourFontColor
%            [ {current} | auto | string | 1x3 double ]
%            Color to use for contour text labels.  The 'auto' value
%            chooses either black or white for each label in an attempt to
%            pick a color that is readable against the background.
%         ContourFontName
%            [ {current} | auto | string]
%            Font to use for contour text labels.  The 'auto' value
%            inherits the overall font specified using FontName.
%         ContourFontSize
%            [ {current} | auto | positive scalar ]
%            Size of font to use for contour text labels.  The 'auto' value
%            corresponds to a size one point smaller than the overall font
%            size specified using FontSize.
%         ContourLineColor
%            [ {current} | auto | string | 1x3 double ]
%            Color to use for contour lines.  The 'auto' value tells the
%            function to match the contour lines to the colormap values.
%         ContourStyle
%            [ {current} | pretty | fancy | black | fill | smooth
%               | simple | plain ]
%            Style to use for contour plots.  This is a cascading style.
%         ContourText
%            [ {current} | on | off ]
%            Whether or not to use labels in contour plots.
%         FigureStyle
%            [ {current} | pretty | fancy | plain | journal | twocol
%               | onecol | present | presentation ]
%            Overall figure style.  This is a cascading style.
%         FontName
%            [ {current} | font name (string) ]
%            Name of font to use for most text
%         FontSize
%            [ {current} | positive scalar ]
%            Size of fonts to use.
%         FontStyle
%            [ {current} | pretty | present | plain | serif | sans-serif ]
%            Scheme for text fonts and sizes.  This is a cascading style.
%         Grid
%            [ {current} | major | all | on | off | none | smart
%               | x | y | z | X | Y | Z ]
%            Whether or not to draw grid lines.  The strings 'x', 'y', etc.
%            and their combinations can be used to control the grid lines
%            for each axis.  The capital versions turn on both major and
%            minor grid lines.  The 'smart' value turns on all major grid
%            lines and minor grid lines for any axis with linear spacing.
%         InterpreterStyle
%            [ {current} | auto | tex | latex | none ]
%            Rules to use for text interpreters.  The 'auto' option turns
%            most interpreters to 'tex', except those with multiple '$'
%            characters, for which it uses the 'latex' interpreter.
%         Margin
%            [ 0.025 | scalar vector with up to four entries ]
%            Extra margin to add for 'tight' MarginStyle.
%         MarginStyle
%            [ {tight} | loose ]
%            Style for the margins.  The 'tight' option cuts off all
%            margins, and the 'loose' option restores the defaults.  Both
%            options change the paper size so that the figure has the
%            proper dimensions when the 'SaveAs' command is used.
%         MinorTick
%            [ {current} | all | none | on | off | smart 
%               | x | y | z | xy | xz | xy | xyz ]
%            Whether or not to use minor ticks on the axes.  The 'smart'
%            value turns on minor ticks for all non-logarithmic axes.
%         PlotLineStyle
%            [ {current} | pretty | fancy | simple | plain | cell array ]
%            Sequence of plot styles.
%         PlotLineWidth
%            [ {current} | pretty | fancy | simple | plain | cell array
%               | double array ]
%            Sequence of widths for plot lines.
%         PlotStyle
%            [ {current} | pretty | fancy | plain ]
%            Style to use for plot lines.  This is a cascading style.
%         TickDir
%            [ {current} | in | out ]
%            Tick direction for main plot.
%         TickLength
%            [ {current} | short | long | 1x2 double ]
%            Length of ticks for main axes.
%         Width
%            [ {auto} | positive scalar ]
%            Width of figure.
%
%
% CASCADING STYLE CHART:
%    AxesStyle
%       'current'
%           Box        -> 'current'
%           Grid       -> 'current'
%           GridStyle  -> 'current'
%           MinorTick  -> 'current'
%           TickDir    -> 'current'
%           TickLength -> 'current'
%       'fancy'
%           Box        -> 'off'
%           Grid       -> 'major'
%           GridStyle  -> ':'
%           MinorTick  -> 'all'
%           TickDir    -> 'out'
%           TickLength -> [0.0050, 0.0125]
%       'plain'
%           Box        -> 'on'
%           Grid       -> 'none'
%           GridStyle  -> 'current'
%           MinorTick  -> 'none'
%           TickDir    -> 'in'
%           TickLength -> [0.0100, 0.0250]
%       'pretty'
%           Box        -> 'off'
%           Grid       -> 'none'
%           GridStyle  -> 'current'
%           MinorTick  -> 'all'
%           TickDir    -> 'out'
%           TickLength -> [0.0050, 0.0125]
%       'simple'
%           Box        -> 'off'
%           Grid       -> 'none'
%           GridStyle  -> 'current'
%           MinorTick  -> 'none'
%           TickDir    -> 'out'
%           TickLength -> [0.0050, 0.0125]
%       'smart'
%           Box        -> 'off'
%           Grid       -> 'none'
%           GridStyle  -> 'current'
%           MinorTick  -> 'smart'
%           TickDir    -> 'out'
%           TickLength -> [0.0050, 0.0125]
%
%   ColorBarStyle
%       'current'
%           ColorBarBox           -> 'current'
%           ColorBarMinorTick     -> 'current'
%           ColorBarTickDir       -> 'current'
%           ColorBarWidth         -> 'current'
%           ColorBarGrid          -> 'current'
%           ColorBarGridLineStyle -> 'current'
%           ColorBarGap           -> 0.1 [inches]
%       'fancy'
%           ColorBarBox           -> 'on'
%           ColorBarMinorTick     -> 'on'
%           ColorBarTickDir       -> 'out'
%           ColorBarWidth         -> 0.15 [inches]
%           ColorBarGrid          -> 'on'
%           ColorBarGridLineStyle -> ':'
%           ColorBarGap           -> 0.1 [inches]
%       'plain'
%           ColorBarBox           -> 'on'
%           ColorBarMinorTick     -> 'off'
%           ColorBarTickDir       -> 'in'
%           ColorBarWidth         -> 0.2778 [inches]
%           ColorBarGrid          -> 'off'
%           ColorBarGridLineStyle -> 'current'
%           ColorBarGap           -> 0.1 [inches]
%       'pretty'
%           ColorBarBox           -> 'off'
%           ColorBarMinorTick     -> 'on'
%           ColorBarTickDir       -> 'out'
%           ColorBarWidth         -> 0.15 [inches]
%           ColorBarGrid          -> 'off'
%           ColorBarGridLineStyle -> 'current'
%           ColorBarGap           -> 0.1 [inches]
%
%   ColorStyle
%       'current'
%           ColorMap      -> 'current'
%           ColorSequence -> 'current'
%       'gray' | 'grayscale'
%           ColorMap      -> 'gray'
%           ColorSequence -> 'gray'
%       'plain'
%           ColorMap      -> 'jet'
%           ColorSequence -> 'plain'
%       'pretty'
%           ColorMap      -> 'blue'
%           ColorSequence -> 'gray'
%
%   ContourStyle
%       'black'
%           ContourFill      -> 'off'
%           ContourFontColor -> 'Black'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'Black'
%           ContourText      -> 'on'
%       'current'
%           ContourFill      -> 'current'
%           ContourFontColor -> 'current'
%           ContourFontName  -> 'current'
%           ContourFontSize  -> 'current'
%           ContourLineColor -> 'current'
%           ContourText      -> 'current'
%       'fancy'
%           ContourFill      -> 'on'
%           ContourFontColor -> 'auto'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'Black'
%           ContourText      -> 'on'
%       'pretty'
%           ContourFill      -> 'off'
%           ContourFontColor -> 'Black'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'auto'
%           ContourText      -> 'on'
%       'simple' | 'plain'
%           ContourFill      -> 'off'
%           ContourFontColor -> 'current'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'auto'
%           ContourText      -> 'off'
%       'smooth'
%           ContourFill      -> 'on'
%           ContourFontColor -> 'current'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'auto'
%           ContourText      -> 'off'
%
%   FigureStyle
%       'current'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'current'
%           ColorBarStyle    -> 'current'
%           ColorStyle       -> 'current'
%           ContourStyle     -> 'current'
%           FontStyle        -> 'current'
%           InterpreterStyle -> 'current'
%           PlotLineStyle    -> 'current'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 'auto'
%       'fancy'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'pretty'
%           InterpreterStyle -> 'auto'
%           PlotLineStyle    -> 'pretty'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 'auto'
%       'onecol'
%           AspectRatio      -> (sqrt(5) - 1) / 2
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'fancy'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'fancy'
%           FontStyle        -> 'pretty'
%           InterpreterStyle -> 'auto'
%           PlotLineStyle    -> 'fancy'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 6 [inches]
%       'plain'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'plain'
%           ColorBarStyle    -> 'plain'
%           ColorStyle       -> 'plain'
%           ContourStyle     -> 'plain'
%           FontStyle        -> 'plain'
%           InterpreterStyle -> 'current'
%           PlotLineStyle    -> 'plain'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'loose'
%           Width            -> 'auto'
%       'present' | 'presentation'
%           AspectRatio      -> 0.75
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'present'
%           InterpreterStyle -> 'auto'
%           PlotLineStyle    -> 'pretty'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 2.125 [inches]
%       'pretty'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'fancy'
%           ColorBarStyle    -> 'fancy'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'fancy'
%           FontStyle        -> 'pretty'
%           InterpreterStyle -> 'auto'
%           PlotLineStyle    -> 'fancy'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 'auto'
%       'twocol' | 'journal'
%           AspectRatio      -> 0.75
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'gray'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'pretty'
%           InterpreterStyle -> 'auto'
%           PlotLineStyle    -> 'pretty'
%           Margin           -> 0.025 * ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 3.4 [inches]
%
%   FontStyle
%       'current'
%           FontName -> 'current'
%           FontSize -> 'current'
%       'plain'
%           FontName -> 'Helvetica'
%           FontSize -> 10
%       'pretty' | 'fancy' | 'present' | 'presentation'
%           FontName -> 'Times New Roman'
%           FontSize -> 9
%       'sans-serif'
%           FontName -> 'Helvetica'
%           FontSize -> 'current'
%       'serif'
%           FontName -> 'Times New Roman'
%           FontSize -> 'current'
%
%   PlotStyle
%       'current'
%           PlotLineStyle -> 'current'
%           PlotLineWidth -> 'current'
%       'fancy'
%           PlotLineStyle -> 'fancy'
%           PlotLineWidth -> 'fancy'
%       'plain'
%           PlotLineStyle -> 'plain'
%           PlotLineWidth -> 'plain'
%       'pretty'
%           PlotLineStyle -> 'pretty'
%           PlotLineWidth -> 'pretty'
%

% Versions:
%  2010/02/15 @Sean Torrez    : First version
%  2010/03/09 @Sean Torrez    : Modified to use fig handles only
%  2010/11/02 @Derek Dalle    : Changed to set_plot
%  2010/11/06 @Derek Dalle    : First version
%
% Public domain

%% --- Input processing ---

% Number of varargs
n_arg = length(varargin);
% Set index of current input.
i_arg = 0;
% Check first input.
if n_arg > 0 && isnumeric(varargin{1})
	% First input is figure handle.
	h_f = varargin{1};
	% Move to next argument.
	i_arg = 1;
else
	% Just use gcf.
	h_f = gcf;
end

% Initial options
options = struct();

% Process the optional inputs.
% Process each argument.
while n_arg > i_arg
	% Move to the next argument.
	i_arg = i_arg + 1;
	% Get the current argument's value.
	v_arg  = varargin{i_arg};
	% Test which type it is.
	if ischar(v_arg)
		% Check if there is an option value.
		if i_arg >= n_arg
			% Odd number of options.
			error('set_plot:OptionNumber', ['Each option name ', ...
				'must be assigned a value.']);
		end
		% Value of the next argument.
		v_next = varargin{i_arg+1};
		% Assign option name/value pairs to a struct.
		options.(v_arg) = v_next;
		% Move to the next argument.
		i_arg = i_arg + 1;
		
	elseif isempty(v_arg)
		% Do nothing.
		
	elseif isstruct(v_arg)
		% Get fields.
		v_fields = fieldnames(v_arg);
		% Assign them.
		for i_field = 1:length(v_fields)
			% Current field
			c_field = v_fields{i_field};
			% Assignment
			options.(c_field) = v_arg.(c_field);
		end
	else
		% Bad input
		error('masiv:BadInput', ['Each optional input must be ', ...
			'either empty, a struct, or an option name/value pair.']);
		
	end
end


%% --- Units and handles ---
% Current units
[units, options] = cut_option(options, 'Units', 'inches');
% Unit conversion from inches to (units).
if strcmpi(units, 'inches')
	r_units = 1;
elseif strcmpi(units, 'centimeters')
	r_units = 2.54;
elseif strcmpi(units, 'points')
	r_units = 1/72;
end

% Axis handle
h_a = get(h_f, 'CurrentAxes');

% Set matching units.
set(h_f, 'Units'     , units);
set(h_f, 'PaperUnits', units);
set(h_a, 'Units'     , units);

% Axis labels
h_x = get(h_a, 'XLabel');
h_y = get(h_a, 'YLabel');
h_z = get(h_a, 'ZLabel');
% Get the intepreters for each label.
i_x = get(h_x, 'Interpreter');
i_y = get(h_y, 'Interpreter');
i_z = get(h_z, 'Interpreter');
% Set them to 'none' for sizing purposes.
set([h_x, h_y, h_z], 'Interpreter', 'none');

% Positions
pos_fig  = get(h_f, 'Position');
pos_axes = get(h_a, 'Position');


%% --- Overall style ---

% Determine overall style of figure.
[s_cur, options] = cut_option(options, 'FigureStyle', 'current');
% Process value
% This format is for a two-column journal.
q_journal = strcmpi(s_cur, 'journal');
q_fancy   = strcmpi(s_cur, 'fancy'  );
q_twocol  = strcmpi(s_cur, 'twocol' ) || q_journal;
q_onecol  = strcmpi(s_cur, 'onecol' );
q_present = strcmpi(s_cur, 'present') || strcmpi(s_cur, 'presentation');
q_pretty  = strcmpi(s_cur, 'pretty' );
q_plain   = strcmpi(s_cur, 'plain'  );
q_current = strcmpi(s_cur, 'current');

% Set default options based on overall style.
if q_pretty
	% This style uses the
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Approach for interpreters
	i_style = 'auto';
	% Default aspect ratio
	ar_fig  = 'auto';
	% Default width
	w_fig   = 'auto';
	% Font style
	f_style = 'pretty';
	% Axes style
	a_style = 'pretty';
	% Style for the colorbar
	cbar_style = 'pretty';
	% Color theme style
	c_style = 'pretty';
	% Plot style
	l_style = 'pretty';
	% Contour style
	ctr_style = 'pretty';
	
elseif q_fancy
	% Style containing even more marking
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Approach for interpreters
	i_style = 'auto';
	% Default aspect ratio
	ar_fig  = 'auto';
	% Default width
	w_fig   = 'auto';
	% Font style
	f_style = 'pretty';
	% Axes style
	a_style = 'fancy';
	% Style for the colorbar
	cbar_style = 'fancy';
	% Color theme style
	c_style = 'pretty';
	% Plot style
	l_style = 'fancy';
	% Contour style
	ctr_style = 'fancy';
	
elseif q_twocol
	% Complete style for two-column papers
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Approach for interpreters
	i_style = 'auto';
	% Default aspect ratio
	ar_fig  = 0.75;
	% Default width
	w_fig   = 3.4 * r_units;
	% Font style
	f_style = 'pretty';
	% Axes style
	a_style = 'pretty';
	% Style for the colorbar
	cbar_style = 'pretty';
	% Color theme style
	c_style = 'gray';
	% Plot style
	l_style = 'pretty';
	% Contour style
	ctr_style = 'pretty';
	
elseif q_onecol
	% Approach for figures in one-column papers
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Use automatic interpreters.
	i_style = 'auto';
	% Default aspect ratio
	ar_fig  = (sqrt(5) - 1) / 2;
	% Default width
	w_fig   = 6 * r_units;
	% Font style
	f_style = 'pretty';
	% Axes style
	a_style = 'pretty';
	% Style for the colorbar
	cbar_style = 'fancy';
	% Color theme style
	c_style = 'pretty';
	% Plot style
	l_style = 'fancy';
	% Contour style
	ctr_style = 'fancy';
	
elseif q_present
	% Style for presentation (with bigger fonts)
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Use automatic interpreters.
	i_style = 'auto';
	% Default aspect ratio
	ar_fig  = 0.75;
	% Default width
	w_fig   = 2.125 * r_units;
	% Font style
	f_style = 'present';
	% Axes style
	a_style = 'pretty';
	% Style for the colorbar
	cbar_style = 'pretty';
	% Color theme style
	c_style = 'pretty';
	% Plot style
	l_style = 'pretty';
	% Contour style
	ctr_style = 'pretty';
	
elseif q_plain
	% Plain style
	% Default margin style
	m_style = 'loose';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Use current interpreters.
	i_style = 'current';
	% Default aspect ratio
	ar_fig  = 'auto';
	% Default width
	w_fig   = 'auto';
	% Font style
	f_style = 'plain';
	% Axes style
	a_style = 'plain';
	% Style for the colorbar
	cbar_style = 'plain';
	% Color theme style
	c_style = 'plain';
	% Plot style
	l_style = 'plain';
	% Contour style
	ctr_style = 'plain';
	
elseif q_current
	% Plain style
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = 0.025 * ones(1,4);
	% Use current interpreters.
	i_style = 'current';
	% Default aspect ratio
	ar_fig  = 'auto';
	% Default width
	w_fig   = 'auto';
	% Font style
	f_style = 'current';
	% Axes style
	a_style = 'current';
	% Style for the colorbar
	cbar_style = 'current';
	% Color theme style
	c_style = 'current';
	% Plot style
	l_style = 'current';
	% Contour style
	ctr_style = 'current';
	
else
	% Bad input
	error('set_plot:BadStyle', ['FigureStyle must be either ', ...
		'''pretty'', ''plain'', ''present'', ''presentation'',\n', ...
		'''current'', ''journal'', ''fancy'', ''twocol'', or ''onecol''.']);
	
end


%% --- Font style ---
% Get font style options.
[f_style, options] = cut_option(options, 'FontStyle', f_style);

% Set defaults related to font style.
if strcmpi(f_style, 'pretty') || strcmpi(f_style, 'fancy')
	% Make all aspects of the written quantities look good.
	% Font name
	f_name = 'Times New Roman';
	% Font size
	f_size = 9;
	
elseif strcmpi(f_style, 'present') || strcmpi(f_style, 'presentation')
	% Special style for presentations
	% Font name
	f_name = 'Times New Roman';
	% Font size
	f_size = 9;
	
elseif strcmpi(f_style, 'serif')
	% Just change the font type.
	% Font name
	f_name = 'Times New Roman';
	% Font size
	f_size = 'current';
	
elseif strcmpi(f_style, 'sans-serif')
	% Change the fonts back to Helvetica.
	% Font name
	f_name = 'Helvetica';
	% Font size
	f_size = 'current';
	
elseif strcmpi(f_style, 'plain')
	% Change the fonts back to teh defaults.
	% Font name
	f_name = 'Helvetica';
	% Font size
	f_size = 10;
	
elseif strcmpi(f_style, 'current')
	% Don't change anything.
	% Font name
	f_name = 'current';
	% Font size
	f_size = 'current';
	
else
	% Bad input
	error('set_plot:BadStyle', ['FontStyle must be either ', ...
		'''pretty'', ''current'', ''present'', ''presentation'',\n', ...
		'''fancy'', ''plain'', ''serif'', or ''sans-serif''.']);
	
end


%% --- Axes style ---

% Get the axes style options.
[a_style, options] = cut_option(options, 'AxesStyle', a_style);

% Set defaults related to axes style.
if strcmpi(a_style, 'pretty')
	% Shorter tick length
	l_tick = [0.0050, 0.0125];
	% Tick direction
	d_tick = 'out';
	% Box
	s_box  = 'off';
	% Minor ticks
	s_tick = 'all';
	% Grid
	r_grid = 'none';
	% Grid style
	s_grid = 'current';
	
elseif strcmpi(a_style, 'simple')
	% Shorter tick length
	l_tick = [0.0050, 0.0125];
	% Tick direction
	d_tick = 'out';
	% Box
	s_box  = 'off';
	% Minor ticks
	s_tick = 'none';
	% Grid
	r_grid = 'none';
	% Grid style
	s_grid = 'current';
	
elseif strcmpi(a_style, 'plain')
	% Shorter tick length
	l_tick = [0.0100, 0.0250];
	% Tick direction
	d_tick = 'in';
	% Box
	s_box  = 'on';
	% Minor ticks
	s_tick = 'none';
	% Grid
	r_grid = 'none';
	% Grid style
	s_grid = 'current';
	
elseif strcmpi(a_style, 'fancy')
	% Shorter tick length
	l_tick = [0.0050, 0.0125];
	% Tick direction
	d_tick = 'out';
	% Box
	s_box  = 'off';
	% Minor ticks
	s_tick = 'all';
	% Grid
	r_grid = 'major';
	% Grid style
	s_grid = ':';
	
elseif strcmpi(a_style, 'smart')
	% Shorter tick length
	l_tick = [0.0050, 0.0125];
	% Tick direction
	d_tick = 'out';
	% Box
	s_box  = 'off';
	% Minor ticks
	s_tick = 'smart';
	% Grid
	r_grid = 'none';
	% Grid style
	s_grid = 'current';
	
elseif strcmpi(a_style, 'current')
	% Shorter tick length
	l_tick = 'current';
	% Tick direction
	d_tick = 'current';
	% Box
	s_box  = 'current';
	% Minor ticks
	s_tick = 'current';
	% Grid
	r_grid = 'current';
	% Grid style
	s_grid = 'current';
	
else
	% Bad input
	error('set_plot:BadStyle', ['AxesStyle must be either ', ...
		'''pretty'', ''simple'', ''current'', ''fancy'', or ''smart''.']);
	
end


%% --- Colorbar style ---

% Determine whether or not there's a color bar.
q_cbar  = false;
% Get the children of the figure handle.
h_child = get(h_f, 'Children');
% Loop through them.
for i = 1:numel(h_child)
	% Test if it is a colorbar object.
	if strcmpi(get(h_child(i), 'Tag'), 'colorbar')
		% Store colorbar handle.
		h_cbar = h_child(i);
		% Change value of test variable.
		q_cbar = true;
		continue
	end
end

% Stats on the color bar
if q_cbar
	% Get ColorBarStyle option.
	[cbar_style, options] = cut_option(...
		options, 'ColorBarStyle', cbar_style);
	% Process ColorBarStyle option.
	if strcmpi(cbar_style, 'pretty')
		% Whether or not to have a box
		cbar_box = 'off';
		% Tick direction
		cbar_d_tick = 'out';
		% Minor ticks
		cbar_m_tick = 'on';
		% Width of colorbar
		w_cbar = 0.15 * r_units;
		% Grid lines
		q_g_cbar = 'off';
		% Grid line style
		s_g_cbar = 'current';
		% Size of gap from axes
		m_gap = 0.10 * r_units;
		
	elseif strcmpi(cbar_style, 'fancy')
		% Whether or not to have a box
		cbar_box = 'on';
		% Tick direction
		cbar_d_tick = 'out';
		% Minor ticks
		cbar_m_tick = 'on';
		% Width of colorbar
		w_cbar = 0.15 * r_units;
		% Grid lines
		q_g_cbar = 'on';
		% Grid line style
		s_g_cbar = ':';
		% Size of gap from axes
		m_gap = 0.10 * r_units;
		
	elseif strcmpi(cbar_style, 'plain')
		% Whether or not to have a box
		cbar_box = 'on';
		% Tick direction
		cbar_d_tick = 'out';
		% Minor ticks
		cbar_m_tick = 'off';
		% Width of colorbar
		w_cbar = 0.2778 * r_units;
		% Grid lines
		q_g_cbar = 'off';
		% Grid line style
		s_g_cbar = ':';
		% Size of gap from axes
		m_gap = 0.10 * r_units;
		
	elseif strcmpi(cbar_style, 'current')
		% Whether or not to have a box
		cbar_box = 'current';
		% Tick direction
		cbar_d_tick = 'current';
		% Minor ticks
		cbar_m_tick = 'current';
		% Width of colorbar
		w_cbar = 'current';
		% Grid lines
		q_g_cbar = 'current';
		% Grid line style
		s_g_cbar = 'current';
		% Size of gap from axes
		m_gap = 0.10 * r_units;
		
	else
		% Bad input
		error('set_plot:ColorBarStyle', ['ColorBarStyle must be ', ...
			'either ''pretty'', ''fancy'', ''plain'', or ''current''.']);
	end
end


%% --- Color scheme ---

% Get the approach for the color schemes.
[c_style, options] = cut_option(options, 'ColorStyle', c_style);

% Process the minor options.
if strcmpi(c_style, 'pretty')
	% Color map
	s_cmap = 'blue';
	% Color sequence for plots
	c_pseq = 'gray';
	
elseif strcmpi(c_style, 'plain')
	% Color map
	s_cmap = 'jet';
	% Color sequence for plots
	c_pseq = 'plain';
	
elseif strcmpi(c_style, 'gray') || strcmpi(c_style, 'grayscale')
	% Color map
	s_cmap = 'gray';
	% Color sequence for plots
	c_pseq = 'gray';
	
elseif strcmpi(c_style, 'current')
	% Color map
	s_cmap = 'current';
	% Color sequence for plots
	c_pseq = 'current';
	
else
	% Bad input
	error('set_plot:ColorStyle', ['ColorStyle must be ''pretty'', ', ...
		'''gray'', ''plain'', or ''current''.']);
	
end


%% --- Plot style scheme ---

% Get the approach for the plot style scheme.
[l_style, options] = cut_option(options, 'PlotStyle', l_style);

% Process the minor options.
if strcmpi(l_style, 'pretty')
	% Line style sequence
	l_pseq = 'pretty';
	% Line thickness sequence
	t_pseq = 'pretty';
	
elseif strcmpi(l_style, 'fancy')
	% Line style sequence
	l_pseq = 'fancy';
	% Line thickness sequence
	t_pseq = 'fancy';
	
elseif strcmpi(l_style, 'plain')
	% Line style sequence
	l_pseq = 'plain';
	% Line thickness sequence
	t_pseq = 'plain';
	
elseif strcmpi(l_style, 'current')
	% Line style sequence
	l_pseq = 'current';
	% Line thickness sequence
	t_pseq = 'current';
	
else
	% Bad input
	error('set_plot:PlotStyle', ['PlotStyle must be ''pretty'', ', ...
		'''fancy'', ''plain'', or ''current''.']);
end


%% --- Contour style ---

% Get the contour style option.
[ctr_style, options] = cut_option(options, 'ContourStyle', ctr_style);

% Check value of string
if strcmpi(ctr_style, 'pretty')
	% Filled or not
	q_fill = 'off';
	% Labels or not
	q_label = 'on';
	% Line color
	c_c_line = 'auto';
	% Label font color
	c_c_lbl = 'Black';
	% Label font name
	f_c_lbl = 'auto';
	% Label font size
	s_c_lbl = 'auto';
	
elseif strcmpi(ctr_style, 'fancy')
	% Filled or not
	q_fill = 'on';
	% Labels or not
	q_label = 'on';
	% Line color
	c_c_line = 'Black';
	% Label font color
	c_c_lbl = 'auto';
	% Label font name
	f_c_lbl = 'auto';
	% Label font size
	s_c_lbl = 'auto';
	
elseif strcmpi(ctr_style, 'black')
	% Filled or not
	q_fill = 'off';
	% Labels or not
	q_label = 'on';
	% Line color
	c_c_line = 'Black';
	% Label font color
	c_c_lbl = 'Black';
	% Label font name
	f_c_lbl = 'auto';
	% Label font size
	s_c_lbl = 'auto';
	
elseif strcmpi(ctr_style, 'fill')
	% Filled or not
	q_fill = 'on';
	% Labels or not
	q_label = 'off';
	% Line color
	c_c_line = 'Black';
	% Label font color
	c_c_lbl = 'current';
	% Label font name
	f_c_lbl = 'auto';
	% Label font size
	s_c_lbl = 'auto';
	
elseif strcmpi(ctr_style, 'smooth')
	% Filled or not
	q_fill = 'on';
	% Labels or not
	q_label = 'off';
	% Line color
	c_c_line = 'auto';
	% Label font color
	c_c_lbl = 'current';
	% Label font name
	f_c_lbl = 'auto';
	% Label font size
	s_c_lbl = 'auto';
	
elseif strcmpi(ctr_style, 'simple') || strcmpi(ctr_style, 'plain')
	% Filled or not
	q_fill = 'off';
	% Labels or not
	q_label = 'off';
	% Line color
	c_c_line = 'auto';
	% Label font color
	c_c_lbl = 'current';
	% Label font name
	f_c_lbl = 'auto';
	% Label font size
	s_c_lbl = 'auto';
	
elseif strcmpi(ctr_style, 'current')
	% Filled or not
	q_fill = 'current';
	% Labels or not
	q_label = 'current';
	% Line color
	c_c_line = 'current';
	% Label font color
	c_c_lbl = 'current';
	% Label font name
	f_c_lbl = 'current';
	% Label font size
	s_c_lbl = 'current';
	
else
	% Bad input
	error('set_plot:ContourStyle', ['ContourStyle must be ', ...
		'''pretty'', ''fancy'', ''fill'', ''simple'',\n', ...
		'''black'', ''plain'', ''smooth'', or ''current''.']);
	
end


%% --- Children processing ---

% Get the handle for the title.
h_title = get(h_a, 'Title');

% Get the children of the current axes.
h_child = get(h_a, 'Children');

% List of what type each child is.
t_child = get(h_child, 'Type');

% Convert to cell array if necessary.
if ~iscell(t_child)
	t_child = {t_child};
end

% Find the children that are lines.
h_line = h_child(cell_position_string(t_child, 'line'));
% Find the children that are text boxes.
h_text = h_child(cell_position_string(t_child, 'text'));
% Get the contour objects
h_contour = h_child(cell_position_string(t_child, 'hggroup'));


%% --- Color map ---

% Get the colormap option
[s_cmap, options] = cut_option(options, 'ColorMap', s_cmap);

% Check for 'current'.
if ~strcmpi(s_cmap, 'current')
	set_colormap(h_f, s_cmap);
end


%% --- Line style sequence ---

% Get the PlotLineStyle option.
[l_pseq, options] = cut_option(options, 'PlotLineStyle', l_pseq);

% Test for a recognized string.
if ischar(l_pseq) && ~strcmpi(l_pseq, 'current')
	% Look at the values of the string.
	if strcmpi(l_pseq, 'pretty')
		% Solid, dotted, dashed
		v_pseq = {'-', ':', '--'};
	elseif strcmpi(l_pseq, 'fancy')
		% Solid, dotted, dashed, dot-dashed
		v_pseq = {'-', ':', '--', '-.'};
	elseif strcmpi(l_pseq, 'simple')
		% Solid, dashed
		v_pseq = {'-', '--'};
	elseif strcmpi(l_pseq, 'plain')
		% Solid only
		v_pseq = {'-'};
	else
		% Bad input
		error('set_plot:PlotLineStyle', ['PlotLineStyle must be ', ...
			'''pretty'', ''fancy'', ''simple'', ''plain'', ', ...
			'or ''current''.']);
	end
elseif iscell(l_pseq)
	% Transfer the cell array.
	v_pseq = l_pseq;
elseif ~strcmpi(l_pseq, 'current')
	error('set_plot:PlotLineStyle', ['PlotLineStyle must be ', ...
		'either a recognized string or a cell array.']);
end

% Apply the conversions.
if ~strcmpi(l_pseq, 'current') && iscell(v_pseq)
	% Number of styles.
	n_pseq = numel(v_pseq);
	% Number of handles
	n_line = numel(h_line);
	% Index of style to use.
	i_pseq = 1;
	% Loop backwards through lines.
	for i = n_line:-1:1
		% Set the color.
		set(h_line(i), 'LineStyle', v_pseq{i_pseq});
		% Move to the next style.
		i_pseq = i_pseq + 1;
		% Check if the colors should start over.
		if i_pseq > n_pseq
			i_pseq = 1;
		end
	end
end


%% --- Thickness sequence ---

% Get the PlotLineStyle option.
[t_pseq, options] = cut_option(options, 'PlotLineWidth', t_pseq);

% Test for a recognized string.
if ischar(t_pseq) && ~strcmpi(t_pseq, 'current')
	% Look at the values of the string.
	if strcmpi(t_pseq, 'pretty')
		% Solid, dotted, dashed
		v_pseq = [0.5, 0.5, 0.5, 2.0, 2.0, 2.0];
	elseif strcmpi(t_pseq, 'fancy')
		% Solid, dotted, dashed, dot-dashed
		v_pseq = [0.5, 0.5, 0.5, 0.5, 2.0, 2.0, 2.0, 2.0];
	elseif strcmpi(t_pseq, 'simple')
		% Solid, dashed
		v_pseq = [0.5, 0.5, 2.0, 2.0];
	elseif strcmpi(t_pseq, 'plain')
		% Solid only, one width
		v_pseq = 0.5;
	else
		% Bad input
		error('set_plot:PlotLineWidth', ['PlotLineWidth must be ', ...
			'''pretty'', ''fancy'', ''simple'', ''plain'', ', ...
			'or ''current''.']);
	end
elseif isnumeric(t_pseq)
	% Transfer the values.
	v_pseq = t_pseq;
elseif iscell(t_pseq)
	% Try to transfer the values.
	v_pseq = [ t_pseq{:} ];
elseif ~strcmpi(t_pseq, 'current')
	% Bad input type
	error('set_plot:PlotLineStyle', ['PlotLineWidth must be ', ...
		'either a recognized string, matrix, or cell array.']);
end

% Apply the conversions.
if ~strcmpi(t_pseq, 'current') && isnumeric(v_pseq)
	% Number of styles.
	n_pseq = numel(v_pseq);
	% Number of handles
	n_line = numel(h_line);
	% Index of style to use.
	i_pseq = 1;
	% Loop backwards through lines.
	for i = n_line:-1:1
		% Set the color.
		set(h_line(i), 'LineWidth', v_pseq(i_pseq));
		% Move to the next style.
		i_pseq = i_pseq + 1;
		% Check if the colors should start over.
		if i_pseq > n_pseq
			i_pseq = 1;
		end
	end
end


%% --- Color sequence ---

% Get the ColorSequence option.
[c_pseq, options] = cut_option(options, 'ColorSequence', c_pseq);

% Check the type of the sequence, and convert it to an Nx3 matrix.
if isnumeric(c_pseq)
	% Numeric
	% Check the size
	if size(c_pseq,2) == 3 && numel(size(c_pseq)) == 2
		% Transfer the map.
		v_pseq = c_pseq;
	else
		% Bad input
		error('set_plot:ColorSequenceMatrix', ['Numeric ', ...
			'ColorSequence must be an Nx3 matrix.']);
	end
	
elseif iscell(c_pseq)
	% Cell array
	% Just transfer the cell array and process it later.
	v_pseq = c_pseq;
	
elseif ~ischar(c_pseq);
	% Bad input
	error('set_plot:ColorSequenceType', ['ColorSequence must be a ', ...
		'string, cell array, or Nx3 matrix.']);
	
elseif ~strcmpi(c_pseq, 'current')
	% String
	% Check for list of known color sequence schemes.
	if strcmpi(c_pseq, 'plain') || strcmpi(c_pseq, 'default')
		% Numeric color sequence.
		v_pseq = [
			0.00, 0.00, 1.00;
			0.00, 0.50, 0.00;
			1.00, 0.00, 0.00;
			0.00, 0.75, 0.75;
			0.75, 0.00, 0.75;
			0.75, 0.75, 0.00;
			0.25, 0.25, 0.25];
	elseif strcmpi(c_pseq, 'gray')
		% Short grayscale scheme
		v_pseq = {'Black', 'Silver', 'LightGray'};		
	elseif strcmpi(c_pseq, 'black') || strcmpi(c_pseq, 'k')
		% Only one color.
		v_pseq = {'Black'};
	elseif strcmpi(c_pseq, 'blue')
		% Long bluescale scheme
		v_pseq = {'Navy', 'Blue', 'Aqua', 'SkyBlue', 'DarkBlue', ...
			'RoyalBlue', 'Cyan', 'LightBlue'};
	elseif strcmpi(c_pseq, 'dark')
		% List of dark colors.
		v_pseq = {'Navy', 'ForestGreen', 'DarkRed', 'Silver', ...
			'SaddleBrown', 'DodgerBlue', 'DarkSalmon'};
	elseif strcmpi(c_pseq, 'bright')
		% Lit of vibrant colors.
		v_pseq = {'Cyan', 'Magenta', 'LawnGreen', ...
			'Orange', 'GoldenRod', 'Teal'};
	else
		% Unrecognized scheme
		error('set_plot:UnknownSeq', ['ColorSequence %s ', ...
			'was not recognized.'], c_pseq);
	end
	
end

% Convert cell array if needed.
if ~strcmpi(c_pseq, 'current') && iscell(v_pseq)
	% Cell array
	% Transfer back to cell.
	c_pseq = v_pseq;
	% Number of colors.
	n_pseq = numel(c_pseq);
	% Initialize numeric color sequence.
	v_pseq = zeros(n_pseq, 3);
	% Loop through each color.
	for i = 1:n_pseq
		% Current color
		c_cur = c_pseq{i};
		% Check the type.
		if isnumeric(c_cur) && numel(c_cur) == 3
			% Store the color.
			v_pseq(i,:) = c_cur(:)';
		elseif ischar(c_cur)
			% Attempt to convert it.
			v_cur = html2rgb(c_cur);
			% Check for success.
			if any(isnan(v_cur))
				% Unrecognized color
				error('set_plot:UnknownColor', ['Color named %s ', ...
					'was not recognized.'], c_cur);
			else
				% Store the color.
				v_pseq(i,:) = v_cur;
			end
		end
	end
end

% Apply the sequence.
if ~strcmpi(c_pseq, 'current')
	% Number of colors.
	n_pseq = size(v_pseq, 1);
	% Number of handles
	n_line = numel(h_line);
	% Index of color to use.
	i_pseq = 1;
	% Loop backwards through lines.
	for i = n_line:-1:1
		% Set the color.
		set(h_line(i), 'Color', v_pseq(i_pseq,:));
		% Move to the next color.
		i_pseq = i_pseq + 1;
		% Check if the colors should start over.
		if i_pseq > n_pseq
			i_pseq = 1;
		end
	end
end


%% --- Font size application ---

% Get handles relating to fonts.
h_font = [h_a, h_x, h_y, h_z, h_title, h_text];

% Get font size.
[f_size, options] = cut_option(options, 'FontSize', f_size);
% Check for 'current'.
if ~strcmpi(f_size, 'current')
	% Apply changes.
	set(h_font, 'FontSize', f_size);
end

% Remember the current font.
f_cur = get(h_font, 'FontName');
% Set the default font to get sizing correct.
set(h_font, 'FontName', 'Helvetica')


%% --- Contour formatting ---

% Only bother if there are contours
if numel(h_contour) > 0
	% Get the fill option.
	[q_fill, options] = cut_option(options, 'ContourFill', q_fill);
	% Apply it.
	if ~strcmpi(q_fill, 'current')
		set(h_contour, 'Fill', q_fill);
	end
	
	% Get the label option.
	[q_label, options] = cut_option(options, 'ContourText', q_label);
	% Apply it.
	if ~strcmpi(q_label, 'current')
		set(h_contour, 'ShowText', q_label);
	end
	
	% Get the labels if possible.
	h_c_child = get(h_contour, 'Children');
	% Type of each.
	i_c_child = get(h_c_child, 'Type');
	% Find those that are labels.
	h_c_text  = h_c_child(cell_position_string(i_c_child, 'text'));
	% Find those that are lines.
	h_c_line  = h_c_child(cell_position_string(i_c_child, 'line'));
	% Move all labels so that they don't cross the contour lines by default.
	set(h_c_text, 'VerticalAlignment', 'bottom');
	
	% Get the font size option.
	[s_c_lbl, options] = cut_option(options, 'ContourFontSize', s_c_lbl);
	% Evaluate 'auto'.
	if strcmpi(s_c_lbl, 'auto')
		% Give it a smaller value than the overall font size.
		s_c_lbl = f_size - 1;
	end
	% Check for 'current'.
	if ~strcmpi(s_c_lbl, 'current')
		% Apply the font size change.
		set(h_c_text, 'FontSize', s_c_lbl);
	end
	
	% Get the line coloring option.
	[c_c_line, options] = cut_option(options, 'ContourLineColor', c_c_line);
	% Apply it.
	if ischar(c_c_line)
		% Check for recognized values.
		if strcmpi(c_c_line, 'current')
			% Do nothing.
		elseif strcmpi(c_c_line, 'auto')
			% Use the given value.
			set(h_contour, 'LineColor', c_c_line);
			% In this case the labels should be on the boundary.
			set(h_c_text, 'VerticalAlignment', 'middle')
		else
			% Attempt a conversion to a single color.
			v_c_line = html2rgb(c_c_line);
			% Check for a successful conversion.
			if any(isnan(v_c_line))
				% Unrecognized color
				error('set_plot:UnkonwContourColor', ['ContourLineColor ', ...
					'%s was not recognized.'], c_c_line);
			else
				% Apply the rgb color
				set(h_contour, 'LineColor', v_c_line);
			end
		end
	elseif isnumeric(c_c_line)
		% Apply the color directly
		set(h_contour, 'LineColor', c_c_line);
	else
		% Bad input type
		error('set_plot:ContourColor', ['ContourLineColor must be ', ...
			'string or 1x3 double.']);
	end
	
	% Get the font name option.
	[f_c_lbl, options] = cut_option(options, 'ContourFontName', f_c_lbl);
	% Apply it.
	if strcmpi(f_c_lbl, 'auto')
		% Use the overall font.
		set(h_c_text, 'FontName', f_name);
	elseif strcmpi(f_c_lbl, 'current')
		% Do nothing.
	elseif ischar(f_c_lbl)
		% Apply the given option
		set(h_c_text, 'FontName', f_c_lbl);
	else
		% Bad type
		error('set_plot:ContourFont', ['ContourFontName must be ', ...
			'''auto'', ''current'', or a recognized font name.']);
	end
	
	% Get the font color option.
	[c_c_lbl, options] = cut_option(options, 'ContourFontColor', c_c_lbl);
	% Apply it.
	if strcmpi(c_c_lbl, 'auto')
		% Pick a color that doesn't clash (hopefully) for each label.
		% Number of labels..
		n_lbl = numel(h_c_text);
		% Get the current color map.
		v_cmap = get(h_f, 'ColorMap');
		% Get the limits of the color map.
		m_cmap = get(h_a, 'CLim');
		% Get the interpolation points.
		i_cmap = linspace(0, 1, size(v_cmap,1));
		% Little vector for converting rgb to grayscale.
		v_rgb  = [0.299; 0.587; 0.114];
		% Loop through each label.
		for i = 1:n_lbl
			% Get the value of the contour via the label text.
			v_lbl = str2double(get(h_c_text(i), 'String'));
			% Find the normalized value (for the colormap).
			x_lbl = (v_lbl - min(m_cmap)) / diff(m_cmap);
			% Interpolate to find the corresponding color.
			c_cur = interp1(i_cmap, v_cmap, x_lbl);
			% Convert to grayscale.
			c_cur = ones(1,3) * (c_cur * v_rgb);
			% Choose between black and white accordingly.
			set(h_c_text(i), 'Color', c_cur < 0.5);
		end
		
	elseif strcmpi(c_c_lbl, 'current')
		% Do nothing
	elseif ischar(c_c_lbl)
		% Try to apply a single color.
		% Convert the color.
		v_c_lbl = html2rgb(c_c_lbl);
		% Check for success.
		if any(isnan(v_c_lbl))
			% Bad color string
			error('set_plot:ContourFontColor', ['ContourFontColor ', ...
				'%s is not recognized.'], c_c_lbl);
		else
			% Apply color.
			set(h_c_text, 'Color', v_c_lbl);
		end
	elseif isnumeric(c_c_lbl) && numel(c_c_lbl) == 3
		% Try to apply a single color.
		set(h_c_text, 'Color', c_c_lbl(:)');
	else
		% Bad input
		error('set_plot:ContourFontColor', ['ContourFontColor ', ...
			'must be ''auto'', ''current'', or a recognized color.']);
	end
end


%% --- Axes application ---

% Get the tick length.
[l_cur, options] = cut_option(options, 'TickLength', l_tick);
% Check if input is a string or numeric
if ischar(l_cur)
	% Check for 'current'.
	if strcmpi(l_cur, 'current')
		% Get the current tick length.
		l_tick = get(h_a, 'TickLength');
	elseif strcmpi(l_cur, 'short')
		% Use a tick length half of the MATLAB defaults.
		l_tick = [0.0050, 0.0125];
	elseif strcmpi(l_cur, 'long')
		% Use the MATLAB default.
		l_tick = [0.0100, 0.0250];
	else
		% Bad input
		error('set_plot:BadString', ['TickLength must be ''current'',', ...
			'''short'', ''long'', or numeric.']);
	end
elseif isnumeric(l_cur)
	% Convert to row.
	l_cur = l_cur(:)';
	% Length of option.
	n_tick = min([2, numel(l_cur)]);
	% Augment if necessary.
	l_tick = [l_cur(1:n_tick), l_tick(n_tick+1:2)];
else
	% Bad type
	error('set_plot:BadInput', ['TickLength must be ''current'',', ...
		'''short'', ''long'', or numeric.']);
end
% Apply tick length.
set(h_a, 'TickLength', l_tick);

% Get the tick direction.
[d_tick, options] = cut_option(options, 'TickDir', d_tick);
% Check for 'current'.
if ~strcmpi(d_tick, 'current')
	% Apply.
	set(h_a, 'TickDir', d_tick);
end

% Get the box option.
[s_box, options] = cut_option(options, 'Box', s_box);
% Check for 'current'.
if ~strcmpi(s_box, 'current')
	% Apply.
	set(h_a, 'Box', s_box);
end

% Get the minor tick option
[s_tick, options] = cut_option(options, 'MinorTick', s_tick);
% Check for values that need processing.
if strcmpi(s_tick, 'current')
	% Do nothing.
	
elseif strcmpi(s_tick, 'all') || strcmpi(s_tick, 'on')
	% Turn all minor ticks on.
	set(h_a, ...
		'XMinorTick', 'on', ...
		'YMinorTick', 'on', ...
		'ZMinorTick', 'on');
elseif strcmpi(s_tick, 'off') || strcmpi(s_tick, 'none')
	% Turn all minor ticks off.
	set(h_a, ...
		'XMinorTick', 'off', ...
		'YMinorTick', 'off', ...
		'ZMinorTick', 'off');
elseif strcmpi(s_tick, 'smart')
	% Turn minor ticks on for linear scales.
	% x-axis
	if strcmpi(get(h_a, 'XScale'), 'linear')
		set(h_a, 'XMinorTick', 'on')
	else
		set(h_a, 'XMinorTick', 'off')
	end
	% y-axis
	if strcmpi(get(h_a, 'YScale'), 'linear')
		set(h_a, 'YMinorTick', 'on')
	else
		set(h_a, 'YMinorTick', 'off')
	end
	% z-axis
	if strcmpi(get(h_a, 'ZScale'), 'linear')
		set(h_a, 'ZMinorTick', 'on')
	else
		set(h_a, 'ZMinorTick', 'off')
	end
elseif numel(regexp(s_tick, '[xyzXYZ]')) == numel(s_tick)
	% Turn on/off minor ticks according to input.
	% x-axis
	if numel(regexp(s_tick, '[xX]')) > 0
		set(h_a, 'XMinorTick', 'on')
	else
		set(h_a, 'XMinorTick', 'off')
	end
	% y-axis
	if numel(regexp(s_tick, '[yY]')) > 0
		set(h_a, 'YMinorTick', 'on')
	else
		set(h_a, 'YMinorTick', 'off')
	end
	% z-axis
	if numel(regexp(s_tick, '[zZ]')) > 0
		set(h_a, 'ZMinorTick', 'on')
	else
		set(h_a, 'ZMinorTick', 'off')
	end
else
	% Bad input
	error('set_plot:TickOption', ['MinorTick must be either ''on'',', ...
		'''off'', ''all'', ''none'',\n''smart'', or a combination of', ...
		'''x'', ''y'', and ''z''.']);
end

% Get the grid option.
[r_grid, options] = cut_option(options, 'Grid', r_grid);
% Process contents of option.
if strcmpi(r_grid, 'current')
	% Do nothing
	
elseif strcmpi(r_grid, 'major') || strcmpi(r_grid, 'on')
	% Turn all major grid lines on.
	set(h_a, ...
		'XGrid', 'on', ...
		'YGrid', 'on', ...
		'ZGrid', 'on');
	% Turn all minor grid lines off.
	set(h_a, ...
		'XMinorGrid', 'off', ...
		'YMinorGrid', 'off', ...
		'ZMinorGrid', 'off');
elseif strcmpi(r_grid, 'off') || strcmpi(r_grid, 'none')
	% Turn all grid lines off.
	set(h_a, ...
		'XGrid'     , 'off', ...
		'YGrid'     , 'off', ...
		'ZGrid'     , 'off', ...
		'XMinorGrid', 'off', ...
		'YMinorGrid', 'off', ...
		'ZMinorGrid', 'off');
elseif strcmpi(r_grid, 'smart')
	% Turn all major grid lines on.
	set(h_a, ...
		'XGrid', 'on', ...
		'YGrid', 'on', ...
		'ZGrid', 'on');
	% Turn minor grid lines on for linear scales.
	% x-axis
	if strcmpi(get(h_a, 'XScale'), 'linear')
		set(h_a, 'XMinorGrid', 'on')
	else
		set(h_a, 'XMinorGrid', 'off')
	end
	% y-axis
	if strcmpi(get(h_a, 'YScale'), 'linear')
		set(h_a, 'YMinorGrid', 'on')
	else
		set(h_a, 'YMinorGrid', 'off')
	end
	% z-axis
	if strcmpi(get(h_a, 'ZScale'), 'linear')
		set(h_a, 'ZMinorGrid', 'on')
	else
		set(h_a, 'ZMinorGrid', 'off')
	end
elseif numel(regexp(r_grid, '[xyzXYZ]')) == numel(r_grid)
	% Turn on/off minor ticks according to input.
	% x-axis
	if numel(regexp(r_grid, 'X')) > 0
		set(h_a, 'XGrid', 'on')
		set(h_a, 'XMinorGrid', 'on')
	elseif numel(regexp(r_grid, 'x')) > 0
		set(h_a, 'XGrid', 'on')
		set(h_a, 'XMinorGrid', 'off')
	else
		set(h_a, 'XGrid', 'off')
		set(h_a, 'XMinorGrid', 'off')
	end
	% y-axis
	if numel(regexp(r_grid, 'Y')) > 0
		set(h_a, 'YGrid', 'on')
		set(h_a, 'YMinorGrid', 'on')
	elseif numel(regexp(r_grid, 'y')) > 0
		set(h_a, 'YGrid', 'on')
		set(h_a, 'YMinorGrid', 'off')
	else
		set(h_a, 'YGrid', 'off')
		set(h_a, 'YMinorGrid', 'off')
	end
	% z-axis
	if numel(regexp(r_grid, 'Z')) > 0
		set(h_a, 'ZGrid', 'on')
		set(h_a, 'ZMinorGrid', 'on')
	elseif numel(regexp(r_grid, 'z')) > 0
		set(h_a, 'ZGrid', 'on')
		set(h_a, 'ZMinorGrid', 'off')
	else
		set(h_a, 'ZGrid', 'off')
		set(h_a, 'ZMinorGrid', 'off')
	end
else
	% Bad input
	error('set_plot:GridOption', ['Grid must be either ''on'',', ...
		'''off'', ''all'', ''none'', ''major'',\n''smart'', ', ...
		'or a combination of ''X'', ''Y'', ''Z'', '...
		'''x'', ''y'', and ''z''.']);
end

% Get the grid style.
[s_grid, options] = cut_option(options, 'GridStyle', s_grid);
% Check for 'current'.
if ~strcmpi(s_grid, 'current')
	% Apply.
	set(h_a, 'GridLineStyle', s_grid)
end


%% --- Colorbar formatting ---

% Check if the colorbar is present.
if q_cbar
	
	% Get the box option.
	[cbar_box, options] = cut_option(options, 'ColorBarBox', cbar_box);
	% Check for 'current'.
	if ~strcmpi(cbar_box, 'current')
		% Apply.
		set(h_cbar, 'Box', cbar_box);
	end
	
	% Get the tick direction option.
	[cbar_d_tick, options] = cut_option(options, ...
		'ColorBarTickDir', cbar_d_tick);
	% Check for 'current'.
	if ~strcmpi(cbar_d_tick, 'current')
		% Apply.
		set(h_cbar, 'TickDir', cbar_d_tick);
	end
	
	% Get the minor tick option.
	[cbar_m_tick, options] = cut_option(options, ...
		'ColorBarMinorTick', cbar_m_tick);
	% Check for 'current'.
	if ~strcmpi(cbar_m_tick, 'current')
		% Figure out which ticks are on.
		if strcmpi(get(h_cbar, 'XTick'), 'on')
			% Apply the minor tick option.
			set(h_cbar, 'XMinorTick', cbar_m_tick);
		else
			% Apply the minor tick option.
			set(h_cbar, 'YMinorTick', cbar_m_tick);
		end
	end
	
	% Get the colorbar grid option.
	[q_g_cbar, options] = cut_option(options, ...
		'ColorBarGrid', q_g_cbar);
	% Check for 'current'.
	if ~strcmpi(q_g_cbar, 'current')
		% Figure out which ticks are on.
		if strcmpi(get(h_cbar, 'XTick'), 'on')
			% Apply the minor tick option.
			set(h_cbar, 'XGrid', q_g_cbar);
		else
			% Apply the minor tick option.
			set(h_cbar, 'YGrid', q_g_cbar);
		end
	end
	
	% Get the gridline style option.
	[s_g_cbar, options] = cut_option(options, ...
		'ColorBarGridLineStyle', s_g_cbar);
	% Check for 'current'.
	if ~strcmpi(s_g_cbar, 'current')
		% Apply
		set(h_cbar, 'GridLineStyle', s_g_cbar);
	end
	
	% Apply tick length.
	if ~strcmpi(l_tick, 'current')
		set(h_cbar, 'TickLength', 2*l_tick);
	end
end


%% --- Colorbar margins ---

% Check if the colorbar is present.
if q_cbar
	% Change the units.
	set(h_cbar, 'Units', units)
	% Get the dimensions.
	pos_cbar = get(h_cbar, 'Position');
	m_cbar   = get(h_cbar, 'TightInset');
	% Check the location of the color bar.
	s_cbar = get(h_cbar, 'Location');
	% Process 'manual' locations.
	if strcmpi(s_cbar, 'manual')
		% Set change parameter to 'true'.
		q_m_cbar = true;
		if pos_cbar(1) + pos_cbar(3) > pos_axes(1) + pos_axes(3)
			% Outside on the right
			s_cbar = 'EastOutside';
		elseif pos_cbar(2) + pos_cbar(4) > pos_axes(2) + pos_axes(4)
			% Outside on the top
			s_cbar = 'NorthOutside';
		elseif pos_cbar(1) < pos_axes(1)
			% Outside on the left
			s_cbar = 'WestOutside';
		elseif pos_cbar(2) < pos_axes(2)
			% Outside on the bottom
			s_cbar = 'SouthOutside';
		else
			% Don't move the colorbar.
			q_m_cbar = false;
		end
		% Test if the colorbar should be reset.
		if q_m_cbar
			% Reset the position.
			set(h_cbar, 'Location', s_cbar);
			% Reobtain the dimensions.
			pos_cbar = get(h_cbar, 'Position');
			m_cbar   = get(h_cbar, 'TightInset');
		end
	end
	
	% Get the option for the width of the colorbar.
	[w_cbar, options] = cut_option(options, 'ColorBarWidth', w_cbar);
	% Check for 'current'.
	if ~strcmpi(w_cbar, 'current')
		% Check if a width or height is needed.
		if pos_cbar(3) > pos_cbar(4)
			% Height
			pos_cbar(4) = w_cbar;
		else
			% Width
			pos_cbar(3) = w_cbar;
		end
		
	end
	
	% Set the size of the gap between the axes and the colorbar.
	[m_gap, options] = cut_option(options, 'ColorBarGap', m_gap);
	
end


%% --- Margin alteration ---

% Determine the margin style.
[m_style, options] = cut_option(options, 'MarginStyle', m_style);
% Process style choice.
q_tight = strcmpi(m_style, 'tight');
q_loose = strcmpi(m_style, 'loose');

% Get aspect ratio.
[ar_fig, options] = cut_option(options, 'AspectRatio', ar_fig);
% Convert 'auto' option.
if strcmpi(ar_fig, 'auto') || strcmpi(ar_fig, 'automatic') || ...
		strcmpi(ar_fig, 'current')
	ar_fig = pos_fig(4) / pos_fig(3);
end

% Width of figure
[w_fig, options] = cut_option(options, 'Width', w_fig);
% Convert 'auto' option.
if strcmpi(w_fig, 'auto') || strcmpi(w_fig, 'automatic') || ...
		strcmpi(w_fig, 'current')
	w_fig = pos_fig(3);
end

% Manual extra margins
[m_cur, options] = cut_option(options, 'Margin', m_opts);
% Check for a vector.
if ~isnumeric(m_cur)
	error('set_plot:BadMargin', 'Margin must be a numeric vector.');
end
% Convert to row vector.
m_cur = m_cur(:)';
% Append or cut if necessary.
switch numel(m_cur)
	case 0
	case 1
		m_opts = m_cur * ones(1,4);
	case 2
		m_opts = [m_cur, m_cur];
	case 3
		m_opts = [m_cur, m_cur(2)];
	otherwise
		m_opts = m_cur(1:4);
end


% Height of figure
h_fig  = ar_fig * w_fig;

% Squeeze the axes if applicable.
if q_tight
	% Squeeze the margins to zero.
	% Set the paper size.
	set(h_f, 'PaperSize', [w_fig, h_fig]);
	% This should have no effect.
	set(h_f, 'PaperPosition', [0, 0, w_fig, h_fig]);
	
	% Fix the size of the figure.
	pos_fig(3:4) = [w_fig, h_fig];
	% Set the figure window size.
	set(h_f, 'Position', pos_fig);
	
		% Get the minimum size of the margins.
	m_axes  = get(h_a, 'TightInset');
	m_tight = m_axes;
	
	% Make room for the colorbar.
	if q_cbar
		% Figure out which side the colorbar is on.
		switch s_cbar
			case 'EastOutside'
				% Right-hand side
				m_tight(2) = max(m_axes(2), m_cbar(2));
				m_tight(4) = max(m_axes(4), m_cbar(4));
				m_tight(3) = m_axes(3) + m_cbar(1) + ...
					pos_cbar(3) + m_cbar(3) + m_gap;
			case 'NorthOutside'
				% Top location
				m_tight(1) = max(m_axes(1), m_cbar(1));
				m_tight(3) = max(m_axes(3), m_cbar(3));
				m_tight(4) = m_axes(4) + m_cbar(2) + ...
					pos_cbar(4) + m_cbar(4) + m_gap;
			case 'WestOutside'
				% Left-hand side
				m_tight(2) = max(m_axes(2), m_cbar(2));
				m_tight(4) = max(m_axes(4), m_cbar(4));
				m_tight(1) = m_axes(1) + m_cbar(1) + ...
					pos_cbar(3) + m_cbar(3) + m_gap;
			case 'SouthOutside'
				% Top location
				m_tight(1) = max(m_axes(1), m_cbar(1));
				m_tight(3) = max(m_axes(3), m_cbar(3));
				m_tight(2) = m_axes(2) + m_cbar(2) + ...
					pos_cbar(4) + m_cbar(4) + m_gap;
		end
	end
	
	% Add in extra margins.
	m_tight = m_opts + m_tight;
	
	% Fix the axes.
	pos_axes(1) = m_tight(1);
	pos_axes(2) = m_tight(2);
	pos_axes(3) = w_fig - m_tight(1) - m_tight(3);
	pos_axes(4) = h_fig - m_tight(2) - m_tight(4);
	% Set them.
	set(h_a, 'Position', pos_axes);
	
	% Match the colorbar to the axes.
	if q_cbar
		% Figure out which side the colorbar is on.
		switch s_cbar
			case 'EastOutside'
				% Move the colorbar to the right margin.
				pos_cbar(1) = pos_axes(1) + pos_axes(3) + ...
					m_axes(3) + m_gap + m_cbar(1);
				% Match the top and bottom of the colorbar to the axes.
				pos_cbar(2) = pos_axes(2);
				pos_cbar(4) = pos_axes(4);
			case 'NorthOutside'
				% Move the colorbar to the top margin.
				pos_cbar(2) = pos_axes(2) + pos_axes(4) + ...
					m_axes(4) + m_gap + m_cbar(2);
				% Match the left and right of the colorbar to the axes.
				pos_cbar(1) = pos_axes(1);
				pos_cbar(3) = pos_axes(3);
			case 'WestOutside'
				% Move the colorbar to the left margin.
				pos_cbar(1) = m_cbar(1);
				% Match the top and bottom of the colorbar to the axes.
				pos_cbar(2) = pos_axes(2);
				pos_cbar(4) = pos_axes(4);
			case 'SouthOutside'
				% Move the colorbar to the top margin.
				pos_cbar(2) = m_cbar(2);
				% Match the left and right of the colorbar to the axes.
				pos_cbar(1) = pos_axes(1);
				pos_cbar(3) = pos_axes(3);
		end
		% Set the new position.
		set(h_cbar, 'Position', pos_cbar);
	end
	
	
elseif q_loose
	% Use the looser margins.
	% Set the paper size.
	set(h_f, 'PaperSize', [w_fig, h_fig]);
	% This should have no effect.
	set(h_f, 'PaperPosition', [0, 0, w_fig, h_fig]);
	
	% Fix the size of the figure.
	pos_fig(3:4) = [w_fig, h_fig];
	% Set the figure window size.
	set(h_f, 'Position', pos_fig);
	
	% Set the size of the margins.
	set(h_a, 'OuterPosition', [0, 0, w_fig, h_fig]);
	
end

% Get interpreter option
[i_style, options] = cut_option(options, 'Interpreter', i_style);
% Check for how to handle interpreters for labels.
if strcmpi(i_style, 'auto') || strcmpi(i_style, 'automatic')
	% Check for a pair of \$ characters in each label.
	% x-axis
	if numel(regexp(get(h_x, 'String'), '\$')) > 1
		% At least one equation region
		set(h_x, 'Interpreter', 'latex');
	else
		% No equation regions
		set(h_x, 'Interpreter', 'tex');
	end
	% y-axis
	if numel(regexp(get(h_y, 'String'), '\$')) > 1
		% At least one equation region
		set(h_y, 'Interpreter', 'latex');
	else
		% No equation regions
		set(h_y, 'Interpreter', 'tex');
	end
	% z-axis
	if numel(regexp(get(h_z, 'String'), '\$')) > 1
		% At least one equation region
		set(h_z, 'Interpreter', 'latex');
	else
		% No equation regions
		set(h_z, 'Interpreter', 'tex');
	end
	
elseif strcmpi(i_style, 'latex')
	% Set all interpreters to 'latex'.
	set(h_x, 'Interpreter', 'latex');
	set(h_y, 'Interpreter', 'latex');
	set(h_z, 'Interpreter', 'latex');
	
elseif strcmpi(i_style, 'tex')
	% Set all interpreters to 'latex'.
	set(h_x, 'Interpreter', 'tex');
	set(h_y, 'Interpreter', 'tex');
	set(h_z, 'Interpreter', 'tex');
	
elseif strcmpi(i_style, 'none')
	% Set all interpreters to 'latex'.
	set(h_x, 'Interpreter', 'none');
	set(h_y, 'Interpreter', 'none');
	set(h_z, 'Interpreter', 'none');
	
elseif strcmpi(i_style, 'current')
	% Reset the interpreters to their original values.
	set(h_x, 'Interpreter', i_x);
	set(h_y, 'Interpreter', i_y);
	set(h_z, 'Interpreter', i_z);
	
else
	% Bad input
	error('set_plot:Interpreter', ['Interpreter must be either ', ...
		'''auto'', ''automatic'', ''current'', ''tex'',\n', ...
		'''latex'', ''none'', or ''smart''.']);
end


%% --- Font type application ---

% Get font name.
[f_name, options] = cut_option(options, 'FontName', f_name);
% Check for 'current'.
if strcmpi(f_name, 'current')
	% Apply old fonts.
	for i = 1:numel(h_font)
		set(h_font(i), 'FontName', f_cur{i});
	end
else
	% Apply changes.
	set(h_font, 'FontName', f_name);
end


%% --- Output ---

% Check for leftover options
if ~isempty(fieldnames(options))
	% Something was not used.
	warning('set_plot:ExtraOptions', ...
		'Some of the input options were not used.');
	% Output the remaining options.
	fprintf('\nRemaining options:\n');
	disp(options)
end

% Check for an output.
if nargout > 0
	% Collect all the labels into a struct.
	% Always-present handles
	h = struct( ...
		'figure', h_f, ...
		'axes'  , h_a, ...
		'label' , struct('x', h_x, 'y', h_y, 'z', h_z), ...
		'title' , h_title, ...
		'text'  , h_text, ...
		'line'  , h_line);
			
	% Check for a contour plot.
	if numel(h_contour) > 0
		h.contour = struct( ...
			'contour', h_contour, ...
			'line'   , h_c_line, ...
			'text'   , h_c_text);
	end
	
	% Check for a colorbar.
	if q_cbar
		h.colorbar = h_cbar;
	end
end


% --- SUBFUNCTION 1: Get option and delete it ---
function [val, options] = cut_option(options, name, default)
%
% [val, options] = cut_option(options, name, default)
%
% INPUTS:
%         options : struct of options
%         name    : name of option to retrieve
%         default : (optional) default value, [] if not specified
%
% OUTPUTS:
%         val     : option value
%         options : input struct with (name) field removed
%
% This function is intended to extract an option from a struct called
% options.  In most circumstances calling this function will be equivalent
% to
%
%         val = options.name
%
% unless the struct options does not have a field that matches name.  In
% that case the function will return
%
%         val = default
%
% if the 'default' argument is specified and
%
%         val = []
%
% otherwise.  If there are two outputs, the second output will be the input
% struct 'options', only with the relevant field removed if it was present
% in the input.  This enables the user to determine which options have been
% used and which have not.
%

% VERSIONS:
%  2010/03/23: Derek Dalle     : First version
%  2010/09/07: Derek Dalle     : Optional second output
%  2010/11/01: Derek Dalle     : Derived from get_option
%
% Public Domain

% Check for sufficient inputs.
if nargin < 2
   error('cut_option:NotEnoughInputs', 'Not enough input arguments.');
end
% Set default value if necessary
if nargin < 3
   default = [];
end

% Get the value, and update the struct if the default is used.
% Check type of options.
if isempty(options)
	% Quit and return default if options is empty.
	val = default;
elseif ~isa(options, 'struct')
	% Otherwise options must be a struct.
	error('cut_option:Arg1NotStruct',...
		'First argument must be an options structure.');
elseif isfield(options, name)
	% Options has field name as expected.
	val = options.(name);
	% Remove the field if there are two outputs.
	if nargout > 1
		options = rmfield(options, name);
	end
else
	% Return default value.
	val = default;
end


% --- SUBFUNCTION 2: Set the colormap ---
function set_colormap(varargin)
% 
% set_colormap(colorString)
% set_colormap(colorCell)
% set_colormap(colorMap)
% set_colormap(colorName1, colorName2, ...)
% set_colormap(colorVal1, colorName1, ...)
% set_colormap(colorVals, colorName1, ...)
% set_colormap(h_f, ...)
% cmap = set_colormap(...)
%
% INPUTS:
%         h_f         : figure handle (default is gcf)
%         colorString : name of custom or built-in colormap (notes 1-3)
%         colorCell   : cell array of colors or colors and values (note 7)
%         colorMap    : Nx3 or Nx4 matrix (note 4)
%         colorName1  : RGB color or HTML color (note 5)
%         colorVal1   : scalar for interpolation (note 6)
%         colorVals   : list of scalars for interpolation (note 6)
% 
% OUTPUTS:
%         cmap : the Nx3 colormap used
%
% This function edits a colormap with dramatically more options than the
% built-in colormap function.  In addition to the built-in colormaps, this
% function recognizes eight monochromatic that are based on the primary and
% secondary colors and black and white.  Thus the following example will
% produce a colormap going from White to Blue to DarkBlue.
%
%     set_colormap blue
%
% There is also the option to reverse any colormap by using a prefix.
%
%     set_colormap reverse-blue
%     set_colormap reverse-jet
%
% The user can also use a pre-defined colormap using the following command.
%
%     set_colormap(cmap)
%
% Here cmap is an Nx3 or Nx4 matrix of RGB colors.  Finally, this function
% provides several ways to construct a colormap manually.  The following
% example shows how to construct a map that goes through a certain range of
% colors based on common names.
%
%     set_colormap('Navy', 'Blue', 'White')
%
% The user may also change the values to which each color corresponds.
%
%     set_colormap(0, 'Navy', 0.2, 'Blue', 1, 'White')
%
% The function will recognize any of the typical web browser color names.
%
% NOTES:
%       (1) The built-in colormaps can be viewed by looking at "colormap"
%           the Matlab help browser.  They are autumn, bone, colorcube,
%           cool, copper, flag, gray, hot, hsv, jet, lines, pink, prism,
%           spring, summer, white, and winter.
%
%       (2) The custom colormaps defined here are black, blue, cyan, green,
%           magenta, red, white, and yellow.  They can also be aliased
%           using the single-character abbreviations k, b, c, g, m, r, w,
%           and y, respectively.
%
%       (3) Any of the string colormaps can be reversed by prepending the
%           string with 'reverse-', for example, reverse-jet and reverse-b.
%
%       (4) The colormap can also be described using a matrix.  This matrix
%           can be an Nx3 matrix, which is the typical format for Matlab
%           colormaps.  In this case each row refers to a red,green,blue
%           color.  The matrix can also be an Nx4 matrix, in which case the
%           first column gives a value to associate with each color.
%
%       (5) Colors listed individually can be either an RGB color, which is
%           a 1x3 double, or an HTML color, which is a string containing
%           the name of a common color.  A full list can be found at
%           <http://www.w3schools.com/html/html_colornames.asp>.
%
%       (6) The colormap associates a color for each number in the range of
%           0 to 1.  By default, the colors are spaced out equally, but
%           this may not always be what the user wants.  The values can be
%           given alternating with the colors or a list of interpolation
%           values followed by a list of colors.
%
%       (7) A cell array can also be used.  The cell array consists of
%           either a list of colors or a column of values and a column of
%           colors or a row of values and a row of colors.
%

% Versions:
%  2010/11/04 @Derek Dalle    : Branched from set_plot
%  2010/11/05 @Derek Dalle    : First version
%
% Public domain

% Number of varargs
n_arg = length(varargin);
% Set index of current input.
i_arg = 1;
% Check first input.
if n_arg > 0 && isnumeric(varargin{1})
	% First input is figure handle.
	h_f = varargin{1};
	% Move to next argument.
	i_arg = 2;
else
	% Just use gcf.
	h_f = gcf;
end

% Check the number of remaining arguments.
if n_arg < i_arg
	% Not enough inputs
	error('set_colormap:NotEnoughInputs', 'No colormap input.');
elseif n_arg - i_arg > 1
	% Get the first argument.
	s_cmap = varargin(i_arg:n_arg);
else
	% Only one value.
	s_cmap = varargin{i_arg};
end

% Don't reverse the colormap by default.
q_cmap_reverse = false;

% Check for a simple string input.
if ischar(s_cmap)
	% Check if string begins with 'reverse-'.
	if numel(s_cmap) > 7 && strcmpi(s_cmap(1:8), 'reverse-')
		% Drop the first few characters.
		s_cmap = s_cmap(9:end);
		% Store parameter to reverse the colormap.
		q_cmap_reverse = true;
	end
	
	% Try to use a custom colormap.
	q_cmap_custom = true;
	% Look for the eight custom colormaps.
	if strcmpi(s_cmap, 'b') || strcmpi(s_cmap, 'blue')
		% White - Blue - DarkBlue map
		s_cmap = {'White', 'Blue', 'DarkBlue'};
	elseif strcmpi(s_cmap, 'r') || strcmpi(s_cmap, 'red')
		% White - Red - Black map
		s_cmap = {'White', 'Red', 'Black'};
	elseif strcmpi(s_cmap, 'g') || strcmpi(s_cmap, 'green')
		% White - Green - Black map
		s_cmap = {'White', 'Lime', 'Black'};
	elseif strcmpi(s_cmap, 'y') || strcmpi(s_cmap, 'yellow')
		% White - Yellow - Gold map
		s_cmap = {'White', 'Yellow', 'Gold'};
	elseif strcmpi(s_cmap, 'm') || strcmpi(s_cmap, 'magenta')
		% White - Magenta - DarkMagenta map
		s_cmap = {'White', 'Magenta', 'DarkMagenta'};
	elseif strcmpi(s_cmap, 'c') || strcmpi(s_cmap, 'cyan')
		% White - Cyan - Blue map
		s_cmap = {'White', 'Cyan', 'Blue'};
	elseif strcmpi(s_cmap, 'w')
		% White - LightGrey - Grey map
		s_cmap = {'White', 'LightGray', 'Gray'};
	elseif strcmpi(s_cmap, 'k') || strcmpi(s_cmap, 'black')
		% LightGrey - DarkGray - Black map
		s_cmap = {'LightGray', 'DarkGray', 'Black'};
	else
		% No custom map found.
		q_cmap_custom = false;
		% Find the current axes
		h_a = get(h_f, 'CurrentAxes');
		% Try to apply the built-in colormap.
		colormap(h_a, s_cmap);
	end
end



% Check the type of the variable.
if isnumeric(s_cmap)
	% Number of rows in matrix
	size_cmap = size(s_cmap);
	% Check if the matrix has the right number of columns.
	if numel(size_cmap) ~= 2
		% Bad input
		error('set_colormap:ColorMap', ['ColorMap must be a ', ...
			'cell array, recognized string, or an Nx3 matrix.']);
	elseif size_cmap(2) == 3
		% Check if only one color is given.
		if size(s_cmap, 1) == 1
			% Interpolate from black.
			v_cmap = interp1([0, 1], s_cmap, linspace(0, 1, 64));
		elseif size(s_cmap, 1) < 32
			% Equal intervals from 0 to 1
			i_cmap = linspace(0, 1, size_cmap(1));
			% Interpolate the colors.
			v_cmap = interp1(i_cmap, s_cmap, linspace(0, 1, 64));
		end
	elseif size(c_style, 2) == 4
		% Interpolate based on the first column.
		i_cmap = s_cmap(:,1);
		v_cmap = s_cmap(:,2:4);
		% Prepend the map if necessary.
		if abs(i_cmap(1)) > 1e-8
			% Get the prepend color.
			v_1_cmap = v_cmap(:,1) >= 0.5;
			% Prepend.
			i_cmap = [0; i_cmap];
			v_cmap = [v_1_cmap; v_cmap];
		end
		% Append the map if necessary.
		if abs(i_cmap(end) - 1) > 1e-8
			% Get the append color.
			v_1_cmap = v_cmap(:,end) >= 0.5;
			% Append.
			i_cmap = [i_cmap; 1];
			v_cmap = [v_cmap; v_1_cmap];
		end
		% Interpolate the colors.
		v_cmap = interp1(i_cmap, v_cmap, linspace(0, 1, 64));
	else
		% Bad input
		error('set_colormap:ColorMap', ['ColorMap must be a ', ...
			'cell array, recognized string,, cell array, or an Nx3 matrix.']);
	end
	
	% Apply the new color map.
	set(h_f, 'ColorMap', v_cmap)

elseif iscell(s_cmap)
	% Dimensions of cell array.
	s_cell = size(s_cmap);
	% Determine the type 
	if isempty(s_cmap) || numel(s_cell) ~= 2
		% Bad input
		error('set_colormap:BadCell', ['Cell array colormap ', ...
			'must be either one- or two-dimensional.']);
	elseif min(s_cell) == 1
		% One-dimensional cell array
		% First element
		s_1 = s_cmap{1};
		% Check the first element.
		if isnumeric(s_1)
			% If it's a 1x3 vector, it's a color.
			if all(size(s_1) == [1 3])
				% List of colors
				c_cmap = s_cmap;
				% Regular interpolation
				i_cmap = linspace(0, 1, numel(c_cmap));
			elseif numel(s_1) == numel(s_cmap) - 1
				% List of colors
				c_cmap = s_cmap(2:end);
				% Manual interpolation
				i_cmap = s_1;
			elseif numel(s_1) == 1
				% Alternating interpolation values and colors
				% List of colors
				c_cmap = s_cmap(2:2:end);
				% Manual interpolation
				i_cmap = [ s_cmap{1:2:end} ];
			else
				% Bad input
				error('set_colormap:BadColorList', ['First element ', ...
					'of cell array must be a color or list of ', ...
					'interpolation values.']);
			end
		else
			% List of colors
			c_cmap = s_cmap;
			% Regular interpolation
			i_cmap = linspace(0, 1, numel(c_cmap));
		end
	elseif min(s_cell) > 2
		% Too large of color array.
		error('set_colormap:BadCell2', ['Two-dimensional cell ', ...
			'array must be Nx2 or 2xN.']);
	else
		% Two-dimensional cell array
		% Three critical elements
		s_11 = s_cmap{1,1};
		s_12 = s_cmap{1,2};
		s_21 = s_cmap{2,1};
		% Test if each is a scalar.
		q_11 = isnumeric(s_11) && numel(s_11) == 1;
		q_12 = isnumeric(s_12) && numel(s_12) == 1;
		q_21 = isnumeric(s_21) && numel(s_21) == 1;
		% Test these to find the interpolation values.
		if q_11 && q_12
			% Top row
			% List of colors
			c_cmap = s_cmap(2,:);
			% Manual interpolation
			i_cmap = [ s_cmap{1,:} ];
		elseif q_11 && q_21
			% Left column
			% List of colors
			c_cmap = s_cmap(:,2);
			% Manual interpolation
			i_cmap = [ s_cmap{:,1} ];
		elseif q_12
			% Bottom row
			% List of colors
			c_cmap = s_cmap(1,:);
			% Manual interpolation
			i_cmap = [ s_cmap{2,:} ];
		elseif q_21
			% Right column
			% List of colors
			c_cmap = s_cmap(:,1);
			% Manual interpolation
			i_cmap = [ s_cmap{:,1} ];
		else
			error('set_colormap:BadCell2', ['One of the rows or ', ...
				'columns must consist entirely of scalars.']);
		end
	end
	
	% Initialize rgb colors
	v_cmap = zeros(numel(c_cmap), 3);
	% Convert each color into a rgb color.
	for i = 1:numel(c_cmap)
		% Current color
		c_cur = c_cmap{i};
		% Check if it already is an rgb color.
		if isnumeric(c_cur)
			% Check if it has the right size
			if numel(c_cur) == 3
				% Store it.
				v_cmap(i,:) = c_cur(:)';
			else
				% Bad color
				error('set_colormap:BadColor', ['Each color must be ', ...
					'either a built-in color string, an HTML color name, ', ...
					'or a three-element vector.']);
			end
		elseif ischar(c_cur)
			% Check for a conversion.
			v_cur = html2rgb(c_cur);
			% Check for success.
			if any(isnan(v_cur))
				% Bad color
				error('set_colormap:NoColor', ['Color named %s ', ...
					'was not recognized.'], c_cur);
			else
				% Store the color.
				v_cmap(i,:) = v_cur;
			end
		else
			% Bad color
			error('set_colormap:BadColor', ['Each color must be ', ...
				'either a built-in color string, an HTML color name, ', ...
				'or a three-element vector.']);
		end
	end
	
	% Expand the colormap.
	v_cmap = interp1(i_cmap, v_cmap, linspace(0, 1, 64));
	% Apply it.
	set(h_f, 'ColorMap', v_cmap);
	
elseif ischar(s_cmap) && ~q_cmap_custom
	% Do nothing.
	
else
	% Bad input
	error('set_colormap:ColorMap', ['ColorMap must be a ', ...
		'cell array, recognized string, or an Nx3 matrix.']);
	
end
	
% Check if the colormap should be reversed.
if q_cmap_reverse
	% Get the current colormap.
	v_cmap = get(h_f, 'ColorMap');
	% Apply the reversed version.
	set(h_f, 'ColorMap', flipud(v_cmap));
end


% --- SUBFUNCTION 3: Convert HTML color string to RGB color triple ---
function v_rgb = html2rgb(s_html)
%
% v_rgb = html2rgb(s_html)
%
% INPUTS:
%         s_html : name of an HTML color (string)
%
% OUTPUTS:
%         v_rgb  : 1x3 vector corresponding to red, green, and blue
%
% This function converts an HTML color name to a RGB color.  If the input
% is not recognized, the returned color is nan(1,3).
%

% Versions:
%  2010/11/04 @Derek Dalle    : First version
%
% Public domain

% Check for sufficient inputs.
if nargin < 1
	error('html2rgb:NotEnoughInputs', 'Not enough inputs');
end

% Check that the input is a string.
if ~ischar(s_html)
	error('html2rgb:NotString', 'Input must be a string.');
end

% Color table
s_colors = {
	'AliceBlue',             [240, 248, 255];
	'AntiqueWhite',          [250, 235, 215];
	'Aqua',                  [  0, 255, 255];
	'Aquamarine',            [127, 255, 212];
	'Azure',                 [240, 255, 255];
	'B',                     [  0,   0, 255];
	'Beige',                 [245, 245, 220];
	'Bisque',                [255, 228, 196];
	'Black',                 [  0,   0,   0];
	'BlanchedAlmond',        [255, 235, 205];
	'Blue',                  [  0,   0, 255];
	'BlueViolet'             [138,  43, 226];
	'Brown',                 [165,  42,  42];
	'BurlyWood',             [222, 184, 135];
	'C',                     [  0, 255, 255];
	'CadetBlue',             [ 95, 158, 160];
	'Chartreuse',            [127, 255,   0];
	'Chocolate',             [210, 105,  30];
	'Coral',                 [255, 127,  80];
	'CornflowerBlue',        [100, 149, 237];
	'Cornsilk',              [255, 248, 220];
	'Crimson',               [220,  20,  60];
	'Cyan',                  [  0, 255, 255];
	'DarkBlue',              [  0,   0, 139];
	'DarkCyan',              [  0, 139, 139];
	'DarkGoldenRod',         [184, 134,  11];
	'DarkGray',              [169, 169, 169];
	'DarkGrey',              [169, 169, 169];
	'DarkGreen',             [  0, 100,   0];
	'DarkKhaki',             [189, 183, 107];
	'DarkMagenta',           [139,   0, 139];
	'DarkOliveGreen',        [ 85, 107,  47];
	'DarkOrange',            [  0, 100,   0];
	'DarkOrchid',            [153,  50, 204];
	'DarkRed',               [139,   0,   0];
	'DarkSalmon',            [233, 150, 122];
	'DarkSeaGreen',          [143, 188, 143];
	'DarkSlateBlue',         [ 72,  61, 139];
	'DarkSlateGray',         [ 47,  79,  79];
	'DarkTurquoise',         [  0, 206, 209];
	'DarkViolet',            [148,   0, 211];
	'DeepPink',              [255,  20, 147];
	'DeepSkyBlue',           [  0, 191, 255];
	'DimGray',               [105, 105, 105];
	'DodgerBlue',            [ 30, 144, 255];
	'FireBrick',             [178,  34,  34];
	'FloralWhite',           [255, 250, 240];
	'ForestGreen',           [ 34, 139,  34];
	'Fuchsia',               [255,   0, 255];
	'G',                     [  0, 128,   0];
	'Gainsboro',             [220, 220, 220];
	'GhostWhite',            [248, 248, 255];
	'Gold',                  [255, 215,   0];
	'GoldenRod',             [218, 165,  32];
	'Gray',                  [128, 128, 128];
	'Grey',                  [128, 128, 128];
	'Green',                 [  0, 128,   0];
	'GreenYellow',           [173, 255,  47];
	'HoneyDew',              [240, 255, 240];
	'HotPink',               [255, 105, 180];
	'IndianRed',             [205,  92,  92];
	'Indigo',                [ 75,   0, 130];
	'Ivory',                 [255, 255, 240];
	'K',                     [  0,   0,   0];
	'Khaki',                 [240, 230, 140];
	'Lavender',              [230, 230, 250];
	'LavenderBlush',         [255, 240, 245];
	'LawnGreen',             [124, 252,   0];
	'LemonChiffon',          [255, 250, 205];
	'LightBlue',             [173, 216, 230];
	'LightCoral',            [240, 128, 128];
	'LightCyan',             [224, 255, 255];
	'LightGoldenRodYellow',  [250, 250, 210];
	'LightGray',             [211, 211, 211];
	'LightGrey',             [211, 211, 211];
	'LightGreen',            [144, 238, 144];
	'LightPink',             [255, 182, 193];
	'LightSalmon',           [255, 160, 122];
	'LightSeaGreen',         [ 32, 178, 170];
	'LightSkyBlue',          [135, 206, 250];
	'LightSlateGray',        [119, 136, 153];
	'LightSteelBlue',        [176, 196, 222];
	'LightYellow',           [255, 255, 224];
	'Lime',                  [  0, 255,   0];
	'LimeGreen',             [ 50, 205,  50];
	'Linen',                 [250, 240, 240];
	'M',                     [255,   0, 255];
	'Magenta',               [255,   0, 255];
	'Maroon',                [128,   0,   0];
	'MediumAquaMarine',      [102, 205, 170];
	'MediumBlue',            [  0,   0, 170];
	'MediumOrchid',          [186,  85, 211];
	'MediumPurple',          [147, 112, 216];
	'MediumSeaGreen',        [ 60, 179, 113];
	'MediumSlateBlue',       [123, 104, 238];
	'MediumSpringGreen',     [  0, 250, 154];
	'MediumTurquoise',       [ 72, 209, 204];
	'MediumVioletRed',       [199,  21, 133];
	'MidnightBlue',          [ 25,  25, 112];
	'MintCream',             [245, 255, 250];
	'MistyRose',             [255, 228, 225];
	'Moccasin',              [255, 228, 181];
	'NavajoWhite',           [255, 222, 173];
	'Navy',                  [  0,   0, 128];
	'OldLace',               [253, 245, 230];
	'Olive',                 [128, 128,   0];
	'OliveDrab',             [107, 142,  35];
	'Orange',                [255, 165,   0];
	'OrangeRed',             [255,  69,   0];
	'Orchid',                [218, 112, 214];
	'PaleGoldenRod',         [238, 232, 170];
	'PaleGreen',             [152, 251, 152];
	'PaleTurquoise',         [175, 238, 238];
	'PaleVioletRed',         [216, 112, 147];
	'PapayaWhip',            [255, 239, 213];
	'PeachPuff',             [255, 218, 185];
	'Peru',                  [205, 133,  63];
	'Pink',                  [255, 192, 204];
	'Plum',                  [221, 160, 221];
	'PowderBlue',            [172, 224, 230];
	'Purple',                [128,   0, 128];
	'R',                     [255,   0,   0];
	'Red',                   [255,   0,   0];
	'RosyBrown',             [188, 143, 188];
	'RoyalBlue',             [ 65, 105, 225];
	'SaddleBrown',           [139,  69,  19];
	'Salmon',                [250, 128, 114];
	'SandyBrown',            [244, 164,  96];
	'SeaGreen',              [ 46, 139,  87];
	'SeaShell',              [255, 245, 238];
	'Sienna',                [160,  82,  45];
	'Silver',                [192, 192, 192];
	'SkyBlue',               [135, 206, 235];
	'SlateBlue',             [106,  90, 205];
	'SlateGray',             [112, 128, 144];
	'Snow',                  [255, 250, 250];
	'SpringGreen',           [  0, 255, 127];
	'SteelBlue',             [ 70, 130, 180];
	'Tan',                   [210, 180, 140];
	'Teal',                  [  0, 128, 128];
	'Thistle',               [216, 191, 216];
	'Tomato',                [255,  99,  71];
	'Turquoise',             [ 64, 224, 208];
	'Violet',                [238, 130, 238];
	'W',                     [255, 255, 255];
	'Wheat',                 [245, 222, 179];
	'White',                 [255, 255, 255];
	'WhiteSmoke',            [245, 245, 245];
	'Y',                     [255, 255,   0];
	'Yellow',                [255, 255,   0];
	'YellowGreen',           [154, 205,  50];
	};

% Find the location of the string in the first column.
i_html = cell_position_string(s_colors(:,1), s_html);

% Check if a match was found.
if numel(i_html) == 1
	% Normalize colors into [0,1] range.
	v_rgb = s_colors{i_html,2} / 255;
else
	% No color was found.
	v_rgb = nan(1,3);
end


% --- SUBFUNCTION 4: Find the location of the matching string ---
function i=cell_position_string(S,str)
%
% i=position(S,x,tol)
%
% INPUTS:
%         S   : cell array of strings
%         str : targeted string
%
% OUTPUTS:
%         i   : indices of locations of str in S
%
% This function finds the location of entries in S that match the string
% str.  The function assumes S is a cell array of strings.
%

% Initialize output.
n_cell = numel(S);                              % number of strings in S
i      = zeros(1,n_cell);                       % maximum size of i
n_find = 0;                                     % number of matches

% Loop through S.
for j=1:n_cell
  % Check for match of jth cell with str
  if strcmpi(S{j},str) 
    % Increase number of finds.
    n_find    = n_find + 1;
    % Save index.
    i(n_find) = j;
  end
end

% Delete extra entries of i.
i = i(1:n_find);
