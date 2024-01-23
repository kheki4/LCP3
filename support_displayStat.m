function support_displayStat(datavec)

    disp('--------------------------------------------------');

    disp( ['N = ' num2str( length(datavec) ) ] );
    disp( ['min = ' num2str( min(datavec) ) ] );
    disp( ['max = ' num2str( max(datavec) ) ] );
    disp( ['M = ' num2str( mean(datavec, 'omitnan') ) ] );
    disp( ['SD = ' num2str( std(datavec, 'omitnan') ) ] );
    disp( ['Q1, Q2, Q3 = ' num2str( quantile(datavec, [0.25 0.50 0.75]) ) ] );
    
    IQR = abs(quantile(datavec, 0.25) - quantile(datavec, 0.75));
    disp( ['IQR = ' num2str( IQR ) ] );
    
    SEM = std(datavec, 'omitnan')/sqrt(length(datavec));
    ts = tinv([0.025  0.975],length(datavec)-1); % T-Score
    CI = mean(datavec, 'omitnan') + ts*SEM;
    disp( ['CI lower = ' num2str(CI(1)) ] );
    disp( ['CI upper = ' num2str(CI(2)) ] );
    
    w = 1.5;
    disp( ['Lower whisker = ' num2str( quantile(datavec,0.25)-w*IQR ) ] );
    disp( ['Upper whisker = ' num2str( quantile(datavec,0.75)+w*IQR ) ] );

end