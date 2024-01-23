function [timestamp, pupdil, trig_trial, trig_trial_ts, blinks_start, blinks_end, saccades_start, saccades_end] = Parser_EyeLink(filename)
    
%     lettersOnly = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    numbersOnly = '0123456789';

    fileID = fopen(filename,'r');
    % NOTE: fgetl is used (this will strip newline from the end of the lines) because
    % textscan will behave unreliably when newline is left at lines end, even if newline is specified as eol character
    % However, it will work fine when ther is no newline in the input. See this workaround below
    tline = fgetl(fileID); 
    cMSG = 1;
    % e.g. EBLINK -> E means END OF BLINK... only end events are necessary, as they also contain start timestamps
    cEBLINK = 1;
    cEFIX = 1;
    cESACC = 1;
    while ~feof(fileID)
        if startsWith(tline,'MSG') && contains(tline,'TRIAL')
%             usefulData{elemCounter} = tline;
            usefulDataMSG{cMSG} = strrep(tline,'TRIAL ','');
            cMSG=cMSG+1;

        elseif startsWith(tline,'EBLINK L') 
            % means END OF BLINK
            % LEFT ONLY
            usefulDataEBLINK{cEBLINK} = tline;
            cEBLINK=cEBLINK+1;

        elseif startsWith(tline,'EFIX L') 
            % LEFT EYE ONLY
            % NOTE: newline() is added as a workaround because textscan gets jammed DIFFERENTLY when the last field is a number, 
            % as opposed to the case when it is a string ('.....' in our case)
            usefulDataEFIX{cEFIX} = append(tline, newline());
            cEFIX=cEFIX+1;
            
        elseif startsWith(tline,'ESACC L') 
            % LEFT EYE ONLY
            % NOTE: newline() is added as a workaround because textscan gets jammed DIFFERENTLY when the last field is a number, 
            % as opposed to the case when it is a string ('.....' in our case)
            usefulDataESACC{cESACC} = append(tline, newline());
            cESACC=cESACC+1;
            
        end
        tline = fgetl(fileID);
    end
    fclose(fileID);

    % beleive me this is WAY FASTER than dynamic allocation with string append
    % NOTE: workaround: for whatever reason, here concatenation will put newlines after each elem, thats why we use fgetl above 

    
    % --------------------------------------------------
    % CONVERTING TO ARRAYS
    % TRIAL INCREMENT EVENTS

    textData = char(horzcat(usefulDataMSG{:}));
    formatSpec = '%s%f%f';
    dataArray = textscan(textData, formatSpec, 'Headerlines', 0, 'EndOfLine', newline(), 'Delimiter', sprintf('\t'));

    trig_trial_ts = dataArray{:,2}.*1000; % stick to microsec
    trig_trial = dataArray{:,3};
    clear usefulDataMSG dataArray;


    % --------------------------------------------------
    % CONVERTING TO ARRAYS
    % BLINKS

    textData = char(horzcat(usefulDataEBLINK{:}));
    formatSpec = '%s%f%f';
    dataArray = textscan(textData, formatSpec, 'Headerlines', 0, 'EndOfLine', newline(), 'Delimiter', sprintf('\t'));

    % NOTE: we need this workaround, because in the asc file format, in case of blink end events, the start timestamp is 
    % somehow not preceded by a tabulator delimiter, but instead ONE SPACE
    spaghetti = dataArray{:,1};
    % NOTE: extractAfter SHOULD return the substring after the last occurence of the pattern (whitespace in our case) 
    % according to docs, but guess what: it does not. For an input like 'EBLINK L 9473914' it will return 'L 9473914'
    % So we are now using ONLY THE LEFT EYE NOW
    blinks_start = str2double(arrayfun(@(x) extractAfter(char(x),'L '),spaghetti,'un',0)).*1000; % microsec
    blinks_end = dataArray{:,2}.*1000; % microsec
    clear usefulDataEBLINK dataArray;


    % --------------------------------------------------
    % CONVERTING TO ARRAYS
    % FIXATIONS

    textData = char(horzcat(usefulDataEFIX{:}));
