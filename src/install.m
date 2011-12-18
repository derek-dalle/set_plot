function s = install(varargin)
%
% install
% install('OptionName', optionValue, ... )
% s = install(...)
%
% INPUTS:
%         All inputs are either options or tags.  See below.
%
% OUTPUTS:
%         s : status (0 if installation was successful)
%
% This function runs the MATLAB portion of the installation for set_plot.
% The function will present the user with choices for installation
% versions, presenting only options that are available.
%
% There are nine possible installation types.  These can also be called
% directly from the command line, as the follwing example shows.
%
%       install('InstallationType', 3)
%
% If the user calls the installation file in the following way
%
%       install('DefaultInstallation', true)
%
% then the function will try to perform installation method #5 unless it
% fails.  If neither 'InstallationType' or 'DefaultInstallation' are
% specified from the command line, the function will ask a series of
% questions.  They are described below.  Descriptions are below each
% question.
%
% Q1: Would you like to use the author's (unstable) version of set_plot?
%
%     This option allows the user to forget about downloading new versions
%     of set_plot all the time and instead use the author's copy at all
%     times.  This means that the user will get both the newest features
%     and the newest bugs.  There will be no guarantee that the function
%     will have the same results if it is called at some point in the
%     future.  In addition, this requires that the user has AFS installed.
%
% Q2: Should MATLAB automatically load set_plot each time it starts?
%
%     If this parameter is set, the user will be able to call set_plot at
%     all times from MATLAB without requiring any thought or action.
%
% Q3: Should there be a simple command to start set_plot?
%
%     This question is only asked if the answers to questions (1) and (2)
%     are both 'no'.  Selecting this option will put a single command,
%     'startup_set_plot' into the MATLAB path, which the user can call at
%     any time to make the set_plot commands available.  The installation
%     will not proceed to question (4) if the user answers question (3)
%     with a 'no'.
%
% Q4: Should all versions of MATLAB on this computer use set_plot?
%
%     This option will install the set_plot files in a location such that
%     all other versions of MATLAB on the computer (including future
%     versions) should be able to use set_plot with no further
%     installation.  This will usually work, but it may not have the
%     expected result if the user has previously changed the value of the
%     MATLAB variable called 'userpath'.
%
% The nine installation types are listed below.
%
%    1. Load the author's copy on startup for all MATLAB versions.
%    2. Add a command to load the author's copy for all MATLAB versions.
%    3. Load the author's copy on startup.
%    4. Add a command to load the author's copy.
%    5. Load stable version of set_plot on startup for all MATLAB versions.
%    6. Add a command to load the stable version for all MATLAB versions.
%    7. Load stable version of set_plot on startup.
%    8. Add a command to load the stable version.
%    9. Do nothing except copy the files to a different folder.
%
% The installation procedure will test if a given installation can succeed
% before trying it.  This means that it will not ask one of the questions
% if the choice is not truly available.  If the installation type is
% specified from the command line, and that option is not available, the
% installer will default to 'InstallationType', 9.
%
% Note that all of the installation options only install set_plot for the
% current user; other users--even on the same machine--will not be able to
% use it.
%
% OPTIONS:
%       BetaInstall : [ {false} | true ]
%    DefaultInstall : [ {false} | true ]
%       DefualtPath : [ {true} | false ]
%       InstallPath : [ {''} | string ]
%       InstallType : [ {[]} | 1 | 2 | ... | 9 ]
%    StartupCommand : [ {true} | false ]
%       StartupLoad : [ {true} | false ]            
%

% Versions:
%  2011.12.17 @Derek Dalle    : First version
%
% GNU GPL version 2
% Copyright 2011 by Derek J. Dalle


%% --- Input processing ---

% Initialize the options struct.
options = [];

% Process the inputs.
% Number of varargs.
n_arg = length(varargin);
% Index of current argument
i_arg = 0;
while n_arg > i_arg
	% Move to the next argument.
	i_arg = i_arg + 1;
	% Get the current argument's value.
	v_arg = varargin{i_arg};
	% Test which type it is.
	if ischar(v_arg)
		% Check if there is an option value.
		if i_arg >= n_arg
			% Option with no value.
			error('MASIV:OptionValue', ['The option ''%s'' ', ...
				'has no value.'], v_arg);
		end
		% Value of the next argument.
		v_next = varargin{i_arg+1};
		% Assign  option name/value pair to a struct.
		options.(v_arg) = v_next;
		% Move to the next argument.
		i_arg = i_arg + 1;
		
	elseif isempty(v_arg)
		% Do nothing.
		
	elseif isstruct(v_arg)
		% Get the fieldnames of the struct.
		v_fields = fieldnames(v_arg);
		% Get the values of the fields.
		v_arg    = struct2cell(v_arg);
		% Loop through the fields.
		for i = 1:numel(v_fields)
			options.(v_fields{i}) = v_arg{i};
		end
		
	else
		% Bad input
		error('instsall:InputType', ['One of the optional inputs ', ...
			'could not be interpreted.']);
		
	end	
