function [trials, respTs] = support_createTriggerVecResp(stim_trial, stim_timestamp, behav_trial, behav_RT)

    if length(behav_RT) ~= length(stim_timestamp) || length(behav_trial) ~= length(stim_trial)
        log_e(['Behav_trial vector length is different than expected'])
    end

%     trials = nan(length(stim_trial),1);
    respTs = nan(length(stim_trial),1);

%     if length(respTs) > numStimuli || length(behav_trial) > numStimuli || min(behav_trial) < min(strim_trial) || max(behav_trial) > max(stim_trial)
%         log_e(['There are more responses than stimuli in the input, or behav response numbering outranges that of stimuli. We cannot unequivocally map response times to stimuli accordingly.'])
%     end
    % TODO: possibly subtract a number from all behav_trial numbers to let it start from e.g. 1, in case stim_trial starts from 1 ?

    for i = 1:length(stim_trial)
        respTs(i) = stim_timestamp(i) + behav_RT(i)*1000; % microsec

    end

    trials = stim_trial;

    % NOTE: NaNs (unanswered stimuli) are disregarded

    log_i('Mapped response times to stimuli.');

end