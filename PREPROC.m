clear; % clear environment variables
clc; % clear command window
format compact; % show terminal output in shorter version
format long; % show numbers normally, not scientific notation

global LOGLEVEL
% LOGLEVEL = 1; % nothing
% LOGLEVEL = 2; % info only
% LOGLEVEL = 3; % info and warning too
LOGLEVEL = 4; % info, warning and debug too

% DEVMODE = true;
DEVMODE = false;

% --------------------------------------------------
% CONFIG

% Defaults, must come here
CONFIG_PREPROC_DEFAULTS

% Config for the actual experiment (may be custom)
CONFIG_PREPROC_NBACK

% --------------------------------------------------
% PREPARE VARIABLES

Meta.NomSRate = NaN;
Meta.FilterTrials = [NaN NaN];

Meta.ISISec = ISISec;
Meta.StimOnScreenSec = StimOnScreenSec;

Meta.RootDirTag = [strrep(Config.ExpDirName,' ','_')];
Meta.CfPrefix = regexprep(Config.ExpDirName,'[^a-zA-Z0-9_\s]','');

if Config.HarFilt.Enabled
    Meta.RootDirTag = [Meta.RootDirTag '_BASE+' num2str(Config.HarFilt.NumAddHarmonics) 'HAR'];
else
    Meta.RootDirTag = [Meta.RootDirTag '_DQ'];
end

if Config.PXorMM
    Meta.RootDirTag = [Meta.RootDirTag '_PX'];
else
    Meta.RootDirTag = [Meta.RootDirTag '_MM'];
end

% ADDITIONAL
% Meta.RootDirTag = [Meta.RootDirTag '_NOGOLAY'];
% Meta.RootDirTag = [Meta.RootDirTag '_MUTUAL'];
% Meta.RootDirTag = [Meta.RootDirTag '_FAST'];

Meta.RootDirTag = [Meta.RootDirTag '_' Config.ETDataFormat];
disp(['Using eye tracker data format: ' Config.ETDataFormat]);
Config = support_DefineETDataSpecs(Config);
Participants = support_FindParticipantsByFiles(Config, ['~RAWDATA/' Config.ETDeviceDirName '/*' Config.ExpDirName], Config.ETDataFileNameEnding);

if DEVMODE
    Meta.RootDirTag = [Meta.RootDirTag '_DEV'];
    disp('RUNNING IN DEVELOPER MODE');
end

Meta.Flag_spectFiltered = Config.HarFilt.Enabled;
Meta.Flag_Config.PXorMM = Config.PXorMM;
Meta.Flag_BehavMapped = Config.MapBehav;
Meta.PreprocVersion = 0.006;
Meta.DataStructureVersion = 0.002;

log_i(['Meta.Flag_spectFiltered = ' num2str(Meta.Flag_spectFiltered)]);
log_i(['Meta.Flag_Config.PXorMM = ' num2str(Meta.Flag_Config.PXorMM)]);
log_i(['Meta.Flag_BehavMapped = ' num2str(Meta.Flag_BehavMapped)]);
log_i(['Meta.PreprocVersion = ' num2str(Meta.PreprocVersion)]);

% Preallocating vectors
MeanInterpolRatio = nan(length(Participants), 1);

% Generates (target*harmonics)+-delta freq intervals, to be filtered later
interval_base = [ Config.HarFilt.BaseFreq-Config.HarFilt.FreqRadius Config.HarFilt.BaseFreq+Config.HarFilt.FreqRadius ];
%
Config.HarFilt.TargetFreqRanges = [interval_base];
for(fcs = 2:(Config.HarFilt.NumAddHarmonics+1))
    interval_har = [ (fcs*Config.HarFilt.BaseFreq)-Config.HarFilt.FreqRadius (fcs*Config.HarFilt.BaseFreq)+Config.HarFilt.FreqRadius ];
    Config.HarFilt.TargetFreqRanges = [Config.HarFilt.TargetFreqRanges ; interval_har];
end
clearvars interval_base interval_har;

% --------------------------------------------------
% PROCESS AND SAVE

