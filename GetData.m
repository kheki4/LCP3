function [ETData] = GetData(Directory, ParticipantName, ETDataFormat, PXorMM)
    
    % TODO: map fixations ?
    % TODO: discard fixations shorter than 100ms ?

    ETData.QualityValues.Conf = NaN;
    ETData.QualityValues.OutlineConf = NaN;
    ETData.samples.Conf = NaN;
    ETData.samples.OutlineConf = NaN;

    if(strcmp(ETDataFormat, 'SMI'))
        [ETData.Samples.Ts, ETData.Samples.Pupdil, ETData.Samples.QualityValues.Conf, ETData.Triggers.Trial, ETData.Triggers.Ts, ETData.Blinks.Start, ETData.Blinks.End, ETData.Saccades.Start, ETData.Saccades.End, ETData.Saccades.StartX, ETData.Saccades.StartY, ETData.Saccades.EndX, ETData.Saccades.EndY, ETData.Saccades.Magnitude] = Parser_SMI(Directory, ParticipantName, PXorMM);
    elseif(strcmp(ETDataFormat, 'PupilEXT'))
        [ETData.Samples.Ts, ETData.Samples.Pupdil, ETData.Samples.QualityValues.Conf, ETData.Samples.QualityValues.OutlineConf, ETData.Triggers.Trial, ETData.Triggers.Ts, ETData.Blinks.Start, ETData.Blinks.End, ETData.Saccades.Start, ETData.Saccades.End, ETData.Saccades.StartX, ETData.Saccades.StartY, ETData.Saccades.EndX, ETData.Saccades.EndY, ETData.Saccades.Magnitude] = Parser_PupilEXT(Directory, ParticipantName, PXorMM);
    elseif(strcmp(ETDataFormat, 'EyeLink'))
        Filename = strcat(Directory, '/', ParticipantName,'.asc'); 
%         [coli_ts, coli_tr, coli_p, coli_c, coli_oc, StartRow] = support_EyeLink_GetHeaderColNrs(filename, colNamesToGet);
        [ETData.Samples.Ts, ETData.Samples.Pupdil, ETData.Triggers.Trial, ETData.Triggers.Ts, ETData.Blinks.Start, ETData.Blinks.End, ETData.Saccades.Start, ETData.Saccades.End, ETData.Saccades.StartX, ETData.Saccades.StartY, ETData.Saccades.EndX, ETData.Saccades.EndY, ETData.Saccades.Magnitude] = Parser_EyeLink(Filename);
    elseif(strcmp(ETDataFormat, 'Tobii'))
        % TODO
        log_e('Not yet supported');
    elseif(strcmp(ETDataFormat, 'Other'))
        Filename = strcat(Directory, '/', ParticipantName,'.xlsx');
        [ETData.Samples.Ts, ETData.Samples.Pupdil] = Parser_Other(Filename, FilterTrials);
    end
    
end