end


%% --- Option processing ---

% Initialize struct of status messages.
S = [];

% Test for an option to go for just the default installation.
if isfield(options, 'DefaultInstall')
	% Get the option.
	o_cur = options.DefaultInstall;
	% Process it.
	if (ischar(o_cur) && strcmpi(o_cur, 'true')) || ...
			(isa(o_cur, 'logical') && numel(o_cur)==1 && o_cur)
		% Use defaults and avoid interactive mode.
		q_default = true;
	else
		% Do not use defaults.
		q_default = false;
	end
else
	% Do not use the defaults.
	q_default = false;
end

% Test for an option to go for just the default installation.
if isfield(options, 'BetaInstall')
	% Get the option.
	o_cur = options.BetaInstall;
	% Process it.
	if (ischar(o_cur) && strcmpi(o_cur, 'true')) || ...
			(isa(o_cur, 'logical') && numel(o_cur)==1 && o_cur)
		% Use defaults and avoid interactive mode.
		q_beta = true;
	else
		% Do not use defaults.
		q_beta = false;
	end
else
	% Do not use the defaults.
	q_beta = false;
end

% Test for an option to go for just the default installation.
if isfield(options, 'StartupCommand')
	% Get the option.
	o_cur = options.StartupCommand;
	% Process it.
	if (ischar(o_cur) && strcmpi(o_cur, 'true')) || ...
			(isa(o_cur, 'logical') && numel(o_cur)==1 && o_cur)
		% Use defaults and avoid interactive mode.
		q_com = true;
	else
		% Do not use defaults.
		q_com = false;
	end
else
	% Do not use the defaults.
	q_com = false;
end

% Test for an option to go for just the default installation.
if isfield(options, 'StartupLoad')
	% Get the option.
	o_cur = options.StartupLoad;
	% Process it.
	if (ischar(o_cur) && strcmpi(o_cur, 'true')) || ...
			(isa(o_cur, 'logical') && numel(o_cur)==1 && o_cur)
		% Use defaults and avoid interactive mode.
		q_start = true;
	else
		% Do not use defaults.
		q_start = false;
	end
else
	% Do not use the defaults.
	q_start = false;
end

% Test for an option to go for just the default installation.
if isfield(options, 'DefaultPath')
	% Get the option.
	o_cur = options.DefaultPath;
	% Process it.
	if (ischar(o_cur) && strcmpi(o_cur, 'true')) || ...
			(isa(o_cur, 'logical') && numel(o_cur)==1 && o_cur)
		% Use defaults and avoid interactive mode.
		q_path = true;
	else
		% Do not use defaults.
		q_path = false;
	end
else
	% Do not use the defaults.
	q_path = false;
end

% Test for an option to go for just the default installation.
if isfield(options, 'InstallType')
	% Get the option.
	o_cur = options.InstallType;
	% Test for a char.
	if ischar(o_cur)
		% Try to convert it to a number.
		o_cur = str2double(o_cur);
	end
	% Process it.
	if isnumeric(o_cur) && numel(o_cur)==1
		% Use defaults and avoid interactive mode.
		q_num = true;
		q_val = o_cur;
	else
		% Do not use defaults.
		q_num = false;
	end
else
	% Do not use the defaults.
	q_num = false;
end

% Get an installation path.
if isfield(options, 'InstallPath')
	% Get the option.
	i_path = options.InstallPath;
	% Use the path.
	q_path_d = true;
else
	% Do not use the path.
	q_path_d = false;
end


%% --- System testing ---

% This is the version of the file that I make changes to locally.
path_dev = '/afs/umich.edu/user/d/a/dalle/Public/set_plot/src/set_plot.m';

% This tests if the user has access to that file.
q_dev = exist(path_dev, 'file') == 2;

% This construct is a little strange.
% The point is to generate an error message that goes into the output but
% does not bother the user with an stderr type of message.
if ~q_dev
	try
		% Generate an error message.
		error('install:NoAFSPath', ['The developmental file could not ', ...
			'be found.\nThis could be because AFS is not installed ', ...
			'or the path to the file has changed.']);
	catch msg
		% Save the message
		S.dev = msg;
	end
