function T = support_filterBlinkDelta(T)

%     T = table(b_start, b_end, b_trial, b_duration, deltat_start, deltat_end, deltat_middle, deltat_between);
%     header={'Start', 'End', 'Trial', 'Duration [ms]', 'Δt start [sec]', 'Δt end [sec]', 'Δt middle [sec]', 'Δt between [sec]'};
%     

    %mask = zeros(size(T,1), 1);
    mask = (T{:,4}>1000);
    T{mask,4} = NaN;
    
    mask = (T{:,5}>10);
    T{mask,5} = NaN;
    
    mask = (T{:,6}>10);
    T{mask,6} = NaN;
    
    mask = (T{:,7}>10);
    T{mask,7} = NaN;
    
    mask = (T{:,8}>10);
    T{mask,8} = NaN;
    

end