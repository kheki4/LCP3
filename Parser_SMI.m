function [timestamp, pupdil, conf, uniq_tr_fixed, ts_abs, b_start, b_end, s_start, s_end, s_startX, s_startY, s_endX, s_endY, s_magnitude] = Parser_SMI(directory, participantName, PXorMM)

    if PXorMM
        colNamesToGet = {'Time', 'Trial', 'L Dia X', 'Pupil Confidence'};
    else
        colNamesToGet = {'Time', 'Trial', 'L Mapped Diameter', 'Pupil Confidence'};
    end
    filename = strcat(directory, '/', participantName,' Samples.txt'); 
    [coli_ts, coli_tr, coli_p, coli_conf, startRow] = Parser_SMI_getHeaderColNrs(filename, colNamesToGet);


    % --------------------------------------------------
    % SAMPLES

    delimiter = '\t';
    
    %tornyos (MST) => 1,3,4
    %remote (baseline, REV LEARN EXP1, testing effect) => 1,3,6
    %remote (REV LEARN EXP2a-b) => 1,3,10
    coli = [coli_ts coli_tr coli_p];
    
    if coli_conf~=0
        coli(length(coli)+1) = coli_conf;
    end
    
    %make the formatSpec parameter for textscan() automatically
    formatSpec = num2str(zeros(1, max(coli)+1), '%i');
    formatSpec(coli) = '1';
    formatSpec = strrep(formatSpec, '1', '%f');
    formatSpec = strrep(formatSpec, '0', '%*s');
    formatSpec = strcat(formatSpec, '%[^\n\r]');
    %TODO: find the column indices(of textscan output) that correspond to the requested columns(of textscan input)
    newcoli_ts = 1; %coli(coli==coli_ts)
    newcoli_tr = 2; %coli(coli==coli_tr)
    newcoli_p = 3; %coli(coli==coli_p)
    
    newcoli_conf = 4;
    
    
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'CommentStyle','#', 'ReturnOnError', true);
    fclose(fileID);
    
    % sometimes the last line is not read, and columns will have different
    % length, we check them here accordingly, and leave only full rows
    lengths = [length(dataArray{newcoli_ts}) length(dataArray{newcoli_tr}) length(dataArray{newcoli_p})];
    timestamp = dataArray{newcoli_ts}(1:min(lengths));
    trial = dataArray{newcoli_tr}(1:min(lengths));
    pupdil = dataArray{newcoli_p}(1:min(lengths));
    
    if coli_conf~=0 
        conf = dataArray{newcoli_conf}(1:min(lengths));
    else
%         conf = ones(1,min(lengths));
        conf = NaN;
    end
    % NOTE: SMI gives only 0 or 1 on pupil confidence output, no float value at all


    % --------------------------------------------------
    % TRIALS BASED ON SAMPLES

    uniq_tr = unique(trial);
%     ts_abs = zeros(length(uniq_tr), 1); % can cause discrepancies when there is a hopped trial number
    ts_abs = zeros(max(uniq_tr), 1);

    if length(uniq_tr) ~= max(uniq_tr)
        log_w('At least one trial is missing (hopped over) in the eye data file. This is worked around in the current version of SMI txt file reader by adding tiny dummy trials to keep the trial-switch event numbering the same')
%         return;
    end

    if length(timestamp) < 10
        error('The length of this recording is less than 10 samples. Please check your data')
%         return;
    end
    
    ts_abs(1) = timestamp(1);
    tr_prev = trial(1);
    % workaround for cases when trials are hopped: they will have the same timestamp as the last known
    changeC = 2;
    iterC = 1;
    while(iterC < length(timestamp)) %% && changeC < 10)
        tr_curr = trial(iterC);

        if tr_curr ~= tr_prev && tr_curr > tr_prev+1
            fillN = tr_curr-tr_prev-1;
            for nb = 1:fillN
                ts_abs(changeC) = timestamp(iterC) +nb; % add a very tiny bit to make timestamps different
                changeC = changeC + 1;
            end
%             iterC = iterC + 1;
%             tr_prev = tr_curr;
        end

        if tr_curr > tr_prev % actually equals this case: tr_curr = tr_prev+1
            ts_abs(changeC) = timestamp(iterC);
            changeC = changeC + 1;
        end
        iterC = iterC + 1;
        tr_prev = tr_curr;
    end

    % also we need to fix the quniq_tr vector
    uniq_tr_fixed = 1:max(uniq_tr);

    
    % --------------------------------------------------
    % BLINKS AND SACCADES

    % TODO: FIXATIONS?
    % TODO: NO TRIAL VEC
    b_start= NaN;
    b_end = NaN;
    s_start= NaN;
    s_end = NaN;
    s_startX = NaN;
    s_startY = NaN;
    s_endX = NaN; 
    s_endY = NaN;
    s_magnitude = NaN;
    filename = strcat(directory, '/', participantName,' Events.txt');
    startRow = Parser_SMI_getFirstDataRow_Events(filename);
    if ~isnan(startRow)
        [b_start, b_end] = Parser_SMI_Blinks(filename, startRow);
        [s_start, s_end, s_startX, s_startY, s_endX, s_endY, s_magnitude] = Parser_SMI_Saccades(filename, startRow);
    else
        log_w('Could not find or open Events.txt for this subject. Blink filtering will not be done, saccades and fixations will not be saved accordingly.')
    end
    
end