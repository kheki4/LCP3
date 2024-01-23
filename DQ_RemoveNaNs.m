function [p_timestamp, p_pupdil] = DQ_RemoveNaNs(timestamp, pupdil)

    if isnan(timestamp(1))
        disp('Warning: The first element of timestamp array is NaN, which is removed now.');
    end
    
    mask = and(~isnan(timestamp), ~isnan(pupdil));

    p_timestamp = timestamp(mask);
    p_pupdil = pupdil(mask);
    
end