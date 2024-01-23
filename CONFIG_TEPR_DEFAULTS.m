
% % NBACK

Config.ETDSDirName = '*';

%--------------------
Config.BehavInitFunction = '*';
Config.BehavFiltFunction = '*';

Config.SkipFirstNtrials = NaN;

%--------------------
% !! Also for NBACK_2alk_2023 SMI & PupilEXT 
Config.AnalyzeFromSec = NaN;
Config.AnalyzeToSec = NaN;
Config.PeakFromSec = NaN;
Config.PeakToSec = NaN;
Config.BaselineFromSec = NaN;
Config.BaselineToSec = NaN;

%-------------------
Config.Filter.BaselineBlink.FromSec = NaN;
Config.Filter.BaselineBlink.ToSec = NaN;

Config.Filter.BaselineSaccade.FromSec = NaN;
Config.Filter.BaselineSaccade.ToSec = NaN;

Config.Filter.SOIBlink.FromSec = NaN;
Config.Filter.SOIBlink.ToSec = NaN;

Config.Filter.SOISaccade.FromSec = NaN;
Config.Filter.SOISaccade.ToSec = NaN;

Config.DynBLCorrMap.BehavDF = '*';
Config.DynBLCorrMap.DVFrom = NaN; 
Config.DynBLCorrMap.DVTo = NaN; 

Config.CC.Conds = [];

%-------------
Config.Plot.TEPR.XLim = NaN;
Config.Plot.TEPR.YLim = NaN;

Config.Plot.GrandTEPR.XLim = NaN;
Config.Plot.GrandTEPR.YLim = NaN;

Config.Plot.GrandERA.YLim = [0.8, 1.0];





%------------------- az alábbiak ÁLTALÁNOSAK, voltak sokáig a tepr szkriptben
Config.AlignToStimOrResp = true;
% Config.AlignToStimOrResp = false;

% NOTE: For testing only. If all computations are correct, both of 
% these should produce the same results
Config.BLCLocalOrGlobal = true; 
% Config.BLCLocalOrGlobal = false;

% Config.Z_norm_method = 0; % No Z-normalization
Config.Z_norm_method = 1; % Reference to whole recording (advised)
% Config.Z_norm_method = 2; % Reference to each trial for its own
% Config.Z_norm_method = 3; % Reference to all existing trials
% Config.Z_norm_method = 4; % Reference to all non-rejected trials
% % % Config.Z_norm_method = 5; % TODO: Reference to nearby N seconds

Config.Save.BaselineValues = false;
Config.Save.PeakValues = true;
Config.Save.TEPREveryParticipant = true;

Config.Save.TrialExclusionSummary = true;

% Config.Save.EveryTrial = false; % can be very slow if there are many excluded trials
Config.Save.EveryTrial = true; % can be very slow if there are many excluded trials

% METHOD
Config.EventRelatedMethod = 1; % TEPR (Avg)
% Config.EventRelatedMethod = 2; % TEPR-SD
% Config.EventRelatedMethod = 3; % TEPR-Ku
% Config.EventRelatedMethod = 4; % TEPR-Sk
% Config.EventRelatedMethod = 5; % TEPR-MAD
% Config.EventRelatedMethod = 6; % TEPR-Min
% Config.EventRelatedMethod = 7; % TEPR-Max
% Config.EventRelatedMethod = 8; % TEPR-KMax
% Config.EventRelatedMethod = 9; % TEPR-KVal
% ... % TEPR-Sh - Shapiro

% DYN BASELINE MAP
% Config.Plot.DynBLcorrMap.Make = true;
Config.Plot.DynBLcorrMap.Make = false;

Config.DynBLCorrMap.SmallOrLarge = true;

Config.DynBLCorrMap.CorrelMethod = 'Spearman';

FilterConfigs.SD.LocalLimit = 1.5; 


% LOW FPS TRIGGER JITTER CORRECTION:

