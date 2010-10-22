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


% Number of varargs
n_arg = length(varargin);
% Check first input.
if n_arg > 0 && isnumeric(varargin{1})
	% First input is figure handle.
	h_f = varargin{1};
else
	% Just use gcf.
	h_f = gcf;
end

% Initial options
options = [];

% Process the optional inputs.
% Set index of current input.
i_arg = 0;
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

% Current units
units = get_option(options, 'Units', 'inches');
	

% Set this to true for the time being.
q_squeeze = true;



% Analysis part.


% Axis handle
h_a = get(h_f, 'CurrentAxes');
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

% Set matching units.
set(h_f, 'Units'     , units);
set(h_f, 'PaperUnits', units);
set(h_a, 'Units'     , units);

% Positions
pos_fig  = get(h_f, 'Position');
pos_axes = get(h_a, 'Position');

% Get aspect ratio.
ar_fig   = get_option(options, 'AspectRatio', pos_fig(4)/pos_fig(3));


% Dimensions of figure
w_fig  = get_option(options, 'Width', pos_fig(3));
h_fig  = ar_fig * w_fig;

% Squeeze the axes if applicable.
if q_squeeze
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
	
	
end

% Reset the interpreters to their original values.
set(h_x, 'Interpreter', i_x);
set(h_y, 'Interpreter', i_y);
set(h_z, 'Interpreter', i_z);