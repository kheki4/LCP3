
FLAG_GRANDCALC = true;

if exist('eventRelatedAmpEq1', 'var')
    eventRelatedAmpEq1_lastRun = min(eventRelatedAmpEq1);
end

if exist('eventRelatedAmpEq2', 'var')
    eventRelatedAmpEq2_lastRun = floor(mean(eventRelatedAmpEq2));
end

% % eventRelatedAmpEq1(1,pp_id) = sum(~isnan(mean(trials_array_cond1, 1, 'omitnan')),'omitnan');
% % eventRelatedAmpEq2(1,pp_id) = sum(~isnan(mean(trials_array_cond2, 1, 'omitnan')),'omitnan');