% NOTE: This only makes sense if the sampling rate is very low, e.g. below 30hz
% so that the delay between a trigger timestamp of trial number increment and the first actual sample that belongs to the new trial
% can be high, like 50ms in case of 20hz eye data... so we could help a little with interpolation.
% BUT: this should never be used if there is higher raw eye data quality available! Or in other words:
% this is for a tiny correction of between-trial temporal alignment for better TEPR/TEPR averaging, and not for "enhancing" the
% preprocessed data if it was previously downsampled too much during preprocessing. (Then it would not improve anything.)

% Config.PerformTJC = true;
Config.PerformTJC = false;

RejectTrialsOnTypicalLen = false;
RejectTrialsOutsideLenSec = NaN;

Config.Filter.Interpol.Threshold = 20;
Config.Filter.BaselineSaccade.Magnitude = 20; % deg?
Config.Filter.SOISaccade.Magnitude = 20; % deg?

Config.Filter.Interpol.Enabled = true; 
% Config.Filter.BaselineBlink.Enabled = true; %%%%
% Config.Filter.BaselineSaccade.Enabled = true;
% Config.Filter.SOIBlink.Enabled = true;
% Config.Filter.SOISaccade.Enabled = true;
% % % % % Filter.OnBaselineInterpol = true;
% Config.Filter.SD.Enabled = true;

% Config.Filter.Interpol.Enabled = false;
Config.Filter.BaselineBlink.Enabled = false; %%%%
Config.Filter.BaselineSaccade.Enabled = false;
Config.Filter.SOIBlink.Enabled = false;
Config.Filter.SOISaccade.Enabled = false;
Config.Filter.SD.Enabled = false;


% Config.CC.Enabled = true;
Config.CC.Enabled = false;

% Config.Filter.Behav.Enabled = true;
Config.Filter.Behav.Enabled = false;

Config.ERA.Enabled = true; % event-related artefacts (event-related blink curve & event-related saccades curve)
% Config.ERA.Enabled = false;

Config.ERA.EventOfInterest = 0; % blink start
% Config.ERA.EventOfInterest = 1; % blink end
% Config.ERA.EventOfInterest = 2; % saccade start
% Config.ERA.EventOfInterest = 3; % saccade end

% ERA visualization only
% Config.Plot.ERA.VisualMethod = 0; % kernel density estimation
Config.Plot.ERA.VisualMethod = 1; % histogram
%
Config.Plot.ERA.KDEBandwidth = 200;
Config.Plot.ERA.HistBinWidth = 200;

% Should we always close the existing figure on a new plot, or plot on it
% Config.Plots.Layered = true;
% Config.Plots.Layered = false;
%
% Config.Plots.LayeredFigCounter = 1;

% Config.Plot.TEPR.Make = true; %%%  %%%
Config.Plot.GrandTEPR.Make = true;
% Config.Plot.ERA.Make = true;
% Config.Plot.GrandERA.Make = true;

% Config.Plot.TEPR.EveryTrial = true; %%%% %%%  %%%
% Config.Plot.GrandTEPR.EveryParticipant = true; %%%%
% Config.Plot.GrandERA.EveryParticipant true;

Config.Plot.TEPR.Make = false; %%%  %%%
% Config.Plot.GrandTEPR.Make = false; %%%  %%%
Config.Plot.ERA.Make = false;
Config.Plot.GrandERA.Make = false;

Config.Plot.TEPR.EveryTrial = false; %%%% %%%  %%%
Config.Plot.GrandTEPR.EveryParticipant = false; %%%%
Config.Plot.GrandERA.EveryParticipant = false;


Config.Plots.ScaleFactor = 0.4;
% Config.Plots.ScaleFactor = 0.6;
% Config.Plots.ScaleFactor = 1.0;

% NOTE: adding plot markings when the analytic length is long is slow
% Config.Plots.Markings = false;
Config.Plots.Markings.Enabled = true;
Config.Plots.Markings.F = false;
Config.Plots.Markings.B = true;
Config.Plots.Markings.S = true;
Config.Plots.Markings.R = true;

Config.Plots.Grid = true;
% Config.Plots.Grid = false;

% Config.Plots.Markings.OnEdges = true;
Config.Plots.Markings.OnEdges = false;





