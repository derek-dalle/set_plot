function ierr = sp_Uninstall
%SP_UNINSTALL Uninstall set_plot from path.
%
% CALL:
%    sp_Uninstall
%    ierr = sp_Uninstall
%
% INPUTS:
%    (None)
%
% OUTPUTS:
%    ierr : exit status, 0 if installation was successful
%           0 : success
%           1 : failed to save updated PATH
%           2 : could not find 'set_plot.m'
%
% This function uninstalls the "set_plot" package for MATLAB.  More
% specifically, it deletes commands to the 'startup.m' file that add the
% "set_plot" directories to your path when you start MATLAB.
%
% Any text between <set_plot> and </set_plot> tags in 'startup.m' will be
% deleted.
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
%  2013.10.08 @dalle   : First version


% Be very safe.
try
	% Introductory comment
	fprintf('Uninstalling ''set_plot'' using ''sp_Uninnstall''.\n');
	fprintf('This will clean up ''startup.m'' but not delete any files.\n');
	
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
	
	% Get the text from 'startup.m'.
	s_startup = fileread(fullfile(upath, 'startup.m'));
	% Split into lines.
	lines = regexp(s_startup, sprintf('\r?\n'), 'split');
	
	% Open the 'startup.m' and write from scratch.
	fid = fopen(fullfile(upath, 'startup.m'), 'w');
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
	
	% Initialize deletion flag.
	q_sp = false;
	
	% Loop through the lines.
	for i = 1:numel(lines)
		% Get the current line.
		l_cur = lines{i};
		% Check the line.
		if ~q_sp && strncmp(l_cur, '%<set_plot>', 11)
			% Set flag for 'set_plot' lines.
			q_sp = true;
		end
		% Write lines not between <set_plot> and </set_plot>
		if ~q_sp, fprintf(fid, '%s\n', l_cur); end
		% Check for end of <set_plot> tag.
		if ~q_sp && strncmp(l_cur, '%</set_plot>', 12)
			% Turn flag off.
			q_sp = false;
		end
	end
	
	% Close the file.
	fclose(fid);
	
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
