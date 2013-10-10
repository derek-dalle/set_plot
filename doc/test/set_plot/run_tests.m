function run_tests
%
% run_tests
%
% This function runs all of the tests in the current folder, in sequence.
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
%  2013-10-10 @dalle   : First version


% Get the appropriately named .m files in the current folder.
d = dir('test_*.m');

% Loop through them.
for i = 1:numel(d)
    % Get test name.
    fn = d(i).name(1:end-2);
    % Print the name of the test.
    fprintf('Running test: %s\n    ', fn);
    % Run the test.
    try
        feval(fn);
    catch err
        fprintf('Test failed with message:\n%s\n', err.message);
    end
end
