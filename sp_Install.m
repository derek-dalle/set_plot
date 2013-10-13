function ierr = sp_Install
%SP_INSTALL Install set_plot package
%
% CALL:
%    sp_Install
%    ierr = sp_Install
%
% INPUTS:
%    (None)
%
% OUTPUTS:
%    ierr : exit status, 0 if installation was successful
%           0 : success
%           1 : failed to write updated 'startup.m'
%           2 : could not find "set_plot" folders
%
% This function installs the "set_plot" package for MATLAB.  More
% specifically, it adds commands to the 'startup.m' file to add the
% "set_plot" directories to your path when you start MATLAB.
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
%  2011.12.17 @dalle   : First version
%  2013.10.08 @dalle   : Greatly simplified, single option


% Be very safe.
try
	% Introductory comment
	fprintf('Installing ''set_plot'' using ''sp_Install''.\n');
	fprintf('Welcome to set_plot!\n');
	
	% Make sure to say how to uninstall set_plot right away.
	fprintf('\nTo uninstall ''set_plot'', run ''sp_Uninstall''.\n\n');
	
	% Get the path to this file.
	fpath = fileparts(which(mfilename));
	% Path to main packages
	sppath = fullfile(fpath, 'set_plot');
	% Path to utility functions
	utilpath = fullfile(fpath, 'util');
	
	% Output.
	fprintf('Checking for ''set_plot'' files.\n');
	% Sanity check: does 'set_plot.m' exist in the anticipated location?
	if (exist(sppath, 'dir') ~= 7) || (exist(utilpath, 'dir') ~= 7)
		% Check how the function was called.
		if nargout > 0
			% Set failure flag and quit.
			ierr = 2;
			return
		else
			% Use an error message.
			error('set_plot:MissingSource', ...
				'The "set_plot" directories could not be found.');
		end
	end
	
	% Get the default userpath.
	upath_cell = regexp(userpath, pathsep, 'split');
	% Get the first path (This can't be empty, as far as I can tell.)
	upath = upath_cell{1};
	% Check it.
	if isempty(upath)
		% Check how the function was called.
		if nargout > 0
			% Set failure flag and quit.
			ierr = 1;
			return
		else
			% Use an error message.
			error('set_plot:UserPath', ...
				'The default path could not be located, see USERPATH.');
		end
	end
	
	% Open the 'startup.m' file.
	fid = fopen(fullfile(upath, 'startup.m'), 'a+');
	% Check it.
	if fid < 0
		% Check how the function was called.
		if nargout > 0
			% Set failure flag and quit.
			ierr = 1;
			return
		else
			% Use an error message.
			error('set_plot:StartupM', ...
				'The ''startup.m'' file could not be opened.');
		end
	end
	
	% Add the two paths for set_plot.
	fprintf('Appending ''set_plot'' directories to ''startup.m''.\n');
	% Write the flags.
	fprintf(fid, '\n%%<set_plot>\n');
	fprintf(fid, '%% This portion was automatically written by the ');
	fprintf(fid, 'set_plot installer.\n');
	fprintf(fid, '%% Do not edit the portion between <set_plot> ');
	fprintf(fid, '</set_plot> tags.\n');
	fprintf(fid, '%% Written at %s\n', datestr(clock, 0));
	% Write a flag, but only for this architecture.
	fprintf(fid, '%% Checking architecture.\n');
	fprintf(fid, 'if strcmp(computer(), ''%s'')\n', computer());
	fprintf(fid, '\taddpath(''%s'')\n', sppath);
	fprintf(fid, '\taddpath(''%s'')\n', utilpath);
	fprintf(fid, 'end\n');
	% Write the closing flag and a blank line.
	fprintf(fid, '%%</set_plot>\n');
	
	% Close the file.
	fclose(fid);
    
    % Actually add the paths so that it can be used now.
    addpath(sppath)
    addpath(utilpath)
	
	% Set success flag.
	if nargout > 0, ierr = 0; end
	
	% Exit message
	fprintf('Done.\n');
	
catch err
	% Double-check the fid.
	fclose('all');
	% Check how the function was called.
	if nargout > 0
		ierr = 1;
		return
	else
		rethrow(err);
	end
end
