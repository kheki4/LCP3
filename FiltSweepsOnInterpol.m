function ExcludedMask = FiltSweepsOnInterpol(Samples, SearchBaseMask, TrigsForAlignment, FilterConfig)

    ExcludedMask = false(length(TrigsForAlignment), 1);
    InterpolRatios = support_calcInterpolRatios(Samples.Ts, Samples.OrigSamplesTs, TrigsForAlignment, Samples.SRate, Samples.OrigSRate);
        
    for i = 1:length(TrigsForAlignment)
        if ~SearchBaseMask(i)
            continue
        end

        if InterpolRatios(i) > FilterConfig.Threshold
            ExcludedMask(i) = true;
        end

        if ExcludedMask(i)
            log_d(['Excluded trial nr. ' num2str(i)]);
        end
    end

end