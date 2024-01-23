function Participants = support_FindParticipantsByFiles(Config, LookupDir, FileNameEnding)

    dfn = dir(char([LookupDir '/*' FileNameEnding]));
    Participants = regexprep({dfn.name}, FileNameEnding, '', 'once');
    if length(Participants) < 1
        log_e(['The directory you specified does not contain any data file with this ending: ' FileNameEnding ' Do you have your eyetracker data format set correctly?']);
    end
    Participants(ismember(Participants, 'Metafile')) = []; 
    log_i('Automatically detected participant names in the order of processing:')
    disp(Participants');
    clearvars dfn;

    % TODO: less C-like?
    if isfield(Config, 'SkipParticipants') && length(Config.SkipParticipants) ~= 1
        for skp = 1:length(Config.SkipParticipants)
            acp = 1;
            while acp <= length(Participants)
                if strcmp(Config.SkipParticipants(skp), Participants(acp))
                    Participants(acp) = []; % delete the cell entry (because participants{acp} = []; would only change that cell to an empty one
                end
                acp = acp + 1;
            end
        end
    end

end