for ppnr = 1:length(Participants)
    
    Participant.ID = Participants{ppnr};
    Participant.Nr = ppnr;
    
    disp('--------------------------------------------------');
    log_i(['Currently processing ' char(Participants(ppnr)) ' at index ' num2str(ppnr)]);
    
    Samples = struct();
    Behav = struct();
    Blinks = struct();
    Saccades = struct();
    Triggers = struct();
    
    if(strcmp(Config.ETDataFormat, 'SMI'))
        Samples.SRate = str2double(Parser_SMI_getParamValue(strcat(['~RAWDATA/' Config.ETDeviceDirName '/' Config.ExpDirName], '/', char(Participants(ppnr)), Config.ETDataFileNameEnding), 'Sample Rate'));
    elseif(strcmp(Config.ETDataFormat, 'PupilEXT'))
        Samples.SRate = 50; % TODO: not hardcoded
    elseif(strcmp(Config.ETDataFormat, 'EyeLink'))
        Samples.SRate = 1000; % TODO: not hardcoded
    elseif(strcmp(Config.ETDataFormat, 'Other'))
        Samples.SRate = 500;
    end
    Samples.OrigSRate = Samples.SRate;
    log_i(['Sample Rate in eye data file: ' num2str(Samples.SRate)]);

    % TODO: check srate so that every input recording has the same srate
    
    % Config.FilterTrialsG check
    clear Config.FilterTrials;
    if size(Config.FilterTrialsG, 1) > 1
        for fts = 1:size(Config.FilterTrialsG, 1)
            if strcmp( Config.FilterTrialsG{fts,1},char(Participants(ppnr)) )
                Config.FilterTrials = Config.FilterTrialsG{fts,2};
                break
            end
        end
        if ~isfield(Config,'FilterTrials')
            if(strcmp(Config.ETDataFormat, 'Other'))
                log_w(['Config.FilterTrials set for dummy [1 1] as device is specified as Other, now at participant ' char(Participants(ppnr))]);
                Config.FilterTrials =  [1 1];
            else
                log_e(['Config.FilterTrials not specified for participant ' char(Participants(ppnr))]);
            end
        end
        log_i(['Filtering trials of each participant separately.']);
    else
        log_e(['Please check Config.FilterTrialsG in script configuration']);
    end

    if ~isnan(SkipFirstNtrials) && isnumeric(SkipFirstNtrials) && SkipFirstNtrials>0
        log_w(['Skipping first ' num2str(SkipFirstNtrials) ' trials']);
        Config.FilterTrials(1) = Config.FilterTrials(1) + SkipFirstNtrials;
    end

    ETData = GetData(['~RAWDATA/' Config.ETDeviceDirName '/' Config.ExpDirName], char(Participants(ppnr)), Config.ETDataFormat, Config.PXorMM);
    Samples.Ts = ETData.Samples.Ts;
    Samples.Pupdil = ETData.Samples.Pupdil;
    Samples.QualityValues = ETData.Samples.QualityValues;
    Blinks.StartTs = ETData.Blinks.Start;
    Blinks.EndTs = ETData.Blinks.End;
    Saccades.StartTs = ETData.Saccades.Start;
    Saccades.EndTs = ETData.Saccades.End;
    Saccades.StartX = ETData.Saccades.StartX;
    Saccades.StartY = ETData.Saccades.StartY;
    Saccades.EndX = ETData.Saccades.EndX;
    Saccades.EndY = ETData.Saccades.EndY;
    Saccades.Magnitude = ETData.Saccades.Magnitude;
