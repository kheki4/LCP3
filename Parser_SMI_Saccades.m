function [s_start, s_end, s_startX, s_startY, s_endX, s_endY, s_magnitude] = Parser_SMI_Saccades(filename, startRow)

    delimiter = '\t';

% % %     %formatSpec = '%s%f%f%f%f%f%*s%[^\n\r]'; %   *s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%
%     formatSpec = '%s%f%f%f%f%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
    formatSpec = '%s%f%f%f%f%f%f%f%f%f%f%*s%*s%*s%*s%*s%*s%[^\n\r]';
    
    fileID = fopen(filename,'r');
    %Todo: check, hogy minden sort beolvas-e
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'CommentStyle','UserEvent', 'ReturnOnError', false);
    fclose(fileID);

%   Table Header for Saccades:
%   Event Type	Trial	  Number	Start	  End	  Duration ....stb

    %TODO: logikai indexeléssel is talán meg lehetne oldani
    mask = false(size(dataArray{1},1));
    for i=1:size(dataArray{1},1)
        if (strcmp(char(dataArray{1}(i)),'Saccade L'))
            mask(i) = true; %TODO: logical
        end
        
    end
    
    %b_num = dataArray{3}(mask);
    s_start = dataArray{4}(mask);
    s_end = dataArray{5}(mask);
    %b_duration = dataArray{6}(mask);


    s_startX = dataArray{7}(mask);
    s_startY = dataArray{8}(mask);
    s_endX = dataArray{9}(mask);
    s_endY = dataArray{10}(mask);
    s_magnitude = dataArray{11}(mask);

end