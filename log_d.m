function log_d(str)

    global LOGLEVEL
    
    if LOGLEVEL >= 4
        disp(['Debug: ' str])
    end

end