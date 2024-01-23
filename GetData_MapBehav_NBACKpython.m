function Behav = GetData_MapBehav_NBACKpython(Config, participantName)

%     Config.BehavDir = '~RT/NBACK_eye ver1 s1';
    
    numTrials = ceil((Config.FilterTrials(2) - Config.FilterTrials(1) + 1 ) / Config.EveryWhichTrial);
    disp(['numtrials @ behav mapping = ' num2str(numTrials)]);
    
    cn_RT = 'key_resp_2.rt';
    cn_key = 'key_resp_2.keys';
%     cn_corr = 'key_resp_3.corr';
    cn_tt = 'nback';

    participantID_behav = extractBefore( extractAfter(participantName, '_'), '_');

    % --------------------------------------------------
    
    dfn = dir( [Config.BehavDir, '/', participantID_behav, '*.csv'] );
    listFound = {dfn.name};
    csvFile = char(listFound(1)); % TODO: warn user if there is more
    clearvars dfn listFound;

    opts = detectImportOptions([Config.BehavDir '/' char(csvFile)]);
    opts.VariableNamesLine = 1;
    opts.PreserveVariableNames = true;
%     opts.VariableNamingRule = 'preserve';
    T = readtable([Config.BehavDir '/' csvFile], opts);

    % detect column indices, because it can vary from subject to subject
    ci_RT = find(strcmp(T.Properties.VariableNames, cn_RT), 1); 
    ci_key = find(strcmp(T.Properties.VariableNames, cn_key), 1); 
%     ci_corr = find(strcmp(T_test.Properties.VariableNames, cn_corr), 1); 
    ci_tt = find(strcmp(T.Properties.VariableNames, cn_tt), 1); %trial type
    
%     for hc = 1:length(ci_key)
% %         ci_corr = find(strcmp(T_test.Properties.VariableNames, cn_corr), 1); 
%     end
    
    % get data out of the braces psychopy put them in (when multiple key
    % responses are allowed)
    ic = 1;
    for hc = 1:numTrials
%         ci_corr = find(strcmp(T_test.Properties.VariableNames, cn_corr), 1);
        temp_cellarr = T{(hc+1), ci_RT}; 
        temp_str = temp_cellarr{1};
        if ~isempty(temp_str)
            temp_str2 = extractBetween(temp_str,2,length(temp_str)-1);
            Behav.RT(ic, 1) = str2double(temp_str2) * 1000; % to millisec
        else
            Behav.RT(ic, 1) = NaN;
        end
            
        ic=ic+1;
    end
        
%     Behav.RT = T{2:(numTrials+1), ci_RT};
    Behav.StimType = T{2:(numTrials+1), ci_tt}; % ez kivételesen egyszerű, 0 vagy 1
        
        
%     Behav.RespType = T{2:(numTrials+1), ci_key};
    ic = 1;
    for hc = 1:numTrials
%         ci_corr = find(strcmp(T_test.Properties.VariableNames, cn_corr), 1);
        temp_cellarr = T{(hc+1), ci_key}; 
        temp_str = temp_cellarr{1}; 
        if ~strcmp(temp_str,'None') && length(temp_str)>1
            
            multiAnswSeparatorIndices = strfind(temp_str,'''');
            temp_str2 = extractBetween(temp_str, multiAnswSeparatorIndices(1)+1,multiAnswSeparatorIndices(2)-1);
            
            Behav.RespType(ic, 1) = temp_str2;
        else
            Behav.RespType(ic, 1) = cellstr(temp_str); % string to cell, erre jó a cellstr()
        end
            
        ic=ic+1;
    end
%         Behav.RespVerid = T{2:(numTrials+1), ci_corr};

    ic = 1;
    for hc = 1:numTrials
        if (Behav.StimType(hc) == 1 && strcmp(Behav.RespType(hc), 'up')) || ...
                (Behav.StimType(hc) == 0 && strcmp(Behav.RespType(hc), 'down'))
            Behav.RespVerid(ic, 1) = 1; % true
        else
            Behav.RespVerid(ic, 1) = 0; % false
        end
        ic=ic+1;
    end

    Behav.Trial = transpose(1:numTrials); 
    
end