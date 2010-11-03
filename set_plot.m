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

% Versions:
%  2010/02/15 @Sean Torrez    : First version
%  2010/03/09 @Sean Torrez    : Modified to use fig handles only
%  2010/11/02 @Derek Dalle    : Chaned to set_plot
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
	m_opts  = zeros(1,4);
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
	c_style = 'current';
	
elseif q_fancy
	% Style containing even more marking
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = zeros(1,4);
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
	
elseif q_twocol
	% Complete style for two-column papers
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = zeros(1,4);
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
	
elseif q_onecol
	% Approach for figures in one-column papers
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = zeros(1,4);
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
	
elseif q_present
	% Style for presentation (with bigger fonts)
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = zeros(1,4);
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
	
elseif q_plain
	% Plain style
	% Default margin style
	m_style = 'loose';
	% Manual margins
	m_opts  = zeros(1,4);
	% Use current interpreters.
	i_style = 'current';
	% Default aspect ratio
	ar_fig  = 'auto';
	% Default width
	w_fig   = 'auto';
	% Font style
	f_style = 'sans-serif';
	% Axes style
	a_style = 'current';
	% Style for the colorbar
	cbar_style = 'plain';
	% Color theme style
	c_style = 'jet';
	
elseif q_current
	% Plain style
	% Default margin style
	m_style = 'tight';
	% Manual margins
	m_opts  = zeros(1,4);
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


%% --- Color scheme ---

% Get the approach for the color schemes
[c_style, options] = cut_option(options, 'ColorStyle', c_style);

% Process the minor options.
if strcmpi('ColorStyle', 'pretty')
	% Color map
	cmap = 'blue';
	
	
elseif strcmpi(c_style, 'jet')
	% Color map
	cmap = 'jet';
	
	
elseif strcmpi(c_style, 'gray') || strcmpi(c_style, 'grayscale')
	% Color map
	cmap = 'gray';
	
	
elseif strcmpi(c_style, 'current')
	% Color map
	cmap = 'current';
	
	
else
	% Bad input
	error('set_plot:ColorStyle', ['ColorStyle must be ''pretty'', ', ...
		'''gray'', ''jet'', or ''current''.']);
	
end


% Check the type of the variable
if isnumeric(cmap)
	% Check if the matrix has the right number of columns.
	if size(c_style, 2) == 3
		
	else
		% Bad input
		error('set_plot:ColorStyle', ['ColorStyle must be ''pretty''', ...
			'''grayscale'', ''blue'', ''current'', or an Nx3 matrix.']);
	end
	
elseif ischar(c_style)
	
	
else
	% Bad input
	error('set_plot:ColorStyle', ['ColorStyle must be ''pretty''', ...
		'''grayscale'', ''blue'', ''current'', or an Nx3 matrix.']);
	
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


%% --- Font size application ---

% Get handles relating to fonts.
h_font = [h_a, h_x, h_y, h_z];

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
		set(h_cbar, 'TickLength', l_tick);
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