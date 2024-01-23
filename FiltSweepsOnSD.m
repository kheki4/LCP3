function ExcludedMask = FiltSweepsOnSD(TrialsArray, SearchBaseMask, FilterConfig)

    ExcludedMask = false(length(TrigsForAlignment), 1);
    for i = 1:length(TrigsForAlignment)
        if ~SearchBaseMask(i)
            continue
        end

        if std(TrialsArray(:,i), 'omitnan') > FilterConfig.LocalLimit
            ExcludedMask(i) = true;
        end

        if ExcludedMask(i)
            log_d(['Excluded trial nr. ' num2str(i)]);
        end
    end

end