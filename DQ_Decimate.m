function [p_timestamp, p_pupdil, srate] = DQ_Decimate(timestamp, pupdil, orig_srate, factor)

    new_numPoints = ceil(length(timestamp)/factor);

    p_timestamp = transpose(linspace(min(timestamp), max(timestamp), new_numPoints));
    
    p_pupdil = decimate(pupdil, factor); 
    %p_pupdil = decimate(pupdil, factor, 8);
    %p_pupdil = decimate(pupdil, factor, 8, 'fir');
    
    srate = orig_srate/factor;
end