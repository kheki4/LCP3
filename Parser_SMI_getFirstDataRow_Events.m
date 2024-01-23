function startRow = Parser_SMI_getFirstDataRow_Events(filename)

    if exist(filename, 'file') ~= 2
         log_w('Error: Events.txt file does not exist here');
         startRow = NaN;
         return;
    end

    fid = fopen(filename, 'r');
    
    possibleEventNames = {'Fixation', 'Saccade', 'Blink', 'User Event'};
    eventNameLengthMax = max(strlength(possibleEventNames));
    
    %%
    linec = 1;
    lastLineWasComment = true;
    while(linec < 100 && lastLineWasComment == true)
        line = fgets(fid);
        if length(line) >= eventNameLengthMax && contains(line(1:eventNameLengthMax), possibleEventNames) == true
            break;
        end
        linec = linec + 1;
    end
    
    startRow = linec;
    
    fclose(fid);
    
end