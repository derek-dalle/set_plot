function set_plot(varargin)
%
% set_plot()
%
% INPUTS:
%
%
% OUTPUTS:
%
%
% OPTIONS:
%
%
%
%

%
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
options = [];

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


%% --- Styles and defaults ---
% Determine overall style of figure.
[s_cur, options] = cut_option(options, 'FigureStyle', 'plain');
% Process value
% This format is for a two-column journal.
q_journal = strcmpi(s_cur, 'journal');
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
	% Approach for interpreters
	i_style = 'auto';
	% Default aspect ratio
	ar_fig  = (sqrt(5) - 1) / 2;
	% Default width
	w_fig   = 'auto';
	% Font style
	f_style = 'pretty';
	% Axes style
	a_style = 'pretty';
	
elseif q_twocol
	% Complete style for two-column papers
	% Default margin style
	m_style = 'tight';
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
	
	
elseif q_onecol
	% Approach for figures in one-column papers
	% Default margin style
	m_style = 'tight';
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
	
elseif q_present
	% Style for presentation (with bigger fonts)
	% Default margin style
	m_style = 'tight';
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
	
elseif q_plain
	% Plain style
	% Default margin style
	m_style = 'tight';
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
	
elseif q_current
	% Plain style
	% Default margin style
	m_style = 'loose';
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
	
else
	% Bad input
	error('set_plot:BadStyle', ['FigureStyle must be either ', ...
		'''pretty'', ''plain'', ''present'', ''presentation'',\n', ...
		'''current'', ''journal'', ''twocol'', or ''onecol''.']);
	
end

% Get font style options.
[f_style, options] = cut_option(options, 'FontStyle', f_style);

% Set defaults related to font style.
if strcmpi(f_style, 'pretty')
	% Make all aspects of the written quantities look good.
	% Font name
	f_name = 'Times New Roman';
	% Font size
	f_size = 9;
	% Smaller font size ?
	
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
		'''serif'', or ''sans-serif''.']);
	
end

% get the axes style options.
[a_style, options] = cut_option(options, 'FontStyle', a_style);

% Set defaults related to axes style.
if strcmpi(a_style, 'pretty')
	% Shorter tick length
	l_tick = [0.05, 0.0125];
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
	l_tick = [0.05, 0.0125];
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
	
elseif strcmpi(a_style, 'fancy')
	% Shorter tick length
	l_tick = [0.05, 0.0125];
	% Tick direction
	d_tick = 'out';
	% Box
	s_box  = 'off';
	% Minor ticks
	s_tick = 'none';
	% Grid
	r_grid = 'major';
	% Grid style
	s_grid = ':';
	
elseif strcmpi(a_style, 'smart')
	% Shorter tick length
	l_tick = [0.05, 0.0125];
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
	r_grid = 'none';
	% Grid style
	s_grid = 'current';
	
else
	% Bad input
	error('set_plot:BadStyle', ['AxesStyle must be either ', ...
		'''pretty'', ''simple'', ''current'', ''fancy'', or ''smart''.']);
	
end
	

%% --- Options processing ---

% Determine the margin style.
[m_style, options] = cut_option(options, 'MarginStyle', m_style);
% Process style choice.
q_tight = strcmpi(m_style, 'tight');
q_loose = strcmpi(m_style, 'loose');



% Analysis part.




% Get aspect ratio.
[ar_fig, options] = cut_option(options, 'AspectRatio', ar_fig);
% Convert 'auto' option.
if strcmpi(ar_fig, 'auto') || strcmpi(ar_fig, 'automatic')
	ar_fig = pos_fig(4) / pos_fig(3);
end


% Width of figure
[w_fig, options] = cut_option(options, 'Width', w_fig);
% Convert 'auto' option.
if strcmpi(w_fig, 'auto') || strcmpi(w_fig, 'automatic')
	w_fig = pos_fig(3);
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
	
	% Get the size of the margins.
	m_tight = get(h_a, 'TightInset');
	
	% Fix the axes.
	pos_axes(1) = m_tight(1);
	pos_axes(2) = m_tight(2);
	pos_axes(3) = w_fig - m_tight(1) - m_tight(3);
	pos_axes(4) = h_fig - m_tight(2) - m_tight(4);
	% Set them.
	set(h_a, 'Position', pos_axes);
	
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

% Reset the interpreters to their original values.
set(h_x, 'Interpreter', i_x);
set(h_y, 'Interpreter', i_y);
set(h_z, 'Interpreter', i_z);




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