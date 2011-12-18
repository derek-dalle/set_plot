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
%     Otherwise, the user will have
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
%           Display : [ {on} | off | verbose ]
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
if isfield(options, 'InstallationType')
	% Get the option.
	o_cur = options.DefaultInstallation;
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

% Test for an option to go for just the default installation.
if isfield(options, 'DefaultInstallation')
	% Get the option.
	o_cur = options.DefaultInstallation;
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


%% --- System testing ---

% Initialize struct of status messages.
S = [];

% This is the version of the file that I make changes to locally.
path_dev = '/afs/umich.edu/user/d/a/dalle/Public/set_plot/src/set_plot.m';

% This tests if the user has access to that file.
q_dev = exist(path_dev, 'file') == 2;

% This construct is a little strange.
% The point is to generate an error message that goes into the output but
% does not bother the user with an stderr type of message.
try
	% Generate an error message.
	error('install:NoAFSPath', ['The developmental file could not ', ...
		'be found.\nThis could be because AFS is not installed ', ...
		'or the path to the file has changed.']);
catch msg
	% Save the message
	S.dev = msg;
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
		fid_startup = fopen(path_startup, 'r+');
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




%% --- Output ---

% Output
if nargout > 0
	s = S;
end

% Close the startup file.
fclose(fid_startup);
