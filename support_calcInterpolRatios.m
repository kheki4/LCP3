function interpolRatios = support_calcInterpolRatios(ts, origSamplesTs, triggersForAlignment, srate, origSrate)

    % TODO: calculate with better precision, also considering original srate?

    interpolRatios = nan(length(triggersForAlignment),1);

    for v = 1:length(triggersForAlignment)

        % E.g. when we are making a response-aligned analysis, and the subject has no response in a trial (or in the next trial !)
        if isnan(triggersForAlignment(v)) || ...
            (v < length(triggersForAlignment) && isnan(triggersForAlignment(v+1)))
            interpolRatios(v) = NaN;
            continue;
        end


        actualFromSample = find(ts >= triggersForAlignment(v), 1, 'first');
        if length(actualFromSample) ~= 1
            actualFromSample = NaN
        end

        if v < length(triggersForAlignment)
            actualToSample = find(ts <= triggersForAlignment(v+1), 1, 'last');
            
            % invalid if the whole duration of this trial is before the
            % beginning of the recording
            if actualToSample == 1
                actualTosample = NaN;
            end
        else
            actualToSample = length(ts);
        end

% % %         actualFromSample
% % %         actualToSample
% % %         ~isnan(actualFromSample)
% % %         ~isnan(actualToSample)

        if ~isnan(actualFromSample) && ~isnan(actualToSample)
            actualLen = actualToSample - actualFromSample + 1;

            % IMPORTANT: we cannot beleive that the original timestamps and
            % samples vectors really contained all the needed samples

            if v < length(triggersForAlignment)
                theorLen = ceil( (triggersForAlignment(v+1) - triggersForAlignment(v) +1 ) / 1000 /1000 * srate );
            else
                theorLen = ceil( (origSamplesTs(end) - triggersForAlignment(v) +1 ) / 1000 /1000 * srate );
            end

            interpolRatios(v) = (1-(actualLen / theorLen)) *100;
            
        end
    end

%     check1 = length(ts) == find(ts >= triggersForAlignment(end), 1, 'last');

end