%     qualityValues = ETData.QualityValues;
    % NOTE: "end" is a keyword of Matlab language, need to avoid it

    % PERFORM TRIGGER "NUMBERING ALIGNMENT", based on Config.FilterTrials and everyWhich, on ONLY the trigger timestamp vector! 
    % So we only KEEP the needed trigger timestamps, that is the "renumbering" step
    [Triggers.Stim.Trial, Triggers.Stim.Ts] = support_createAlignedTriggerVecStim(ETData.Triggers.Trial, ETData.Triggers.Ts, Config.FilterTrials, Config.EveryWhichTrial);


    Samples.OrigRecLenSec = (Samples.Ts(length(Samples.Ts))-Samples.Ts(1))/1000/1000;
    log_i(['Length of recording to be processed in seconds: ' num2str( (Samples.Ts(length(Samples.Ts))-Samples.Ts(1))/1000/1000 )]);
    
    if DEVMODE && ~isnan(Config.ManShiftMs) && isnumeric(Config.ManShiftMs) && Config.ManShiftMs~=0
        log_w('MANUALLY SHIFTED STIMULUS TIMESTAMPS');
        Triggers.Stim.Ts = Triggers.Stim.Ts + Config.ManShiftMs*1000;
    end
    
    % --------------------------------------------------
    % MAP BEHAV DATA
    
    if Config.MapBehav
        if size(Config.FilterTrials, 1) == 1
            clear(Config.BehavParserFunction);
            Behav = feval(Config.BehavParserFunction, Config, Participant.ID);
        else
            log_e(['Please check Config.FilterTrials in script configuration']);
        end
    end
    
    if Config.MapBehav
        [Triggers.Resp.Trial, Triggers.Resp.Ts] = support_createTriggerVecResp(Triggers.Stim.Trial, Triggers.Stim.Ts, Behav.Trial, Behav.RT);
        
        if DEVMODE && ~isnan(Config.ManShiftMs) && isnumeric(Config.ManShiftMs) && Config.ManShiftMs~=0
            log_w('MANUALLY SHIFTED RESPONSE TIMESTAMPS');
            Triggers.Resp.Ts = Triggers.Resp.Ts + Config.ManShiftMs*1000;
        end
    end
    
    % --------------------------------------------------
    % DATA QUALITY SECTION

    if(strcmp(Config.ETDataFormat, 'PupilEXT'))
        log_i(['Rejecting Samples upon pupil detection confidence criteria: ']);
        log_i([sprintf('\t') 'Confidence < ' num2str( confidenceThreshold )]);
        log_i([sprintf('\t') 'Outline Confidence < ' num2str( outlineConfidenceThreshold )]);
        [Samples.Ts, Samples.Pupdil] = DQ_RemoveSamplesByConfidence(Samples.Ts, Samples.Pupdil, Samples.QualityValues.Conf, Samples.QualityValues.OutlineConf, confidenceThreshold, outlineConfidenceThreshold);
    end
    
    [Samples.Ts, Samples.Pupdil] = DQ_RemoveNaNs(Samples.Ts, Samples.Pupdil);
    [Samples.Ts, Samples.Pupdil] = DQ_RemoveZeros(Samples.Ts, Samples.Pupdil, 0, 0);
    if sum(isnan(Blinks.StartTs)) == 0 && sum(isnan(Blinks.EndTs)) == 0
        [Samples.Ts, Samples.Pupdil] = DQ_RemoveBlinks(Samples.Ts, Samples.Pupdil, Blinks.StartTs, Blinks.EndTs, 0, 0);
    end
    
    if(strcmp(Config.ETDataFormat, 'PupilEXT'))
        log_i(['Removing hiccups']);
        [Samples.Ts, Samples.Pupdil] = DQ_RemoveHiccups(Samples.Ts, Samples.Pupdil, floor(Samples.SRate/4), 10);
    end
    
    
    % DEV TEST, 2023.10.30
    %{
    if(strcmp(Config.ETDataFormat, 'PupilEXT'))
        log_i(['(DEV) Removing extreme values']);
        refy = mode(Samples.Pupdil);
        devlimsd = 3;
        mask2 = Samples.Pupdil > refy + devlimsd*std(Samples.Pupdil,'omitnan');
        mask3 = Samples.Pupdil < refy - devlimsd*std(Samples.Pupdil,'omitnan');
        markedToRemove = mask2 | mask3;
        Samples.Pupdil = Samples.Pupdil(~markedToRemove);
        Samples.Ts = Samples.Ts(~markedToRemove);
    end
    
    if(strcmp(Config.ETDataFormat, 'PupilEXT'))
        log_i(['(DEV) Lowpass filtering to remove noise']);
        Samples.Pupdil = lowpass(Samples.Pupdil, 3, Samples.SRate); 
    end
    %}
    
    [Samples.interpol_ratio] = DQ_CalcInterpLossAnalogWhole(Samples.Ts, Samples.SRate, Triggers.Stim.Trial, Triggers.Stim.Ts, ISISec);
    MeanInterpolRatio(ppnr, 1) = Samples.interpol_ratio;

    % ANALOG VERSION
    % There is no "interpolation ratio" generated here, but it is generated
    % on-demand, if needed for event-related processing
    % That is why we have stored the timestamps of ground truth Samples used
    % for interpolation in this vector:
    Samples.OrigSamplesTs = Samples.Ts;
    
    [Samples.Ts, Samples.Pupdil, Samples.SRate] = DQ_Resample(Samples.Ts, Samples.Pupdil, Samples.SRate);
    
    if PerformGolayFiltering && ~isnan(GolayWinSizeFactor) && isnumeric(GolayWinSizeFactor) && GolayWinSizeFactor>0
        golay_winlen = floor(Samples.SRate*GolayWinSizeFactor);
        if mod(golay_winlen, 2) == 0
            golay_winlen = golay_winlen + 1;
        end
        Samples.Pupdil = sgolayfilt(Samples.Pupdil, 5, golay_winlen); % 3, 11
    end

    % TODO: why here?
    [Samples.Ts, Samples.Pupdil, Samples.SRate] = DQ_Resample(Samples.Ts, Samples.Pupdil, Config.OutputNomSRate);
    
    log_i(['Sample Rate after decimation in data quality step: ' num2str(Samples.SRate)]);
    log_i(['Length of recording in seconds, after data quality step: ' num2str( (Samples.Ts(length(Samples.Ts))-Samples.Ts(1))/1000/1000 )]);
    
    if isnan(Meta.NomSRate)
        log_i(['No predefined nominal sampling rate was defined for metafile. Using the one first found. Namely ' num2str(Samples.SRate)]);
        Meta.NomSRate = round(Samples.SRate);
    else
        log_i(['Nominal sampling rate is already defined.']);
        if round(Meta.NomSRate) == round(Samples.SRate)
            log_i(['    Current eye data file complies with it.']);
        else
            log_e(['    Current eye data file does not comply with it.']);
        end
    end

    % ANALOG VERSION
    % There is no "interpolation ratio" generated here, but it is generated
    % on-demand, if needed for event-related processing
    % That is why we have stored the timestamps of ground truth Samples used
    % for interpolation

    Config.FilterTrialsRenum = Config.FilterTrials;
