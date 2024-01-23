
ISISec = NaN;
StimOnScreenSec = NaN;
Config.ExpDirName = '*';
PerformGolayFiltering = false;

Config.ETDataFormat = 'SMI';
% Config.ETDataFormat = 'PupilEXT'; 
% Config.ETDataFormat = 'EyeLink';
% Config.ETDataFormat = 'Other';

% PupilEXT NOTE: ALWAYS USE THE SAME ALGORITHM FOR ONE ANALYSIS. CONFIDENCE CAN DIFFER

% Config.PXorMM = true;
Config.PXorMM = false;

% GolayWinSizeFactor = 1.5; % Too flat
GolayWinSizeFactor = 0.8;
% GolayWinSizeFactor = 0.3; % DEV

% Config.HarFilt.Enabled = true;
Config.HarFilt.Enabled = false;

% PupilEXT specific now
confidenceThreshold = 0.87;
outlineConfidenceThreshold = 0.87; 

% Also saves behav data alongside eye data
Config.MapBehav = false;

SkipFirstNtrials = 0;

Config.EveryWhichTrial = 1;   
Config.BehavDir = '*';
Config.BehavParserFunction = '*';

Config.SkipParticipants = '*';

Config.EncOrTest = true;
Config.EncOrTest = false;

Config.FilterTrialsG = '*';

Config.PlotPupil.Enabled = false;
Config.PlotPupil.Mode = 0;
% 0 = none
% 1 = FFT before + after
% 2 = signal before + after

Config.HarFilt.BaseFreq = NaN;
Config.HarFilt.FreqRadius = NaN;
Config.HarFilt.NumAddHarmonics = NaN; 

Config.OutputNomSRate = 50; % Hz

% DEV: Manually correct trigger timestamps
% Config.ManShiftMs = 120;
% Config.ManShiftMs = 180;
Config.ManShiftMs = NaN;