%     formatSpec = '%s%f%f%s';
    formatSpec = '%s%f%f%f%f%f%f'; % 1 string + 6 numeric fields
    dataArray = textscan(textData, formatSpec, 'Headerlines', 0, 'EndOfLine', sprintf('\r\n'), 'Delimiter', sprintf('\t'));

    % NOTE: we need this workaround, because in the asc file format, in case of fixation end events, the start timestamp is 
    % somehow not preceded by a tabulator delimiter, but instead THREE SPACES
    spaghetti = dataArray{:,1};
    % NOTE: extractAfter SHOULD return the substring after the last occurence of the pattern (whitespace in our case) 
    % according to docs, but guess what: it does not. For an input like 'EFIX L 9473914' it will return 'L 9473914'
    % So we are now using ONLY THE LEFT EYE NOW
    fixations_start = str2double(arrayfun(@(x) extractAfter(char(x),'L   '),spaghetti,'un',0)).*1000; % microsec
    fixations_end = dataArray{:,2}.*1000;
    % fixations_dur = dataArray{:,3};
    % fixations_xpos = dataArray{:,4};
    % fixations_ypos = dataArray{:,5};
    % TODO: add gaze vector or coordinate, etc
    clear usefulDataEFIX dataArray;


    % --------------------------------------------------
    % CONVERTING TO ARRAYS
    % SACCADES

    textData = char(horzcat(usefulDataESACC{:}));
    formatSpec = '%s%f%f%f%f%f%f%f%f%f'; % 1 string + 9 numeric fields
    dataArray = textscan(textData, formatSpec, 'Headerlines', 0, 'EndOfLine', newline(), 'Delimiter', sprintf('\t'));

    % NOTE: we need this workaround, because in the asc file format, in case of fixation end events, the start timestamp is 
    % somehow not preceded by a tabulator delimiter, but instead TWO SPACES
    spaghetti = dataArray{:,1};
    % NOTE: extractAfter SHOULD return the substring after the last occurence of the pattern (whitespace in our case) 
    % according to docs, but guess what: it does not. For an input like 'EFIX L 9473914' it will return 'L 9473914'
    % So we are now using ONLY THE LEFT EYE NOW
    saccades_start = str2double(arrayfun(@(x) extractAfter(char(x),'L  '),spaghetti,'un',0)).*1000; % microsec
%     saccades_start = dataArray{:,2}.*1000;
    saccades_end = dataArray{:,2}.*1000;
    clear usefulDataESACC dataArray;
    

    % --------------------------------------------------
    % retrieve numeric data: timestamps and pupil diameter

    fileID = fopen(filename,'r');
    tline = fgets(fileID); % fgets keeps newline characters
    elemCounter = 1;
    while ~feof(fileID)
%         if ~isempty(tline) && ~contains(lettersOnly,tline(1))
        if ~isempty(tline) && contains(numbersOnly,tline(1))
            usefulData{elemCounter} = tline;
%             usefulData{elemCounter} = strrep(tline,tabChar,newDelimChar);
%             usefulData{elemCounter} = strrep(strtrim(tline),tabChar,newDelimChar);
            elemCounter=elemCounter+1;
        end
        tline = fgets(fileID); % fgets keep newline characters
    end

    fclose(fileID);

    textData = char(horzcat(usefulData{:}));

%     HeaderFmt = '%s%s%s';
    DataFmt = '%f%s';
%     DataFmt = char(['%f%s%[^' sprintf('\t') ']']); % results in undefined behavior
%     DataFmt = '%f%s%[^0123456789.]'; % doesnt work either, even though it should

    % The line below SHOULD NOT work, however, it does (it is a workaround)
    % Textscan will not return meaningful array when used with tab as delimiter (which is the actual delimiter)
    % But (against any sane logic) it does work when delimiter is the comma character
    % Matlab R2022a
    dataArray = textscan(textData, DataFmt, 'Headerlines', 0, 'EndOfLine', newline(), 'Delimiter', sprintf(','));

    % test = arrayfun(@(x) extractBefore(x,' '),pupdil)

    % the asc format will contain a DOT CHARACTER where there was no reliable eye readout, so all numeric fields must be read as string first, and
    % then parsed
    timestamp = dataArray{:,1};

    spaghetti = dataArray{:,2};
    pupdil = str2double(arrayfun(@(x) extractBefore(x,sprintf('\t')),spaghetti));
    clear usefulData dataArray;

end