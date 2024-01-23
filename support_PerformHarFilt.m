function Pupdil = support_PerformHarFilt(Config, Samples)

    log_i(['Filtering for frequency bands']);
    if size(Config.HarFilt.TargetFreqRanges, 1) == 1
        bandToFilter = [Config.HarFilt.TargetFreqRanges(1,1)    Config.HarFilt.TargetFreqRanges(1,2)];
%         Samples.Pupdil = bandpass(Samples.Pupdil, bandToFilter, Samples.SRate);
        Hd = f_chebyshev(bandToFilter(1), bandToFilter(2), Samples.SRate, 2000, 'bandpass');
        Pupdil = filtfilt(Hd.Numerator, 1, Samples.Pupdil);

        log_i(['Applied passband filter for base frequency only: ' num2str(bandToFilter(1)) '-' num2str(bandToFilter(2)) 'Hz']);
    else
        for fic = 1:(size(Config.HarFilt.TargetFreqRanges, 1)-1) % 1. koordinĂˇta = sor index
            bandToFilter = [Config.HarFilt.TargetFreqRanges(fic,2)    Config.HarFilt.TargetFreqRanges(fic+1,1)];
            Pupdil = bandstop(Samples.Pupdil, bandToFilter, Samples.SRate);
% % %             Hd = f_chebyshev(bandToFilter(1), bandToFilter(2), Samples.SRate, 1000, 'stop');
%             method = 'stop';
%             order = 500;            % Order
%             flag = 'scale';         % Sampling Flag
%             SidelobeAtten = 50;      % Window Parameter
%             win = chebwin(order+1, SidelobeAtten);
%             b  = fir1(order, bandToFilter/(Samples.SRate/2), method, win, flag);
%             Hd = dfilt.dffir(b);
%             Samples.Pupdil = filtfilt(Hd.Numerator, 1, Samples.Pupdil);

            log_i(['Applied stopband filter: ' num2str(fic) ' / ' num2str((size(Config.HarFilt.TargetFreqRanges, 1)-1)) ]);
        end
        bandToFilter = [Config.HarFilt.TargetFreqRanges(1,1)    Config.HarFilt.TargetFreqRanges(size(Config.HarFilt.TargetFreqRanges, 1), 2)];
        Pupdil = bandpass(Samples.Pupdil, bandToFilter, Samples.SRate);
            
%         Samples.Pupdil = highpass(Samples.Pupdil, bandToFilter(1), Samples.SRate);
%         Samples.Pupdil = lowpass(Samples.Pupdil, bandToFilter(2), Samples.SRate);
            
% % %         Hd = f_chebyshev(bandToFilter(1), bandToFilter(2), Samples.SRate, 1000, 'bandpass');
%         method = 'bandpass';
%         order = 500;            % Order
%         flag = 'scale';         % Sampling Flag
%         SidelobeAtten = 50;      % Window Parameter
%         win = chebwin(order+1, SidelobeAtten);
%         b  = fir1(order, bandToFilter/(Samples.SRate/2), method, win, flag);
%         Hd = dfilt.dffir(b);
%         Samples.Pupdil = filtfilt(Hd.Numerator, 1, Samples.Pupdil);
 
        log_i(['Applied passband filter as finish']);
    end
    log_i(['Done :)']);

end