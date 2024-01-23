function [timestamp, tr, pupdil] = Parser_Other(filename, filterTrials)
    
    dataArray = readtable(filename); %(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', true);

    timestamp = str2double(dataArray{:,1});
    tr = ones(size(dataArray,1), 1);
    
%     if iscell(dataArray{newcoli_p})
%         dataArray(newcoli_p) = str2double(dataArray(newcoli_p));
%     end
    pupdil = str2double(dataArray{:,5});

    timestamp = timestamp.*1000;

end