function h = set_plot(varargin)
%SET_PLOT  figure formatting help and automation
%
% CALL:
%    set_plot
%    set_plot(keyName, keyValue, ...)
%    set_plot(keys)
%    set_plot(h_f, ...)
%    h = set_plot(...)
%
% INPUTS:
%    h_f      : figure handle
%    keyName  : char, name of format key
%    keyValue : value of preceding key
%    keys     : struct containing options
%
% OUTPUTS:
%    h        : struct containing all handles used
%
% This function is used to specify several options simultaneously to a
% figure.  The most basic task performed by this function is to alter the
% paper size so that figures saved using SaveAs have the expected size
% without any cropping.
%
% The simple command
%
%     >> set_plot(h_f)
%
% will take a figure (with the handle `h_f`) and alter its size so that it
% can be properly saved to PDF without creating a full sheet of paper. The
% function does its other useful work using options.  
%
% The following command is perhaps the most useful one.  It changes all
% aspects of the figure to make it look fairly good without any extra work.
%
%     >> set_plot(h_f, 'FigureStyle', 'pretty')
%
% In addition to changing the formatting of the figure, the following
% command also changes the size of the figure so that it will fit in a
% two-column article.
%
%     >> set_plot(h_f, 'FigureStyle', 'twocol')
%
% The function utilizes a system of cascading options, meaning that the
% values of some of the options affect the default values of some other
% options.  It is possible to use these broad options like 'FigureStyle' or
% much more detailed options like 'FontSize'.
%
%     >> set_plot(h_f, 'FigureStyle', 'fancy', 'FontSize', 9.5)
%
% Options can also be specified using a struct, which is useful if the same
% options are going to be used for a series of figures.
%
%     >> keys = struct('FigureStyle', 'fancy', 'FontSize', 9.5);
%     >> set_plot(h_f, opts)
%
% A fill list of options and their possible values is shown below.  A chart
% of the cascading options and their affects on the detailed options is
% below that.
%
% FORMAT KEYS:
%    <strong>set_plot</strong> has many format keys.  For a full list, see <a href="matlab: help set_plot>help_keys">keys</a>.
%
% CASCADING STYLES:
%    <strong>set_plot</strong> has a system of cascading styles such that
%    some formatting options control other options unless more detailed
%    options are given.  The <a href="matlab: help set_plot>help_cascading_styles">cascading style chart</a> gives a full
%    list of the cascading styles.
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
%  2010-02-15 @smtorrez: First version
%  2010-03-09 @smtorrez: Modified to use fig handles only
%  2010-11-02 @dalle   : Changed to set_plot
%  2010-11-06 @dalle   : First version
%  2011-02-09 @dalle   : Added legend handling
%  2013-10-10 @dalle   : Feedback from users applied


%% --- Input processing ---

% List of empty subfunctions.
help_keys;
help_cascading_styles;

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
keys = struct();

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
        keys.(v_arg) = v_next;
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
            keys.(c_field) = v_arg.(c_field);
        end
    else
        % Bad input
        error('set_plot:InputType', ['Each optional input must be ', ...
            'either empty, a struct, or an option name/value pair.']);
        
    end
end


%% --- Units and handles ---
% Current units
[units, keys] = cut_key(keys, 'Units', 'inches');
% Unit conversion from inches to (units).
if strcmpi(units, 'inches')
    r_units = 1;
elseif strcmpi(units, 'centimeters')
    r_units = 2.54;
elseif strcmpi(units, 'points')
    r_units = 1/72;
end

% Axis handle
h_a = findall(h_f, 'Type', 'axes', 'Tag', '');
% Number of axes handles
n_a = numel(h_a);

% Set matching units.
set(h_f, 'Units'     , units);
set(h_f, 'PaperUnits', units);
set(h_a, 'Units'     , units);

% Axis labels
if n_a > 1
    % Multiple-axes plot
    h_x = cell2mat(get(h_a, 'XLabel'));
    h_y = cell2mat(get(h_a, 'YLabel'));
    h_z = cell2mat(get(h_a, 'ZLabel'));
else
    % Single-axis plot
    h_x = get(h_a, 'XLabel');
    h_y = get(h_a, 'YLabel');
    h_z = get(h_a, 'ZLabel');
end
% Get the intepreters for each label.
i_x = get(h_x, 'Interpreter');
i_y = get(h_y, 'Interpreter');
i_z = get(h_z, 'Interpreter');
% Set them to 'none' for sizing purposes.
set([h_x; h_y; h_z], 'Interpreter', 'none');

% Positions
pos_fig  = get(h_f, 'Position');
pos_axes = get(h_a, 'Position');


%% --- Overall style ---

% Determine overall style of figure.
[s_cur, keys] = cut_key(keys, 'FigureStyle', 'current');
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
q_f_color = strcmpi(s_cur, 'color'  );
q_f_plot  = strcmpi(s_cur, 'plot'   );

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
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'pretty';
    % Plot style
    l_style = 'simple';
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
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'pretty';
    % Plot style
    l_style = 'pretty';
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
    w_fig   = 3.1 * r_units;
    % Font style
    f_style = 'pretty';
    % Axes style
    a_style = 'pretty';
    % Style for the colorbar
    cbar_style = 'pretty';
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'gray';
    % Plot style
    l_style = 'current';
    % Contour style
    ctr_style = 'pretty';
    
elseif q_f_plot
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
    w_fig   = 3.1 * r_units;
    % Font style
    f_style = 'pretty';
    % Axes style
    a_style = 'pretty';
    % Style for the colorbar
    cbar_style = 'pretty';
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'current';
    % Plot style
    l_style = 'current';
    % Contour style
    ctr_style = 'pretty';
    
elseif q_f_color
    % Complete style for color two-column papers
    % Default margin style
    m_style = 'tight';
    % Manual margins
    m_opts  = 0.025 * ones(1,4);
    % Approach for interpreters
    i_style = 'auto';
    % Default aspect ratio
    ar_fig  = 0.75;
    % Default width
    w_fig   = 3.1 * r_units;
    % Font style
    f_style = 'pretty';
    % Axes style
    a_style = 'pretty';
    % Style for the colorbar
    cbar_style = 'pretty';
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'dark';
    % Plot style
    l_style = 'plain';
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
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'pretty';
    % Plot style
    l_style = 'current';
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
    % Style for the legend
    lgnd_style = 'pretty';
    % Color theme style
    c_style = 'pretty';
    % Plot style
    l_style = 'current';
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
    % Style for the legend
    lgnd_style = 'plain';
    % Color theme style
    c_style = 'plain';
    % Plot style
    l_style = 'plain';
    % Contour style
    ctr_style = 'plain';
    
