function log_w(str)

    global LOGLEVEL
    
    if LOGLEVEL >= 3
%         warning(['Warning: ' str])
        warning([str])
    end

%     warning(['Warning: ' str])
end