%     [Samples.Trial] = renumberTrials(Samples.Trial, Config.FilterTrials, Config.EveryWhichTrial);
    Config.FilterTrialsRenum(2) = ceil((Config.FilterTrialsRenum(2)-Config.FilterTrialsRenum(1) + 1)/Config.EveryWhichTrial);
    Config.FilterTrialsRenum(1) = 1;
    Config.FilterTrials_original = Config.FilterTrials;
    if sum(isnan(Meta.FilterTrials)) > 0
        Meta.FilterTrials = Config.FilterTrialsRenum;
        log_d(['Re-setting Meta.FilterTrials']);
    end
    if Meta.FilterTrials(1) ~= Config.FilterTrialsRenum(1) || Meta.FilterTrials(2) ~= Config.FilterTrialsRenum(2)
        log_e(['Current and defined common meta (renumbered and aligned) Config.FilterTrials do not match.']);
    end

    % --------------------------------------------------
    % CHECKS (TODO)
    % ...
        
    % --------------------------------------------------
    % PLOTTING 1 (DEV, only for debug, not saved as image files)
    if Config.PlotPupil.Enabled 
        support_PlotPupilData(Config.PlotPupil.Mode, Samples);
    end

    % --------------------------------------------------
    % PERFORM SPECTRAL FILTERING
        
    if Config.HarFilt.Enabled
        Samples.Pupdil = support_PerformHarFilt(Config, Samples);
    end
    
    % --------------------------------------------------
    % PLOTTING 2 (DEV, only for debug, not saved as image files)
    
    % TODO: not simple before-after show figure, but plot them on one plot,
    % and also save them in needed
    if Config.PlotPupil.Enabled 
        support_PlotPupilData(Config.PlotPupil.Mode, Samples);
    end
    
    % --------------------------------------------------
    % SAVING SPECIFIC .mat FILES
    
    OutFilePath = ['~PREPDATA/' Meta.RootDirTag '/'];
    if ~exist(OutFilePath, 'dir')
        mkdir(OutFilePath);
    end
    outFileName = char(Participants(ppnr));
    
    % TODO: wipe folder contents if folder exists already

    % save them as v7 .mat files so that SciPy can open them if needed
    save([OutFilePath outFileName '.mat'], 'Samples', 'Behav', 'Blinks', 'Saccades', 'Triggers', '-v7');
    % NOTE: it can happen that behav data (resp type, stim type, etc) are
    % not saved as strings. We need conversion in this case. Take care
    
    clearvars Samples Behav Blinks Saccades Triggers;
end

% --------------------------------------------------
% SAVING COMMON METAFILE

OutFilePath = ['~PREPDATA/' Meta.RootDirTag '/'];
if ~exist(OutFilePath, 'dir')
    mkdir(OutFilePath);
end
outFileName = 'Metafile';
save([OutFilePath outFileName '.mat'], '-struct', 'Meta' );

% --------------------------------------------------
% SAVING SUMMARY STATISTICS

col_participants = transpose([{ [Meta.CfPrefix '_' 'Participant'] }  Participants]);
cols_sub_vals = cell(length(Participants)+1, 1);
cols_sub_vals(1, 1) = { [Meta.CfPrefix '_' 'Recording interpolation percentage [%]']};
cols_sub_vals(2:length(Participants)+1, 1) = num2cell(MeanInterpolRatio*100);
outputMatrix = [col_participants cols_sub_vals];
OutFilePath = ['~RESULTS/' Meta.RootDirTag '/'];
if ~exist(OutFilePath, 'dir')
    mkdir(OutFilePath);
end
outFileName = [ Meta.CfPrefix '_' 'Preproc interpolation percentages' ];

writecell(outputMatrix,[OutFilePath outFileName '.csv'],'Delimiter',';');

