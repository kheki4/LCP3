function support_PlotGrandERADensity(ERAEventDensity_grand, Config, Meta)

    if Config.Plot.ERA.VisualMethod == 0 % kernel density estimation
        [ks_y, ks_x] = ksdensity(ERAEventDensity_grand, 'Bandwidth', Config.Plot.ERA.KDEBandwidth, 'Kernel', 'normal');

        % normalize ks density output
        ks_y = (ks_y - min(ks_y)) / ( max(ks_y) - min(ks_y) );

        plot(ks_x, ks_y, 'LineWidth', 2) %graphLineStyle
    else %if Config.Plot.ERA.VisualMethod == 1
        histogram(ERAEventDensity_grand, Config.Plot.ERA.HistBinWidth)
    end
    
    xlim([Config.AnalyzeFromSec*1000, Config.AnalyzeToSec*1000])
    pause(0.5)

end