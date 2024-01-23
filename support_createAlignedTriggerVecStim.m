function [trials, stimTs] = support_createAlignedTriggerVecStim(stim_trial, stim_timestamp, filterTrials, everyWhich)

%     numTriggers = ceil((filterTrials(2) - filterTrials(1)) /everyWhich + 1);
    numTriggers = ceil((filterTrials(2) - filterTrials(1) + 1) /everyWhich);
    trials = nan(numTriggers,1);
    stimTs = nan(numTriggers,1);

    c = 1;
    for i = 1:length(stim_timestamp)

%         % failsafe
%         lastReadableStartTimestamp = stim_timestamp(i);
%         lastTrialNrCandidate = c-1;

        if stim_trial(i) >= filterTrials(1) && mod(stim_trial(i)-filterTrials(1), everyWhich) == 0
            if isnan(stim_timestamp(i))
                stimTs(c) = NaN;
            else
                stimTs(c) = stim_timestamp(i);
            end
            trials(c) = c; % TODO: remove?
            c = c+1;
        end
    end

    if isnan(trials(end))
        log_w(['We could not safely assign a trial number to the end of meaningful-trials section.' newline() 'This is likely because the number of trials to align and renumber is not divisible by the everyWhich parameter specified.' newline() 'Using a dummy value now.'])
        stimTs(end) = stimTs(c-1);
        trials(end) = c-1;
    end
    
    interStimIntervals = zeros(1); % failsafe
    for i = 1:(length(stimTs)-1)
        interStimIntervals(i) = stimTs(i+1) - stimTs(i);
%         log_d(['Length of renumbered trial nr. ' num2str(trials(i)) ' in seconds: ' num2str(interStimIntervals(i)/1000/1000)]);
    end

    log_i(['Mean inter-stimulus-interval in seconds: ' num2str(mean(interStimIntervals, 'omitnan')/1000/1000)]);
    log_i(['SD of inter-stimulus-interval in seconds: ' num2str(std(interStimIntervals, 'omitnan')/1000/1000)]);

    log_d(['Trial vector realigned to start from first relevant trial trigger, with respect to everyWhich param:']);
    log_d(['   Original numbering: ' sprintf('\t') '[' num2str(stim_trial(1)) ' ' num2str(stim_trial(end)) ']']);
    log_d(['   FilterTrials: ' sprintf('\t\t') '[' num2str(filterTrials(1)) ' ' num2str(filterTrials(2)) ']']);
    log_d(['   Realigned: ' sprintf('\t\t\t') '[' num2str(trials(1)) ' ' num2str(trials(end)) ']']);

end