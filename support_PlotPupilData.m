function support_PlotPupilData(PlotMode, Samples)

    if PlotMode == 1
        fftIn = Samples.Pupdil-mean(Samples.Pupdil); 
        
        spect_full = abs(fft(fftIn));
        spect_full = spect_full/(length(fftIn)/2);
        spect_full = spect_full(1:floor(length(spect_full)/2));

    %     freq_points = (1:(length(Samples.Pupdil)/2))*(Samples.SRate/length(Samples.Pupdil)); % HIBĂ?T OKOZ, ELCSĂšSZĂ?ST
        freq_points = (0:(length(fftIn)/2)-1)*(Samples.SRate/length(fftIn));

        plot(freq_points , spect_full)

        freq_lim = [0 1];
        xlim(freq_lim)
        xticks(linspace(freq_lim(1), freq_lim(2), 11));

        disp(freq_points(spect_full==max(spect_full)))

        xlabel('Frequency [Hz]')
        ylabel('Amplitude [px]')

        set(gcf, 'Position', get(0, 'Screensize') * 0.6);
        hold on

    elseif PlotMode == 2
        xvec = Samples.Ts-Samples.Ts(1);
        yvec = Samples.Pupdil-mean(Samples.Pupdil);
        plot(xvec, yvec)
        
        xlabel('Time [-]')
        ylabel('Pupil Size [px]')

        set(gcf, 'Position', get(0, 'Screensize') * 0.6);
        hold on
    end

end