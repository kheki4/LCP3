function [coli_ts, coli_tr, coli_p, coli_conf, startRow] = Parser_SMI_getHeaderColNrs(filename, colNamesToGet)
    delimiter = sprintf('\t'); %'\t';
    
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
    tableHeader = line; % Matlab copies the content (no need of c++ strcpy)
    
    startRow = linec + 1;
    
    %%
    % {timestamp, trial, pupdil} ebben a sorrendben, mértékegység nélkül! tehát [] jelek nem lehetnek benne
    colNumbers = [0 0 0 0]; 
    charc = 1;
    cidn = 1;
    while(cidn <= length(colNumbers) && charc < length(tableHeader))
        
        foundIdx = cell2mat(regexp(tableHeader, colNamesToGet(cidn), 'once', 'ignorecase'));
        
        if isempty(foundIdx) || isnan(foundIdx) || (~isempty(foundIdx) && isnan(foundIdx) && (foundIdx==0 || isnan(foundIdx)))
            log_w(['Could not find confidence values calumn for this SMI data file']);
%             colNumbers(cidn) = NaN;
        else
            %colNumbersToGet(cidn) = length(regexp(tableHeader(1:foundIdx), delimiter)) + 1;
            colNumbers(cidn) = count(tableHeader(1:foundIdx), delimiter) + 1;
        end
        
        cidn = cidn + 1;
    end
    % colNumbersToGet will now contain the numbers (indexes) of columns that contain timestamp, trial and pupdil respectively
    
    fclose(fid);
    
    coli_ts = colNumbers(1);
    coli_tr = colNumbers(2);
    coli_p = colNumbers(3);
    coli_conf = colNumbers(4);
    % egyszerûbb lenne máshogy, de jó ez így, hogy látszik a fgv deklarálásából, hogy melyik változó micsoda
    
end