end

% Try to get the userpath.
try
	% Call upath
	upath = userpath;
	% Split the userpath by ':'.
	% Find the ':' characters.
	% NOTE: This is not too simple to work because MATLAB does not support
	% directory names with colons even though the operating system might.
	n = find(upath == ':');
	% Number of characters to take
	if isempty(n)
		% Use all characters.
		n = numel(upath);
	else
		% Read from the first character up to the first colon.
		n = n(1) - 1;
	end
	% Use the first entry in userpath.
	upath = upath(1:n);
	% Test if the folder actually exists.
	if exist(upath, 'dir') == 7
		% Passing status
		q_u = true;
		% Path to startup.m
		if ispc
			% Windows
			path_startup = [upath, '\startup.m'];
		else
			% Unix-like
			path_startup = [upath, '/startup.m'];
		end
		% Try to open statup.m
		fid_startup = fopen(path_startup, 'a+');
		% Test if it worked.
		if fid_startup < 3
			% File cannot be written to.
			error('install:NoWriteAccess', ['The ''userpath'' ', ...
				'folder exists, but MATLAB does not have write access.']);
		end
		
	else
		% Folder does not exist.
		error('install:NoUserPath', ['Although ''userpath'' ', ...
			'evaluated, the resulting folder:\n   %s\n', ...
			'does not exist.'], upath);
		
	end
catch msg
	% Failed to find userpath.
	q_u = false;
	% Save the message.
	S.userpath = msg;
end

% Initialize the availability of the options.
q = true(1, 9);

% Check if any installation options are unavailable.
if ~q_u
	% No startup access.
	q(1:8) = false;
elseif ~q_dev
	% No beta-testing access.
	q(1:4) = false;
end


%% --- Interface ---

% Test if there are any options available.
if sum(q) == 1
	% The only option is (9).
	n_q = 9;
	% No more questions.
	q_cont = false;
else
	% More questions.
	q_cont = true;
end

% First process if a default installation was requested.
if q_cont && q_default
	% Use option (5); install it for all MATLAB versions directly.
	n_q = 5;
	% No more questions.
	q_cont = false;
elseif q_cont && q_num
	% Test if the value is available.
	if q(q_val)
		% Use the user-specified value.
		n_q = q_val;
		% No more questions.
		q_cont = false;
	end
end


%% --- Question 1 ---

% Test if question (1) should be asked.
if q_dev && q_cont && ~isfield(options, 'BetaInstall')
	% Ask question (1).
	fprintf(['Would you like to use the author''s (unstable) ', ...
		'version of set_plot?\n']);
	% Give three tries to answer.
	for i = 1:3
		% Response.
		o_cur = input('   [ y / {n} / help ]   ', 's');
		% Process
		switch lower(o_cur)
			case {'y', 'yes'}
				% Positive result.
				q_1 = true;
				% Exit
				break
			case {'n', 'no', ''}
				% Negative result.
				q_1 = false;
				% Exit
				break
			case {'h', 'help', 'more'}
				% Print out more info.
				fprintf(['\nThis option allows the user to forget ', ...
					'about downloading new\nversions of set_plot and ', ...
					'instead use the author''s copy at all\ntimes.  ', ...
					'This means that the user will get both the ', ...
					'newest\nfeatures and the newest bugs.  There ', ...
					'will be no guarantee that the\nfunction will have ', ...
					'the same results if it is called at some point\n', ...
					'in the future.  In addition, this requires that ', ...
					'AFS is installed.\n\n']);
		end
	end
elseif q_cont && q_dev
	% Use the value specified in the option.
	q_1 = q_beta;
end


%% --- Question 2 ---

% Test if question (2) should be asked.
if q_u && q_cont && ~isfield(options, 'StartupLoad')
	% Ask question (1).
	fprintf(['Should MATLAB automatically load set_plot ', ...
		'each time it starts?\n']);
	% Give three tries to answer.
	for i = 1:3
		% Response.
		o_cur = input('   [ y / {n} / help ]   ', 's');
		% Process
		switch lower(o_cur)
			case {'y', 'yes'}
				% Positive result.
				q_2 = true;
				% Exit
				break
			case {'n', 'no', ''}
				% Negative result.
				q_2 = false;
				% Exit
				break
			case {'h', 'help', 'more'}
				% Print out more info.
				fprintf(['\nIf this parameter is set, the user will ', ...
					'be able to call set_plot\nat all times from ', ...
					'MATLAB without requiring any thought or action.\n\n']);
		end
	end
