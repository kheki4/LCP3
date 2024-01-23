function EventDensity = support_CalcERADensity(Samples, Blinks, Saccades, SearchBaseMask, TrigsForAlignment, Config)
    
%     % we allocate for the worst case, when all e.g. blinks can be
%     % fit onto the event-related curve
%     ERA_EventNum = length(blinks.startTs);
%     ERA_EventDensity = nan(ERA_EventNum,1); % column vector
    EventDensity = [];
        
    analyticLenUs = (Config.AnalyzeToSec-Config.AnalyzeFromSec)*1000*1000;
        
    % TODO: optimize computation
    for i = 1:length(TrigsForAlignment)
        if ~SearchBaseMask(i)
           continue
        end
            
        if ~Config.PerformTJC
            beginAtTs = TrigsForAlignment(i) + Config.AnalyzeFromSec*1000*1000;
            % beginAtSec = TrigsForAlignment(i)/1000/1000 + Config.AnalyzeFromSec;
        else
            beginAtTs = Samples.Ts(find(Samples.Ts >= TrigsForAlignment(i), 1, 'first')) + Config.AnalyzeFromSec*1000*1000;
            % beginAtSec = Samples.Ts(find(Samples.Ts >= TrigsForAlignment(i), 1, 'first'))/1000/1000 + Config.AnalyzeFromSec;
        end
            
        if Config.ERA.EventOfInterest == 0
            eventsTssUnderInterval = Blinks.StartTs(find(Blinks.StartTs >= beginAtTs & Blinks.StartTs < beginAtTs+analyticLenUs));
        elseif Config.ERA.EventOfInterest == 1
            eventsTssUnderInterval = Blinks.EndTs(find(Blinks.EndTs >= beginAtTs & Blinks.EndTs < beginAtTs+analyticLenUs));
        elseif Config.ERA.EventOfInterest == 2
            eventsTssUnderInterval = Saccades.StartTs(find(Saccades.StartTs >= beginAtTs & Saccades.StartTs < beginAtTs+analyticLenUs));
        elseif Config.ERA.EventOfInterest == 3
            eventsTssUnderInterval = Saccades.EndTs(find(Saccades.EndTs >= beginAtTs & Saccades.EndTs < beginAtTs+analyticLenUs));
        end
            
        % transform each event to a relative timepoint, counting from analyzeFrom timepoint, and in millisec
        % 0 is the beginning of analyzed period now
        eventsTssUnderInterval = (eventsTssUnderInterval-beginAtTs)/1000;
            
        % 0 is the trigger timepoint from now on (e.g. stimulus
        % presentation, or response)
        eventsTssUnderInterval = eventsTssUnderInterval + Config.AnalyzeFromSec*1000;
            
        if ~isempty(eventsTssUnderInterval)
           % append any blink start timestamps found under the analyzed
           % period (e.g. trial length)
           EventDensity = [EventDensity; eventsTssUnderInterval];
        end
    end

end
