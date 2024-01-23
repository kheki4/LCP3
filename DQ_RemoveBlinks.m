function [p_timestamp, p_pupdil] = DQ_RemoveBlinks(timestamp, pupdil, b_start, b_end, cut_back, cut_forward)

    % [ms] to [microsec]
    cut_back = cut_back *1000;
    cut_forward = cut_forward *1000;

    b_index = 1;
    j = 1;
    while (j < size(timestamp,1) +1) && b_index < size(b_start,1)
        if b_start(b_index)-cut_back < timestamp(j) && b_end(b_index)+cut_forward > timestamp(j)
            timestamp(j) = NaN;
            pupdil(j) = NaN;
        end
        if b_end(b_index) < timestamp(j)
            b_index = b_index+1;
        end
        j = j+1;
    end
  
  mask = ~isnan(timestamp);
  
  p_timestamp = timestamp(mask);
  p_pupdil = pupdil(mask);
  
end
