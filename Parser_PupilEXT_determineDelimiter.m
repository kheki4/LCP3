function delimiter = Parser_PupilEXT_determineDelimiter(filename)

    lineToInspect = 2;
    possibleDelimiters = { sprintf('\t') sprintf(',') sprintf(';') };
    possibleDelimiterCounts = [ 0 0 0 ];

    fileID = fopen(filename,'r');

    for i=1:lineToInspect
        tline = fgetl(fileID);
    end

    for i=1:length(possibleDelimiters)
        possibleDelimiterCounts(i) = sum(count(tline, possibleDelimiters{i}));
    end

    delimiter = possibleDelimiters{find(possibleDelimiterCounts, max(possibleDelimiterCounts))};

    fclose(fileID);

end