elseif q_current
    % Plain style
    % Default margin style
    m_style = 'current';
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
    % Style for the legend
    lgnd_style = 'current';
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
        '''current'', ''journal'', ''fancy'', ''twocol'', ', ...
        '''color'', or ''onecol''.']);
    
end


%% --- Font style ---
% Get font style options.
[f_style, keys] = cut_key(keys, 'FontStyle', f_style);

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
    f_name = 'Helvetica';
    % Font size
    f_size = 10;
    
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
[a_style, keys] = cut_key(keys, 'AxesStyle', a_style);

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
    [cbar_style, keys] = cut_key(...
        keys, 'ColorBarStyle', cbar_style);
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


%% --- Legend style ---

% Determine whether or not there's a legend.
q_legend = false;
% Loop through them.
for i = 1:numel(h_child)
    % Test if it is a legend object.
    if strcmpi(get(h_child(i), 'Tag'), 'legend')
        % Store legend handle.
        h_legend = h_child(i);
        % Change value of test variable.
        q_legend = true;
        continue
    end
end

% Stats on the legend
if q_legend
    % Get ColorBarStyle option.
    [lgnd_style, keys] = cut_key(...
        keys, 'ColorBarStyle', lgnd_style);
    % Process ColorBarStyle option.
    if strcmpi(lgnd_style, 'pretty')
        % Whether or not to have a box
        lgnd_box = 'off';
        % Size of gap from axes
        m_l_gap = 0.10 * r_units;
        
    elseif strcmpi(cbar_style, 'plain')
        % Whether or not to have a box
        lgnd_box = 'on';
        % Size of gap from axes
        m_l_gap = 0.10 * r_units;
        
    elseif strcmpi(cbar_style, 'current')
        % Whether or not to have a box
        lgnd_box = 'current';
        % Size of gap from axes
        m_l_gap = 0.10 * r_units;
        
    else
        % Bad input
        error('set_plot:LegendStyle', ['LegendStyle must be ', ...
            'either ''pretty'', ''plain'', or ''current''.']);
    end
end


%% --- Color scheme ---

% Get the approach for the color schemes.
[c_style, keys] = cut_key(keys, 'ColorStyle', c_style);

% Process the minor options.
if strcmpi(c_style, 'pretty')
    % Color map
    s_cmap = 'blue';
    % Color style for bar
    c_bar  = 'contour';
    % Color sequence
    c_pseq = 'blue';
    
elseif strcmpi(c_style, 'plain')
    % Color map
    s_cmap = 'jet';
    % Color style for bar
    c_bar  = 'contour';
    % Color sequence for plots
    c_pseq = 'plain';
    
elseif strcmpi(c_style, 'gray') || strcmpi(c_style, 'grayscale')
    % Color map
    s_cmap = 'gray';
    % Color style for bar
    c_bar  = 'contour';
    % Color sequence for plots
    c_pseq = 'gray';
    
elseif strcmpi(c_style, 'bright')
    % Color map
    s_cmap = 'cyan';
    % Color style for bar
    c_bar  = 'sequence';
    % Color sequence for plots
    c_pseq = 'bright';
    
elseif strcmpi(c_style, 'dark')
    % Color map
    s_cmap = 'blue';
    % Color style for bar
    c_bar  = 'sequence';
    % Color sequence for plots
    c_pseq = 'dark';
    
elseif strcmpi(c_style, 'current')
    % Color map
    s_cmap = 'current';
    % Color style for bar
    c_bar  = 'current';
    % Color sequence for plots
    c_pseq = 'current';
    
