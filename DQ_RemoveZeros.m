function [p_timestamp, p_pupdil] = DQ_RemoveZeros(timestamp, pupdil, cut_back, cut_forward)

    % [ms] to [microsec]
    cut_back = cut_back *1000; 
    cut_forward = cut_forward *1000;
    
    mask = true(size(timestamp));
    
    j = 2;
    while j <= length(timestamp)
        if pupdil(j) == 0 && pupdil(j-1) ~= 0
            
            % zero-section begins, we cut back
            timestamp_atTarget = timestamp(j);
            seekBi = j;
            while seekBi > 1 && timestamp_atTarget - timestamp(seekBi) < cut_back
                seekBi = seekBi-1;
            end
            mask(j:seekBi) = false;
        
            % during zero-section, we cut
            while j < length(timestamp) && pupdil(j+1) == 0
                j = j + 1;
                mask(j) = false;
            end
            
            % end of zero-section, we cut forward
            timestamp_atTarget = timestamp(j);
            seekFi = j;
            while seekFi < length(timestamp) && timestamp_atTarget + timestamp(seekFi) < cut_forward
                seekFi = seekFi+1;
            end
            mask(j:seekFi) = false;
            
        end
        j = j+1;
    end
  
    p_timestamp = timestamp(mask);
    p_pupdil = pupdil(mask);
    
end
