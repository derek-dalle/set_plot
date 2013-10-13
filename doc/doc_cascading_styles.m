function doc_cascading_styles
% DOC_CASCADING_STYLES  Document set_plot cascading style options
%
% CALL:
%    doc_cascading_styles
%
% This function writes the full chart for the cascading styles based on the
% contents of of the 'set_plot>help_cascading_styles' MATLAB documentation.
% It converts it to a table to be produced in a form useful to Sphinx.
%


% Versions:
%  2013-10-11 @dalle   : First version


% Be safe.
try
    % Get the text of the help file.
    s = help('set_plot>help_cascading_styles');
    
    % Split into lines.
    lines = strtrim(regexp(s, '\n', 'split'));
    
    % Open the file.
    fid = fopen('cascading_styles.rst', 'w');
catch err
    % Setup failed.
    fprintf(2, 'Setup failed:\n   %s\n', err.message);
    return
end

% Be safe with the file.
try
    % Write some metadata.
    fprintf(fid, '..\n');
    fprintf(fid, '    This is an automatically generated file. Do not edit it.\n');
    fprintf(fid, '    To change its contents, see ''doc_cascading_stiles.m''.\n');
    fprintf(fid, '\n    Written on %s\n', datestr(date, 29));
    fprintf(fid, '\n\n');
    
    % Make a label.
    fprintf(fid, '.. _cascading-styles:\n\n');
    
    % Write the headings.
    fprintf(fid, 'Cascading Style Chart\n');
    fprintf(fid, '---------------------\n');
    
    % Introductory text.
    fprintf(fid, '\nThe following lists all cascading styles and the values\n');
    fprintf(fid, 'that the parent and child format keys take.\n\n');
    
    % Number of parent keys found.
    nParent = 0;
    % Bars...
    bar1 = pnchar('-', 17);
    bar2 = pnchar('-', 47);
    bar3 = pnchar('-', 23);
    bar4 = pnchar('-', 23);
    bar5 = pnchar('=', 17);
    bar6 = pnchar('=', 23);
    bar7 = pnchar('=', 23);
    % Loop through the lines.
    for i = 1:numel(lines);
        % Get the line
        line = lines{i};
        % Try to find a parent.  (e.g. '<strong>FigureStyle</strong>')
        n = regexp(line, '<strong>(?<parent>\w+)</strong>', 'names');
        % Check if any were found.
        if numel(n) == 1
            % Check the Parent count.
            if nParent > 0
               % Print the bottom of the previous table.
               fprintf(fid, '%8s+%s+%s+%s+\n', '', bar1, bar3, bar4);
            end
            % Increase the parent number.
            nParent = nParent + 1;
            % Reset value count.
            nValue = 0;
            nChild = 1;
            % Print the headings.
            fprintf(fid, '\n    **%s**\n', n.parent);
            % Table headings.
            fprintf(fid, '%8s+%s+%s+\n', '', bar1, bar2);
            fprintf(fid, '%8s| %-15s | %-45s |\n', '', 'Value', 'Child');
            fprintf(fid, '%8s+%s+%s+%s+\n', '',bar5, bar6, bar7);
            continue
        elseif nParent == 0
            % Don't even read the line.
            continue
        end
        % Check for a parent value. (e.g. '''pretty''')
        n = regexp(line, '^[''\w]+$');
        % Check if one was found.
        if numel(n) == 1
            % Check Value count.
            if nValue > 0
                % Print the tabile formatting for the previous value.
                fprintf(fid, '%8s+%s+%s+%s+\n', '', bar1, bar3, bar4);
            end
            % Increase the value count.
            nValue = nValue + 1;
            % Reset the child count.
            nChild = 0;
            % Print the value.
            fprintf(fid, '%8s| %-15s ', '', ['``',line,'``']);
            continue
        end
        % Check for a child. (e.g. 'AspectRatio   -> ''auto''')
        n = regexp(line, '(?<key>\w+)\s*->\s*(?<value>.*$)', 'names');
        % Cehck if one was found.
        if numel(n) == 1
            % Check the Child count.
            if nChild > 0
                % Print the table formatting for the previous line.
                fprintf(fid, '%8s|%17s+%s+%s+\n', '', '', bar3, bar4);
                % Print the beginning of the line.
                fprintf(fid, '%8s|%17s', '', '');
            end
            % Print the name/value pair.
            fprintf(fid, '| %-21s | %-21s |\n', n.key, ['``',n.value,'``']);
            
            % Increase the child count.
            nChild = nChild + 1;
        end
    end
    
    % Print the bottom of the last table.
    fprintf(fid, '%8s+%s+%s+%s+\n', '', bar1, bar3, bar4);
    
catch err
    % Write failed.
    fprintf(2, 'Write failed:\n   %s\n', err.message);
    % Close the file.
    fclose(fid);
    return
end

% Close the file.
try
    fclose(fid);
catch err
    fprintf(2, 'Failed to close file:\n    %s\n', err.messae);
end


% --- SUBFUNCTION: Create string of N chars ---
function s = pnchar(c, n)
%PNCHAR Repeat a char n times
%
% CALL:
%    s = pnchar(c, n)
%
% INPUTS:
%    c : single character
%    n : number of times to print character.
%
% OUTPUTS:
%    s : character repeated ``n`` times
%
% This function takes a single character and repeats it ``n`` times.  The
% input must be a char with exactly one character.
%


% String to give to sprintf to produce n spaces.
t = sprintf('%%%is', n);

% Make a string of n spaces.
s = sprintf(t, '');

% Replace the spaces with the character.
s = strrep(s, ' ', c);
    