else
    % Bad input
    error('set_plot:ColorStyle', ['ColorStyle must be ''pretty'', ', ...
        '''gray'', ''grayscale'',\n', ...
        '''plain'', ''bright'', ''dark'', or ''current''.']);
    
end


%% --- Plot style scheme ---

% Get the approach for the plot style scheme.
[l_style, keys] = cut_key(keys, 'PlotStyle', l_style);

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
[ctr_style, keys] = cut_key(keys, 'ContourStyle', ctr_style);

% Check value of string
if strcmpi(ctr_style, 'pretty')
    % Filled or not
    q_fill = 'off';
    % Labels or not
    q_label = 'on';
    % Line color
    c_c_line = 'auto';
    % Line style
    c_s_line = '-';
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
    % Line style
    c_s_line = '-';
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
    % Line style
    c_s_line = '-';
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
    % Line style
    c_s_line = '-';
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
    c_c_line = 'Black';
    % Line style
    c_s_line = 'none';
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
    % Line style
    c_s_line = '-';
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
    % Line style
    c_s_line = 'current';
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

% Get the handles for the title and axes.
if n_a > 1
    % Multiple-axis plot
    h_title = cell2mat(get(h_a, 'Title'));
    h_child = cell2mat(get(h_a, 'Children'));
else
    % Single-axis plot
    h_title = get(h_a, 'Title');
    h_child = get(h_a, 'Children');
end

% List of what type each child is.
t_child = get(h_child, 'Type');

% Convert to cell array if necessary.
if ~iscell(t_child)
    t_child = {t_child};
end

% Find the children that are lines.
i_line = strcmp(t_child, 'line');
h_line = h_child(i_line);
% h_line = findall(h_a, 'Type', 'line');
% Find the children that are text boxes.
h_text = findall(h_a, 'Type', 'text');
% Check if there is a legend.
if q_legend
    % Get the children of the legend.
    h_c_l = get(h_legend, 'Children');
    % Get the types.
    t_c_l = get(h_c_l, 'Type');
    % Find the ones that are text.
    i_c_t = strcmp(t_c_l, 'text');
    % Add the handles to the list.
    h_text = [h_text; h_c_l(i_c_t)];
end
% Get the 'hggroup' objects.
h_hggroup = findall(h_a, 'Type', 'hggroup');

% Number of said handles
n_hggroup = numel(h_hggroup);
% Initialize which of the handles are for bars.
q_h_bar = false(n_hggroup, 1);
% Initialize which of the handles are for contours.
q_h_contour = false(n_hggroup, 1);
% Loop through them.
for i = 1:n_hggroup
    % Get all the fields available.
    s_cur = get(h_hggroup(i));
    % Test what type of handle it is.
    if isfield(s_cur, 'ContourMatrix')
        % Contour plot
        q_h_contour(i) = true;
    elseif isfield(s_cur, 'BarLayout')
        % Bar graph
        q_h_bar(i) = true;
    end
end

% Handles to contour plots
h_contour = h_hggroup(q_h_contour);
% Handles to bar graph objects
h_bar = h_hggroup(q_h_bar);


%% --- Color map ---

% Get the colormap option
[s_cmap, keys] = cut_key(keys, 'ColorMap', s_cmap);

% Check for 'current'.
if ~strcmpi(s_cmap, 'current')
    set_colormap(h_f, s_cmap);
end


%% --- Line style sequence ---

% Get the LineStyle option.
[l_pseq, keys] = cut_key(keys, 'PlotLineStyle', l_pseq);
[l_pseq, keys] = cut_key(keys, 'LineStyle', l_pseq);

% Test for a recognized string.
if ischar(l_pseq) && ~strcmpi(l_pseq, 'current')
    % Look at the values of the string.
    if strcmpi(l_pseq, 'pretty')
        % Solid, dotted, dashed
        v_pseq = {'-', '--', '-.'};
    elseif strcmpi(l_pseq, 'fancy')
        % Solid, dotted, dashed, dot-dashed
        v_pseq = {'-', '--', '-.', ':'};
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
if ~all(strcmpi(l_pseq, 'current')) && iscell(v_pseq)
    % Number of styles.
    n_pseq = numel(v_pseq);
    % Find the lines.
    if isempty(h_line)
        % No lines.
        h_pseq = [];
    else
        % Get the lines that are actually plotted (LineStyle ~= none).
        h_pseq = h_line(~strcmp(get(h_line, 'LineStyle'), 'none'));
    end
    % Number of handles
    n_line = numel(h_pseq);
    % Index of style to use.
    i_pseq = 1;
    % Loop backwards through lines.
    for i = n_line:-1:1
        % Set the color.
        set(h_pseq(i), 'LineStyle', v_pseq{i_pseq});
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
[t_pseq, keys] = cut_key(keys, 'PlotLineWidth', t_pseq);
[t_pseq, keys] = cut_key(keys, 'lw', t_pseq);
[t_pseq, keys] = cut_key(keys, 'LineWidth', t_pseq);

% Test for a recognized string.
if ischar(t_pseq) && ~strcmpi(t_pseq, 'current')
    % Look at the values of the string.
    if strcmpi(t_pseq, 'pretty')
        % Solid, dotted, dashed
        v_pseq = [1.0, 1.0, 1.0, 2.0, 2.0, 2.0];
    elseif strcmpi(t_pseq, 'fancy')
        % Solid, dotted, dashed, dot-dashed
        v_pseq = [1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0];
    elseif strcmpi(t_pseq, 'simple')
        % Solid, dashed
        v_pseq = [1.0, 1.0, 2.0, 2.0];
    elseif strcmpi(t_pseq, 'plain')
        % Solid only, one width
        v_pseq = 1.0;
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
[c_pseq, keys] = cut_key(keys, 'ColorSequence', c_pseq);

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
        v_pseq = {'Black', [0.25, 0.25, 0.25], 'DarkGray', 'Silver'};
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
if ~all(strcmpi(c_pseq, 'current')) && iscell(v_pseq)
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
h_font = [h_a; h_x; h_y; h_z; h_title; h_text];

% Get font size.
[f_size, keys] = cut_key(keys, 'FontSize', f_size);
% Check for 'current'.
if ~strcmpi(f_size, 'current')
    % Apply changes.
    set(h_font, 'FontSize', f_size);
end

% Remember the current font.
f_cur = get(h_font, 'FontName');
% Set the default font to get sizing correct.
set(h_font, 'FontName', 'Helvetica')


%% --- Bargraph formatting ---

% Get the option for bar colors.
[c_bar, keys] = cut_key(keys, 'BarColorStyle', c_bar);

% Only bother if there are contours
for i = 1:numel(h_bar)
    % Get the current handle.
    h_b = h_bar(i);
    
    % Use the appropriate color if the sequence should be used.
    if strcmpi(c_bar, 'sequence')
        % Get the color index.
        i_pseq = i - floor((i-0.5)/n_pseq) * n_pseq;
        % Set the color.
        set(h_b, 'FaceColor', v_pseq(i_pseq,:));
    end
end


%% --- Axes application ---

% Get the tick length.
[l_cur, keys] = cut_key(keys, 'TickLength', l_tick);
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
[d_tick, keys] = cut_key(keys, 'TickDir', d_tick);
% Check for 'current'.
if ~strcmpi(d_tick, 'current')
    % Apply.
    set(h_a, 'TickDir', d_tick);
end

% Get the box option.
[s_box, keys] = cut_key(keys, 'Box', s_box);
% Check for 'current'.
if ~strcmpi(s_box, 'current')
    % Apply.
    set(h_a, 'Box', s_box);
end

% Get the minor tick option.
[s_tick, keys] = cut_key(keys, 'MinorTick', s_tick);
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
[r_grid, keys] = cut_key(keys, 'Grid', r_grid);
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
[s_grid, keys] = cut_key(keys, 'GridStyle', s_grid);
% Check for 'current'.
if ~strcmpi(s_grid, 'current')
    % Apply.
    set(h_a, 'GridLineStyle', s_grid)
end


%% --- Colorbar formatting ---

% Check if the colorbar is present.
if q_cbar
    
    % Get the box option.
    [cbar_box, keys] = cut_key(keys, 'ColorBarBox', cbar_box);
    % Check for 'current'.
    if ~strcmpi(cbar_box, 'current')
        % Apply.
        set(h_cbar, 'Box', cbar_box);
    end
    
    % Get the tick direction option.
    [cbar_d_tick, keys] = cut_key(keys, ...
        'ColorBarTickDir', cbar_d_tick);
    % Check for 'current'.
    if ~strcmpi(cbar_d_tick, 'current')
        % Apply.
        set(h_cbar, 'TickDir', cbar_d_tick);
    end
    
    % Get the minor tick option.
    [cbar_m_tick, keys] = cut_key(keys, ...
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
    [q_g_cbar, keys] = cut_key(keys, ...
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
    [s_g_cbar, keys] = cut_key(keys, ...
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
    [w_cbar, keys] = cut_key(keys, 'ColorBarWidth', w_cbar);
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
    [m_gap, keys] = cut_key(keys, 'ColorBarGap', m_gap);
    
end


%% --- Legend formatting ---

% Default legend text lables.
h_l_text = [];
i_l_text = {};

% Check if the colorbar is present.
if q_legend
    
    % Get the box option.
    [lgnd_box, keys] = cut_key(keys, 'LegendBox', lgnd_box);
    % Check for 'current'.
    if ~strcmpi(lgnd_box, 'current')
        % Apply.
        set(h_legend, 'Box', lgnd_box);
    end
    
    % Children
    h_l_child = get(h_legend, 'Children');
    % Type of each child
    t_l_child = get(h_l_child, 'Type');
    % Label handles
    h_l_text = h_l_child(strcmp(t_l_child, 'text'));
    % Interpreter for each label
    i_l_text = get(h_l_text, 'Interpreter');
    % Set the interpreter to none for sizing.
    set(h_l_text, 'Interpreter', 'tex');
end


%% --- Legend margins ---

% Check if the colorbar is present.
if q_legend
    % Change the units.
    set(h_legend, 'Units', units)
    % Get the dimensions.
    pos_lgnd = get(h_legend, 'Position');
    m_lgnd   = get(h_legend, 'TightInset');
    % Check the location of the legend.
    s_lgnd = get(h_legend, 'Location');
    % Process 'manual' locations.
    if strcmpi(s_lgnd, 'manual')
        % Set change parameter to 'true'.
        q_m_lgnd = true;
        if pos_lgnd(1) + pos_lgnd(3) > pos_lgnd(1) + pos_lgnd(3)
            % Outside on the right
            s_lgnd = 'EastOutside';
        elseif pos_cbar(2) + pos_cbar(4) > pos_axes(2) + pos_axes(4)
            % Outside on the top
            s_lgnd = 'NorthOutside';
        elseif pos_cbar(1) < pos_axes(1)
            % Outside on the left
            s_lgnd = 'WestOutside';
        elseif pos_cbar(2) < pos_axes(2)
            % Outside on the bottom
            s_lgnd = 'SouthOutside';
        else
            % Don't move the colorbar.
            q_m_lgnd = false;
        end
        % Test if the legend position should be reset.
        if q_m_lgnd
            % Reset the position.
            set(h_lgnd, 'Location', s_lgnd);
            % Reobtain the dimensions.
            pos_cbar = get(h_lgnd, 'Position');
            m_lgnd   = get(h_lgnd, 'TightInset');
        end
    end
    
    % Set the size of the gap between the axes and the colorbar.
    [m_l_gap, keys] = cut_key(keys, 'LegendGap', m_l_gap);
    
end


%% --- Margin alteration ---

% Determine the margin style.
[m_style, keys] = cut_key(keys, 'MarginStyle', m_style);
% Process style choice.
q_tight = strcmpi(m_style, 'tight');
q_loose = strcmpi(m_style, 'loose');
q_image = strcmpi(m_style, 'image');

% Get aspect ratio.
[ar_fig, keys] = cut_key(keys, 'AspectRatio', ar_fig);
% Convert 'auto' option.
if strcmpi(ar_fig, 'auto') || strcmpi(ar_fig, 'automatic') || ...
        strcmpi(ar_fig, 'current')
    % Get the aspect ratio of the current window.
    ar_fig = pos_fig(4) / pos_fig(3);
end

% Width of figure
[w_fig, keys] = cut_key(keys, 'Width', w_fig);
% Convert 'auto' option.
if strcmpi(w_fig, 'auto') || strcmpi(w_fig, 'automatic') || ...
        strcmpi(w_fig, 'current')
    w_fig = pos_fig(3);
end

% Manual extra margins
[m_cur, keys] = cut_key(keys, 'Margin', m_opts);
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

% Check for specific margins.
[m_opts(1), keys] = cut_key(keys, 'MarginLeft'  , m_opts(1));
[m_opts(2), keys] = cut_key(keys, 'MarginBottom', m_opts(2));
[m_opts(3), keys] = cut_key(keys, 'MarginRight' , m_opts(3));
[m_opts(4), keys] = cut_key(keys, 'MarginTop'   , m_opts(4));


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
    if n_a > 1
        % Multiple-axes plot; use the maximum on each side.
        m_axes = max(cell2mat(get(h_a, 'TightInset')));
    else
        % Single-axis plot
        m_axes = get(h_a, 'TightInset');
    end
    % Set the offsets at
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
    
    % Make room for the legend.
    if q_legend
        % Figure out which side the legend is on.
        switch s_lgnd
            case 'EastOutside'
                % Right-hand side
                m_tight(2) = max(m_axes(2), m_lgnd(2));
                m_tight(4) = max(m_axes(4), m_lgnd(4));
                m_tight(3) = m_axes(3) + m_lgnd(1) + ...
                    pos_lgnd(3) + m_lgnd(3) + m_l_gap;
            case 'NorthOutside'
                % Top location
                m_tight(1) = max(m_axes(1), m_lgnd(1));
                m_tight(3) = max(m_axes(3), m_lgnd(3));
                m_tight(4) = m_axes(4) + m_lgnd(2) + ...
                    pos_lgnd(4) + m_lgnd(4) + m_l_gap;
            case 'WestOutside'
                % Left-hand side
                m_tight(2) = max(m_axes(2), m_lgnd(2));
                m_tight(4) = max(m_axes(4), m_lgnd(4));
                m_tight(1) = m_axes(1) + m_lgnd(1) + ...
                    pos_lgnd(3) + m_lgnd(3) + m_l_gap;
            case 'SouthOutside'
                % Top location
                m_tight(1) = max(m_axes(1), m_lgnd(1));
                m_tight(3) = max(m_axes(3), m_lgnd(3));
                m_tight(2) = m_axes(2) + m_lgnd(2) + ...
                    pos_lgnd(4) + m_lgnd(4) + m_l_gap;
        end
    end
    
    % Add in extra margins.
    m_tight = m_opts + m_tight;
    
    % Fix the axes.
    if n_a > 1
        % Multiple-axes plot
        for i = 1:n_a
            % Fix the axes position.
            pos_axes{i}(1) = m_tight(1);
            pos_axes{i}(2) = m_tight(2);
            pos_axes{i}(3) = w_fig - m_tight(1) - m_tight(3);
            pos_axes{i}(4) = h_fig - m_tight(2) - m_tight(4);
            % Set them.
            set(h_a(i), 'Position', pos_axes{i});
        end
    else
        % Single-axis plot
        pos_axes(1) = m_tight(1);
        pos_axes(2) = m_tight(2);
        pos_axes(3) = w_fig - m_tight(1) - m_tight(3);
        pos_axes(4) = h_fig - m_tight(2) - m_tight(4);
        % Set them.
        set(h_a, 'Position', pos_axes);
    end
    
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
    
elseif q_image
    % Use the aspect ratio of the axes.
    for i = 1:2
        % Get the limits of the plot.
        a_x = get(h_a, 'XLim');
        a_y = get(h_a, 'YLim');
        a_z = get(h_a, 'ZLim');
        % View angle
        o_view = get(h_a, 'View');
        % Test for a 3D plot.
        q_z = any(o_view ~= [0 90]);
        % Aspect ratio of the axes.
        if ~q_z
            % 2D aspect ratio of axes
            ar_axes = diff(a_y) / diff(a_x);
        else
            % 3D aspect ratio of axes
            % Azimuth and elevation.
            el = o_view(1);
            az = o_view(2);
            % Get the length on the screen of the figure.
            l_x = diff(a_x) * abs(cosd(az)) + diff(a_y) * abs(sind(az));
            l_y = diff(a_x) * abs(sind(az)) + diff(a_y) * abs(cosd(az));
            l_y = l_y * abs(sind(el)) + diff(a_z) * abs(cosd(el));
            % 3D aspect ratio on the screen
            ar_axes = l_y / l_x;
        end
        
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
        pos_axes(4) = ar_axes * pos_axes(3);
        
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
        
        % Correct overall height of figure.
        h_fig  = pos_axes(4) + m_tight(2) + m_tight(4);
        
        % Set the paper size.
        set(h_f, 'PaperSize', [w_fig, h_fig]);
        % This should have no effect.
        set(h_f, 'PaperPosition', [0, 0, w_fig, h_fig]);
        
        % Fix the size of the figure.
        pos_fig(3:4) = [w_fig, h_fig];
        % Set the figure window size.
        set(h_f, 'Position', pos_fig);
        
        % Set the axes position.
        set(h_a, 'Position', pos_axes);
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
    
else
    % Set the paper size.
    set(h_f, 'PaperSize', [w_fig, h_fig]);
    % This should have no effect.
    set(h_f, 'PaperPosition', [0, 0, w_fig, h_fig]);
    
end

% Set the axes units to 'normalized' so that it scales with the window.
set(h_a, 'Units', 'normalized')


%% --- Font type application ---

% Update the text labels.
h_text = findall(h_a, 'Type', 'text');
% Reconstruct font handle.
h_font = [h_a; h_x; h_y; h_z; h_l_text; h_title; h_text];

% Get font name.
[f_name, keys] = cut_key(keys, 'FontName', f_name);
% Check for 'current'.
if strcmpi(f_name, 'current')
    % Apply old fonts to the existing handles.
    for i = 1:4
        set(h_font(i), 'FontName', f_cur{i});
    end
    % Set the other ones
    set(h_font(5:end), 'FontName', f_cur{1});
else
    % Apply changes.
    set(h_font, 'FontName', f_name);
end


%% --- Contour formatting ---

% Only bother if there are contours
for h_c = h_contour(:)'
    % Get the fill option.
    [q_fill, keys] = cut_key(keys, 'ContourFill', q_fill);
    % Apply it.
    if ~strcmpi(q_fill, 'current')
        set(h_c, 'Fill', q_fill);
    end
    
    % Get the label option.
    [q_label, keys] = cut_key(keys, 'ContourText', q_label);
    % Apply it.
    if ~strcmpi(q_label, 'current')
        set(h_c, 'ShowText', q_label);
    end
    
    % Get the labels if possible.
    h_c_child = get(h_c, 'Children');
    % Type of each.
    i_c_child = get(h_c_child, 'Type');
    % Ensure cell array.
    if numel(h_c_child) < 2
        i_c_child = {i_c_child};
    end
    % Find those that are labels.
    h_c_text  = h_c_child(strcmp(i_c_child, 'text'));
    % Find those that are lines.
    h_c_line  = h_c_child(strcmp(i_c_child, 'line'));
    % Move all labels so that they don't cross the contour lines by default.
    set(h_c_text, 'VerticalAlignment', 'bottom');
    
    % Get the font size option.
    [s_c_lbl, keys] = cut_key(keys, 'ContourFontSize', s_c_lbl);
    % Evaluate 'auto'.
    if strcmpi(s_c_lbl, 'auto')
        % Test the current font size.
        if ischar(f_size)
            % Use 'current'.
            s_c_lbl = 'current';
        else
            % Give it a smaller value than the overall font size.
            s_c_lbl = f_size - 1;
        end
    end
    % Check for 'current'.
    if ~strcmpi(s_c_lbl, 'current')
        % Apply the font size change.
        set(h_c_text, 'FontSize', s_c_lbl);
    end
    
    % Get the line coloring option.
    [c_c_line, keys] = cut_key(keys, 'ContourLineColor', c_c_line);
    % Apply it.
    if ischar(c_c_line)
        % Check for recognized values.
        if strcmpi(c_c_line, 'current')
            % Do nothing.
        elseif strcmpi(c_c_line, 'auto')
            % Use the given value.
            set(h_c, 'LineColor', c_c_line);
            % In this case the labels should be on the boundary.
            set(h_c_text, 'VerticalAlignment', 'middle')
        elseif any(strcmpi(c_c_line, {'none', 'off'}))
            % Turn the lines off.
            set(h_c, 'LineColor', 'none');
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
                set(h_c, 'LineColor', v_c_line);
            end
        end
    elseif isnumeric(c_c_line)
        % Apply the color directly
        set(h_c, 'LineColor', c_c_line);
    else
        % Bad input type
        error('set_plot:ContourColor', ['ContourLineColor must be ', ...
            'string or 1x3 double.']);
    end
    
    % Get the line style option
    [c_s_line, keys] = cut_key(keys, 'ContourLineStyle', c_s_line);
    % Apply it.
    if ischar(c_s_line)
        % Check for recognized values.
        if strcmpi(c_s_line, 'current')
            % Do nothing.
        else
            % Try to apply it.
            set(h_c, 'LineStyle', c_s_line);
        end
    else
        % Bad input type
        error('set_plot:ContourStyle', 'ContourLineStyle must be a char.');
    end
    
    % Get the font name option.
    [f_c_lbl, keys] = cut_key(keys, 'ContourFontName', f_c_lbl);
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
    [c_c_lbl, keys] = cut_key(keys, 'ContourFontColor', c_c_lbl);
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


%% --- Interpreter management ---

% Handles for all objects with an interpreter
h_interpreter = [h_x; h_y; h_z; h_l_text];
% Original interpreters for all of them
i_interpreter = [{i_x}; {i_y}; {i_z}; i_l_text];

% Get interpreter option.
[i_style, keys] = cut_key(keys, 'Interpreter', i_style);

% Loop through the handles with an interpreter.
for i = 1:numel(h_interpreter)
    % Current handle
    h_i = h_interpreter(i);
    % Check how to handle the interpreter.
    if strcmpi(i_style, 'auto') || strcmpi(i_style, 'automatic')
        % Check for a pair of \$ characters in each label.
        if numel(regexp(get(h_i, 'String'), '\$')) > 1
            % At least one equation region
            set(h_i, 'Interpreter', 'latex');
        else
            % No equation regions
            set(h_i, 'Interpreter', 'tex');
        end
    elseif strcmpi(i_style, 'latex')
        % Set all interpreters to 'latex'.
        set(h_i, 'Interpreter', 'latex');
    elseif strcmpi(i_style, 'tex')
        % Set all interpreters to 'tex'.
        set(h_i, 'Interpreter', 'tex');
    elseif strcmpi(i_style, 'none')
        % Set all interpreters to 'none'.
        set(h_i, 'Interpreter', 'none');
    elseif strcmpi(i_style, 'current')
        % Set the interpreter to its original value.
        set(h_i, 'Interpreter', i_interpreter{i});
    else
        % Bad input
        error('set_plot:Interpreter', ['Interpreter must be either ', ...
            '''auto'', ''automatic'', ''current'', ''tex'',\n', ...
            '''latex'', or ''none''.']);
    end
end


%% --- Output ---

% Check for leftover options
if ~isempty(fieldnames(keys))
    % Something was not used.
    warning('set_plot:ExtraOptions', ...
        'Some of the input options were not used.');
    % Output the remaining options.
    fprintf('\nRemaining options:\n');
    disp(keys)
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
    
    % Check for a legend.
    if q_legend
        h.legend = h_legend;
    end
end


% --- SUBFUNCTION 1: Get option and delete it ---
function [val, options] = cut_key(options, name, default)
%
% [val, options] = cut_key(options, name, default)
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


% --- SUBFUNCTION 2: Help for options ---
function help_keys
% SET_PLOT OPTIONS:
%    <strong>AspectRatio</strong>
%          [ {auto} | positive scalar ]
%       Aspect ratio to use for figure.  The 'auto' option tells the
%       function to use the aspect ratio of the current figure window.
%    <strong>AxesStyle</strong>
%          [ {current} | pretty | fancy | simple | smart | plain ]
%       Scheme to use for axes.  This is a cascading style.
%    <strong>BarColorStyle</strong>
%          [ {current} | contour | sequence ]
%       Whether to use the colormap or the color sequence for the colors
%       of bar graph objects.
%    <strong>Box</strong>
%          [ {current} | on | off ]
%       Whether or not to draw a box around the plot.
%    <strong>ColorBarStyle</strong>
%          [ {current} | pretty | fancy | plain ]
%       Style to use for colorbar.  This is a cascading style.
%    <strong>ColorBarBox</strong>
%          [ {current} | on | off ]
%       Whether or not to draw a box around the colorbar.
%    <strong>ColorBarMinorTick</strong>
%          [ {current} | on | off ]
%       Whether or not to use minor ticks on the colorbar.
%    <strong>ColorBarTickDir</strong>
%          [ {current} | in | out ]
%       Direction to draw ticks on the colorbar
%    <strong>ColorBarWidth</strong>
%          [ {current} | positive scalar ]
%       Width of colorbar, not including labels and ticks.
%    <strong>ColorBarGrid</strong>
%          [ {current} | on | off ]
%       Whether or not to draw grid lines in the colorbar.
%    <strong>ColorBarGridLineStyle</strong>
%          [ {current} | : | - | -- | -. ]
%       Style for grid lines in colorbar.
%    <strong>ColorBarGap</strong>
%          [ {0.1} | positive scalar ]
%       Distance between box containing plot and box containing colorbar.
%    <strong>ColorMap</strong>
%          [ {current} | char | Nx3 double | Nx4 double | cell array ]
%       The colormap can consist of either a label to a standard MATLAB
%       colormap or use a matrix of colors.  An additional option is to use
%       a cell array of colors.  Each color can be either a 1x3 RGB color or
%       an HTML color string such as 'OliveGreen'.  See <a href="matlab: help set_colormap">set_colormap</a>.
%    <strong>ColorSequence</strong>
%          [ {current} | plain | default | gray | black | blue | dark
%             | bright | Nx3 matrix | cell array ]
%       Sequence of colors for plot lines.
%    <strong>ColorStyle</strong>
%          [ {current} | pretty | plain | gray | bright | dark ]
%       Overall color theme.  This is a cascading style.
%       Color to use for labels in contour plots
%    <strong>ContourFill</strong>
%          [ {current} | on | off ]
%       Whether or not contours plots should be filled in.
%    <strong>ContourFontColor</strong>
%          [ {current} | auto | char | 1x3 double ]
%       Color to use for contour text labels.  The 'auto' value chooses
%       either black or white for each label in an attempt to pick a color
%       that is readable against the background.
%    <strong>ContourFontName</strong>
%          [ {current} | auto | char]
%       Font to use for contour text labels.  The 'auto' value
%       inherits the overall font specified using FontName.
%    <strong>ContourFontSize</strong>
%          [ {current} | auto | positive scalar ]
%       Size of font to use for contour text labels.  The 'auto' value
%       corresponds to a size one point smaller than the overall font
%       size specified using FontSize.
%    <strong>ContourLineColor</strong>
%          [ {current} | auto | char | 1x3 double ]
%       Color to use for contour lines.  The 'auto' value tells the
%       function to match the contour lines to the colormap values.
%    <strong>ContourLineStyle</strong>
%          [ {'current'} | '-' | 'none' | '--' | '-.' | ':' ]
%       Style to use for contour lines
%    <strong>ContourStyle</strong>
%          [ {current} | pretty | fancy | black | fill | smooth
%             | simple | plain ]
%       Style to use for contour plots.  This is a cascading style.
%    <strong>ContourText</strong>
%          [ {current} | on | off ]
%       Whether or not to use labels in contour plots.
%    <strong>FigureStyle</strong>
%          [ {current} | pretty | fancy | plain | journal | twocol
%             | onecol | present | presentation | color | plot ]
%       Overall figure style.  This is a cascading style.
%    <strong>FontName</strong>
%          [ {current} | font name (char) ]
%       Name of font to use for most text
%    <strong>FontSize</strong>
%          [ {current} | positive scalar ]
%       Size of fonts to use.
%    <strong>FontStyle</strong>
%          [ {current} | pretty | present | plain | serif | sans-serif ]
%       Scheme for text fonts and sizes.  This is a cascading style.
%    <strong>Grid</strong>
%          [ {current} | major | all | on | off | none | smart
%             | x | y | z | X | Y | Z ]
%       Whether or not to draw grid lines.  The strings 'x', 'y', etc. and
%       their combinations can be used to control the grid lines for each
%       axis.  The capital versions turn on both major and minor grid lines.
%       The 'smart' value turns on all major grid lines and minor grid lines
%       for any axis with linear spacing.
%    <strong>Interpreter</strong>
%          [ {current} | auto | tex | latex | none ]
%       Rules to use for text interpreters.  The 'auto' option turns most
%       interpreters to 'tex', except those with multiple '$' characters,
%       for which it uses the 'latex' interpreter.
%    <strong>LegendBox</strong>
%          [ {current} | on | off ]
%       Whether or not to use a box around the legend.
%    <strong>LegendGap</strong>
%          [ {0.1} | positive scalar ]
%       Gap between graph and legend.
%    <strong>LegendStyle</strong>
%          [ {current} | plain | pretty ]
%       Style to use for the legend.  This is a cascading style.
%    <strong>LineStyle</strong>
%          [ {current} | pretty | fancy | simple | plain | cell array ]
%       Sequence of plot styles.
%    <strong>LineWidth</strong>
%          [ {current} | pretty | fancy | simple | plain | cell array
%             | double array ]
%       Sequence of widths for plot lines.
%    <strong>Margin</strong>
%          [ 0.025 | scalar vector with up to four entries ]
%       Extra margin to add for 'tight' MarginStyle.
%    <strong>MarginBottom</strong>
%          [ 0.025 | positive scalar ]
%       Extra bottom margin to add for 'tight' MarginStyle.
%    <strong>MarginLeft</strong>
%          [ 0.025 | positive scalar ]
%       Extra left margin to add for 'tight' MarginStyle.
%    <strong>MarginRight</strong>
%          [ 0.025 | positive scalar ]
%       Extra right margin to add for 'tight' MarginStyle.
%    <strong>MarginStyle</strong>
%          [ {tight} | loose | image ]
%       Style for the margins.  The 'tight' option cuts off all margins, and
%       the 'loose' option restores the defaults.  Both options change the
%       paper size so that the figure has the proper dimensions when the
%       'saveas' command is used.
%    <strong>MarginTop</strong>
%            [ 0.025 | positive scalar ]
%       Extra top margin to add for 'tight' MarginStyle.
%    <strong>MinorTick</strong>
%          [ {current} | all | none | on | off | smart
%             | x | y | z | xy | xz | xy | xyz ]
%       Whether or not to use minor ticks on the axes.  The 'smart'
%       value turns on minor ticks for all non-logarithmic axes.
%    <strong>PlotStyle</strong>
%          [ {current} | pretty | fancy | plain ]
%       Style to use for plot lines.  This is a cascading style.
%    <strong>TickDir</strong>
%          [ {current} | in | out ]
%       Tick direction for main plot.
%    <strong>TickLength</strong>
%          [ {current} | short | long | 1x2 double ]
%       Length of ticks for main axes.
%    <strong>Width</strong>
%          [ {auto} | positive scalar ]
%       Width of figure.
%

return


% --- SUBFUNCTION 3: Display cascading style chart ---
function help_cascading_styles
% SET_PLOT CASCADING STYLE CHART:
%
%   <strong>FigureStyle</strong>
%       'color'
%           AspectRatio      -> 0.75
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'dark'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'pretty'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotStyle        -> 'plain'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 3.1
%       'current'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'current'
%           ColorBarStyle    -> 'current'
%           ColorStyle       -> 'current'
%           ContourStyle     -> 'current'
%           FontStyle        -> 'current'
%           Interpreter      -> 'current'
%           LegendStyle      -> 'current'
%           PlotStyle        -> 'current'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'current'
%           Width            -> 'auto'
%       'fancy'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'pretty'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotLineStyle    -> 'pretty'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 'auto'
%       'journal'
%           AspectRatio      -> 0.75
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'gray'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'pretty'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotStyle        -> 'current'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 3.1
%       'onecol'
%           AspectRatio      -> (sqrt(5)-1)/2
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'fancy'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'fancy'
%           FontStyle        -> 'pretty'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotStyle        -> 'current'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 6
%       'plain'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'plain'
%           ColorBarStyle    -> 'plain'
%           ColorStyle       -> 'plain'
%           ContourStyle     -> 'plain'
%           FontStyle        -> 'plain'
%           Interpreter      -> 'current'
%           LegendStyle      -> 'plain'
%           PlotStyle        -> 'plain'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'loose'
%           Width            -> 'auto'
%       'plot'
%           AspectRatio      -> 0.75
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'current'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'pretty'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotStyle        -> 'current'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 3.1
%       'present'
%           AspectRatio      -> 0.75
%           AxesStyle        -> 'pretty'
%           ColorBarStyle    -> 'pretty'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'pretty'
%           FontStyle        -> 'present'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotStyle        -> 'current'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 2.125
%       'pretty'
%           AspectRatio      -> 'auto'
%           AxesStyle        -> 'fancy'
%           ColorBarStyle    -> 'fancy'
%           ColorStyle       -> 'pretty'
%           ContourStyle     -> 'fancy'
%           FontStyle        -> 'pretty'
%           Interpreter      -> 'auto'
%           LegendStyle      -> 'pretty'
%           PlotStyle        -> 'simple'
%           Margin           -> 0.025*ones(1,4)
%           MarginStyle      -> 'tight'
%           Width            -> 'auto'
%
%    <strong>AxesStyle</strong>
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
%   <strong>ColorBarStyle</strong>
%       'current'
%           ColorBarBox           -> 'current'
%           ColorBarMinorTick     -> 'current'
%           ColorBarTickDir       -> 'current'
%           ColorBarWidth         -> 'current'
%           ColorBarGrid          -> 'current'
%           ColorBarGridLineStyle -> 'current'
%           ColorBarGap           -> 0.1
%       'fancy'
%           ColorBarBox           -> 'on'
%           ColorBarMinorTick     -> 'on'
%           ColorBarTickDir       -> 'out'
%           ColorBarWidth         -> 0.15
%           ColorBarGrid          -> 'on'
%           ColorBarGridLineStyle -> ':'
%           ColorBarGap           -> 0.1
%       'plain'
%           ColorBarBox           -> 'on'
%           ColorBarMinorTick     -> 'off'
%           ColorBarTickDir       -> 'in'
%           ColorBarWidth         -> 0.2778
%           ColorBarGrid          -> 'off'
%           ColorBarGridLineStyle -> 'current'
%           ColorBarGap           -> 0.1
%       'pretty'
%           ColorBarBox           -> 'off'
%           ColorBarMinorTick     -> 'on'
%           ColorBarTickDir       -> 'out'
%           ColorBarWidth         -> 0.15
%           ColorBarGrid          -> 'off'
%           ColorBarGridLineStyle -> 'current'
%           ColorBarGap           -> 0.1
%
%   <strong>ColorStyle</strong>
%       'bright'
%           ColorSequence -> 'bright'
%           ColorMap      -> 'cyan'
%           BarColorStyle -> 'sequence'
%       'current'
%           ColorSequence -> 'current'
%           ColorMap      -> 'current'
%           BarColorStyle -> 'current'
%       'dark'
%           ColorSequence -> 'dark'
%           ColorMap      -> 'blue'
%           BarColorStyle -> 'sequence'
%       'gray'
%           ColorSequence -> 'gray'
%           ColorMap      -> 'gray'
%           BarColorStyle -> 'contour'
%       'plain'
%           ColorSequence -> 'plain'
%           ColorMap      -> 'jet'
%           BarColorStyle -> 'contour'
%       'pretty'
%           ColorSequence -> 'blue'
%           ColorMap      -> 'blue'
%           BarColorStyle -> 'contour'
%
%   <strong>ContourStyle</strong>
%       'black'
%           ContourFill      -> 'off'
%           ContourFontColor -> 'Black'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'Black'
%           ContourLineStyle -> '-'
%           ContourText      -> 'on'
%       'current'
%           ContourFill      -> 'current'
%           ContourFontColor -> 'current'
%           ContourFontName  -> 'current'
%           ContourFontSize  -> 'current'
%           ContourLineColor -> 'current'
%           ContourLineStyle -> '-'
%           ContourText      -> 'current'
%       'fancy'
%           ContourFill      -> 'on'
%           ContourFontColor -> 'auto'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'Black'
%           ContourLineStyle -> '-'
%           ContourText      -> 'on'
%       'pretty'
%           ContourFill      -> 'off'
%           ContourFontColor -> 'Black'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'auto'
%           ContourLineStyle -> '-'
%           ContourText      -> 'on'
%       'plain'
%           ContourFill      -> 'off'
%           ContourFontColor -> 'current'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'auto'
%           ContourLineStyle -> '-'
%           ContourText      -> 'off'
%       'smooth'
%           ContourFill      -> 'on'
%           ContourFontColor -> 'current'
%           ContourFontName  -> 'auto'
%           ContourFontSize  -> 'auto'
%           ContourLineColor -> 'auto'
%           ContourLineStyle -> 'none'
%           ContourText      -> 'off'
%
%   <strong>FontStyle</strong>
%       'current'
%           FontName -> 'current'
%           FontSize -> 'current'
%       'plain'
%           FontName -> 'Helvetica'
%           FontSize -> 10
%       'pretty'
%           FontName -> 'Times New Roman'
%           FontSize -> 9
%       'sans-serif'
%           FontName -> 'Helvetica'
%           FontSize -> 'current'
%       'serif'
%           FontName -> 'Times New Roman'
%           FontSize -> 'current'
%
%   <strong>LegendStyle</strong>
%       'current'
%           LegendBox   -> 'current'
%           LegendGap   -> 0.1
%       'plain'
%           LegendBox   -> 'current'
%           LegendGap   -> 0.1
%       'pretty'
%           LegendBox   -> 'current'
%           LegendGap   -> 0.1
%
%   <strong>PlotStyle</strong>
%       'current'
%           LineStyle -> 'current'
%           LineWidth -> 'current'
%       'fancy'
%           LineStyle -> 'fancy'
%           LineWidth -> 'fancy'
%       'plain'
%           LineStyle -> 'plain'
%           LineWidth -> 'plain'
%       'pretty'
%           LineStyle -> 'pretty'
%           LineWidth -> 'pretty'
%

return
