function ExcludedMask = FiltSweepsOnSaccade(Saccades, SearchBaseMask, TrigsForAlignment, FilterConfig)

    ExcludedMask = false(length(TrigsForAlignment), 1);
    for i = 1:length(TrigsForAlignment)
        if ~SearchBaseMask(i)
            continue
        end

        if sum(Saccades.magnitude(i) >= FilterConfig.Magnitude & Saccades.startTs>=(TrigsForAlignment(i)+(FilterConfig.FromSec*1000*1000)) & Saccades.startTs<=(TrigsForAlignment(i)+(FiltConfig.ToSec*1000*1000))) > 0 || ...
            sum(Saccades.magnitude(i) >= FilterConfig.Magnitude & Saccades.endTs>=(TrigsForAlignment(i)+(FilterConfig.FromSec*1000*1000)) & Saccades.endTs<=(TrigsForAlignment(i)+(FiltConfig.ToSec*1000*1000))) > 0 || ...
            sum(Saccades.magnitude(i) >= FilterConfig.Magnitude & Saccades.startTs<(TrigsForAlignment(i)+(FilterConfig.FromSec*1000*1000)) & Saccades.endTs>(TrigsForAlignment(i)+(FiltConfig.ToSec*1000*1000))) > 0
            % NOTE: MICROSEC
            
            ExcludedMask(i) = true;
        end

        if ExcludedMask(i)
            log_d(['Excluded trial nr. ' num2str(i)]);
        end
    end
    
end