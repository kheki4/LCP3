function T = support_findBlinkDelta(b_trial, b_start, b_end)

    %format longG;
    
    deltat_start = zeros(length(b_start), 1);
    deltat_end = zeros(length(b_start), 1);
    deltat_middle = zeros(length(b_start), 1);
    deltat_between = zeros(length(b_start), 1);

    deltat_start(1) = NaN;
    deltat_end(1) = NaN;
    deltat_middle(1) = NaN;
    deltat_between(1) = NaN;
    
    if length(b_start) < 2
        return;
    end
    
    b_middle = zeros(length(b_start), 1);
    for z = 1:length(b_start)
        b_middle(z) = round((b_end(z) + b_start(z))/2);
    end
    
    for p = 2:length(b_start)
        deltat_start(p) = b_start(p) - b_start(p-1);
        deltat_end(p) = b_end(p) - b_end(p-1);
        deltat_middle(p) = b_middle(p) - b_middle(p-1);
        deltat_between(p) = b_start(p) - b_end(p-1);
    end
    
    deltat_start = deltat_start./1000./1000;
    deltat_end = deltat_end./1000./1000;
    deltat_middle = deltat_middle./1000./1000;
    deltat_between = deltat_between./1000./1000;
    %ts_rel_sec = round((ts_abs-timestamp(1))./1000./1000, 3);
    
    b_duration = (b_end-b_start)./1000;
    
    T = table(b_start, b_end, b_trial, b_duration, deltat_start, deltat_end, deltat_middle, deltat_between);
    header={'Start', 'End', 'Trial', 'Duration [ms]', 'Δt start [sec]', 'Δt end [sec]', 'Δt middle [sec]', 'Δt between [sec]'};
    T.Properties.VariableNames = header;
    %disp(T);

end