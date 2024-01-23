function paramValue = Parser_SMI_getParamValue(filename, paramName)
    %paramName = 'Sample Rate';
    bufSize = 150;
    
    data = fileread(filename);
    
    param_idx = regexp(data, ['## ', paramName, ':'], 'once', 'ignorecase') + length(paramName) + 5; %strfind(data,
    if(isempty(param_idx))
        paramValue = NaN;
        return;
    end
    param_lineChunk = data(param_idx:(param_idx+bufSize));
    
    %param_lineChunk
    
    % nem képes arra hogy a {'\n' ' '} elemeinek bármelyikének legelső előfordulását kiírja, 
    % hanem helyette visszaad egy cella tömböt, aminek két eleme van, az első az első regexp 
    % keresési string első megtalálási helyét, a második a másodikét tárolja, ezeket double-é 
    % kell alakítani, ami eltűnteni az esetleges üres cell elemeket is, és azok minimumát veszi
    %param_lineChunk_EOLidx = min(cell2mat(regexp(param_lineChunk, {'\n' ' '}, 'once')))-length('\n'); 
    
    
    param_lineChunk_EOLidx = regexp(param_lineChunk, '\n', 'once')-length('\n');
    param_lineChunk_SPACEidx = regexp(param_lineChunk, ' ', 'once')-1;
    
    %param_lineChunk_EOLidx
    %param_lineChunk_SPACEidx
    
    possibilities = [param_lineChunk_EOLidx param_lineChunk_SPACEidx];
    possibilities = possibilities(isnumeric(possibilities));
    
    cutEnd = min(possibilities);
    
    %cutEnd
    
    if(isempty(param_idx))
        paramValue = NaN;
        return;
    end
    paramValue = param_lineChunk(1:cutEnd);
end