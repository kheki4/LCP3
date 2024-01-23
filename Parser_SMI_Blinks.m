function [b_start, b_end] = Parser_SMI_Blinks(filename, startRow)

    delimiter = '\t';

    %formatSpec = '%s%f%f%f%f%f%*s%[^\n\r]'; %   *s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%
    formatSpec = '%s%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
    
    fileID = fopen(filename,'r');
    %Todo: check, hogy minden sort beolvas-e
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'CommentStyle','UserEvent', 'ReturnOnError', false);
    fclose(fileID);

%   Table Header for Blinks:
%   Event Type	Trial	  Number	Start	  End	  Duration

    %TODO: logikai indexeléssel is talán meg lehetne oldani
    mask = false(size(dataArray{1},1));
    for i=1:size(dataArray{1},1)
        if (strcmp(char(dataArray{1}(i)),'Blink L'))
            mask(i) = true; %TODO: logical
        end
        
    end
    
    %b_num = dataArray{3}(mask);
    b_start = dataArray{4}(mask);
    b_end = dataArray{5}(mask);
    %b_duration = dataArray{6}(mask);
end