elseif q_cont && q_u
	% Use the value specified in the option.
	q_2 = q_start;
end


%% --- Question 3 ---

% Test if question (3) should be asked.
if q_u && q_cont && ~q_1 && ~q_2 && ~isfield(options, 'StartupCommand')
	% Ask question (3).
	fprintf('Should there be a simple command to start set_plot?\n');
	% Give three tries to answer.
	for i = 1:3
		% Response.
		o_cur = input('   [ y / {n} / help ]   ', 's');
		% Process
		switch lower(o_cur)
			case {'y', 'yes'}
				% Positive result.
				q_3 = true;
				% Exit
				break
			case {'n', 'no', ''}
				% Negative result.
				q_3 = false;
				% Exit
				break
			case {'h', 'help', 'more'}
				% Print out more info.
				fprintf(['\nSelecting this option will put a single ', ...
					'command,\n''startup_set_plot'' into the MATLAB ', ...
					'path, which the user can call\nat any time to ', ...
					'make the set_plot commands available.\n\n']);
		end
	end
elseif q_cont && (q_1 || q_d)
	% Turn this option off.
	q_3 = false;
elseif q_cont && q_u
	% Use the value specified in the option.
	q_3 = q_com;
end


%% --- Question 4 ---

% Test if question (4) should be asked.
if q_u && q_cont && q_3 && ~isfield(options, 'DefaultPath')
	% Ask question (4).
	fprintf(['Should all versions of MATLAB on this computer ', ...
		'use set_plot?\n']);
	% Give three tries to answer.
	for i = 1:3
		% Response.
		o_cur = input('   [ y / {n} / help ]   ', 's');
		% Process
		switch lower(o_cur)
			case {'y', 'yes'}
				% Positive result.
				q_4 = true;
				% Exit
				break
			case {'n', 'no', ''}
				% Negative result.
				q_4 = false;
				% Exit
				break
			case {'h', 'help', 'more'}
				% Print out more info.
				fprintf(['\nThis option will install the set_plot ', ...
					'files in a location such\mthat all other ', ...
					'versions of MATLAB on the computer (including\n', ...
					'future versions) should be able to use ', ...
					'set_plot with no further\ninstallation.  This ', ...
					'will usually work, but it may not have the\n', ...
					'expected result if the user has previously ', ...
					'changed the value of the MATLAB variable\n', ...
					'called ''userpath''.\n\n']);
		end
	end
elseif q_cont && q_u
	% Use the value specified in the option.
	q_4 = q_path;
end


%% --- Question 5 ---

% Test if question (4) should be asked.
if q_u && q_cont && ~q_3 && ~isfield(options, 'InstallPath')
	% Ask question (4).
	fprintf(['Where should MATLAB install the files?\n']);
	% Response.
	i_path = input('   ', 's');
elseif q_cont && q_u && ~q_path_d
	% Use the value specified in the option.
	i_path = pwd;
end

% Test if the path works.
try
	% Use the MATLAB 'ls' command.
	ls(i_path)
catch msg
	% Use the default value.
	i_path = pwd;
	% Save the error message.
	S.InstallPath = msg;
end


%% --- Process the interface results ---

% Test if it's necessary.
if q_cont
	% Test the questions.
	if q_1 && q_2 && q_4
		% Unstable version for all MATLABs
		n_q = 1;
	elseif q_1 && q_2 && ~q_4
		% Unstable version for this MATLAB
		n_q = 2;
	elseif q_1 && ~q_2 && q_4
		% Unstable for all MATLABs with no startup
		n_q = 3;
	elseif q_1 && ~q_2 && ~q_4
		% Unstable for this MATLAB with no startup
		n_q = 4;
	elseif ~q_2 && ~q_3
		% Just copy files.
		n_q = 9;
	elseif q_2 && q_4
		% Stable version for all MATLABs
		n_q = 5;
	elseif q_2 && ~q_4
		% Stable version for this MATLAB
		n_q = 6;
	elseif q_4
		% Stable version for all MATLABs with no startup
		n_q = 7;
	elseif ~q_4
		% Stable version for this MATLAB with no startup
		n_q = 8;
	end
end




%% --- Output ---

% Close the startup file.
try
	% Close it if possible.
	fclose(fid_startup);
catch msg
	% No file to close.
	S.StartupFileIdentifier = msg;
end

% Output
if nargout > 0
	s = S;
end
