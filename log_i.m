function log_i(str)
    
    global LOGLEVEL
    
    if LOGLEVEL >= 2
        disp(['Info: ' str])
    end

%     disp(['Info: ' str])
end