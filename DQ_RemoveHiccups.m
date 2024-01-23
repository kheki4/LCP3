function [p_timestamp, p_pupdil] = DQ_RemoveHiccups(timestamp, pupdil, watchedStepWindow, signifRange)

    mask = ~isnan(timestamp);    
%     DEBUG_counter = 0;
  
    j = watchedStepWindow +1;
    while j < size(timestamp,1) +1
        movingRange = range(pupdil((j-watchedStepWindow):j)); % TODO: what if NaN
        
        if movingRange > signifRange
            index_atFoundHiccup = j;
            movingRange_inHiccup = 10000; 
            
            seekIndex = index_atFoundHiccup;
            while (seekIndex < size(timestamp,1)) && ( pupdil(seekIndex) > 0) && movingRange_inHiccup > signifRange 
                movingRange_inHiccup = range(pupdil((seekIndex-watchedStepWindow):seekIndex));
                seekIndex = seekIndex+1;
            end
            index_atEndOfHiccup = seekIndex; 
            
            index_setNaN = index_atFoundHiccup; 
            while (index_setNaN < size(timestamp,1)) && index_setNaN < index_atEndOfHiccup
%                 DEBUG_counter = DEBUG_counter + 1;
                mask(index_setNaN) = false;
                index_setNaN = index_setNaN+1;
            end
        end
        j = j+1;
    end
  
%     disp(DEBUG_counter);
%     disp( sum(isnan(pupdil)) );
  
    p_timestamp = timestamp(mask);
    p_pupdil = pupdil(mask);
    
end
