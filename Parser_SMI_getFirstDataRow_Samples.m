function startRow = Parser_SMI_getFirstDataRow_Samples(filename)
    
    fid = fopen(filename, 'r');
    
    %%
    linec = 1;
    lastLineWasComment = true;
    while(linec < 100 && lastLineWasComment == true)
        line = fgets(fid);
        if contains(line(1:2), '##') == false
            break;
        end
        linec = linec + 1;
    end
    % linec will now contain the nr of the line, where the table header is
    startRow = linec + 1; %next one is the first data row
    
    fclose(fid);
    
end