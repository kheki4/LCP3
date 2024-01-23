function [coli_ts, coli_tr, coli_p, coli_c, coli_oc, startRow] = Parser_PupilEXT_getHeaderColNrs(filename, colNamesToGet, delimiter)
    
    % DEV TODO

%     delimiter = sprintf(';'); %'\t';
%     delimiter = sprintf(','); 

    
    fid = fopen(filename, 'r');
    
    tableHeader = fgets(fid);
    startRow = 2;
    
    %%
    % {timestamp, trial, pupdil} ebben a sorrendben, mértékegység nélkül! tehát [] jelek nem lehetnek benne
    colNumbers = [0 0 0 0 0]; 
    charc = 1;
    cidn = 1;
    while(cidn <= length(colNumbers) && charc < length(tableHeader))
        foundIdx = cell2mat(regexp(tableHeader, colNamesToGet(cidn), 'once', 'ignorecase'));
        %colNumbersToGet(cidn) = length(regexp(tableHeader(1:foundIdx), delimiter)) + 1;
        colNumbers(cidn) = count(tableHeader(1:foundIdx), delimiter) + 1;
        cidn = cidn + 1;
    end
    % colNumbersToGet will now contain the numbers (indexes) of columns that contain timestamp, trial and pupdil respectively
    
    fclose(fid);
    
    coli_ts = colNumbers(1);
    coli_tr = colNumbers(2);
    coli_p = colNumbers(3);
    coli_c = colNumbers(4);
    coli_oc = colNumbers(5);
    % egyszerûbb lenne máshogy, de jó ez így, hogy látszik a fgv deklarálásából, hogy melyik változó micsoda
    
end