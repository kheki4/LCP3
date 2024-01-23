
% % NBACK

%
% Config.ETDSDirName = 'NBACK_ver1_s1_SESPEC_BE_DQ_MM_SMI';
Config.ETDSDirName = 'NBACK_ver1_s1_MUTUAL_BE_DQ_MM_SMI'; %%%%%%%%%%%
% 
% Config.ETDSDirName = 'NBACK_ver1_s2_SESPEC_BE_DQ_MM_SMI';
% Config.ETDSDirName = 'NBACK_ver1_s2_MUTUAL_BE_DQ_MM_SMI'; %%%%%%%%%%%

% Config.ETDSDirName = 'NBACK_ver1_s1_NEWONLY_DQ_MM_SMI';
% Config.ETDSDirName = 'NBACK_ver1_s2_NEWONLY_DQ_MM_SMI';

% Config.ETDSDirName = 'NBACK_ver1_s1_NEWONLY_DQ_PX_PupilEXT'; 
% Config.ETDSDirName = 'NBACK_ver1_s2_NEWONLY_DQ_PX_PupilEXT'; 

% Config.ETDSDirName = 'NBACK_ver1_s1_MUTUAL_BE_finderror_DQ_MM_SMI';
% Config.ETDSDirName = 'NBACK_ver1_s2_MUTUAL_BE_finderror_DQ_MM_SMI';

% Config.ETDSDirName = 'NBACK_ver1_s1_MUTUAL_BE_2700S_DQ_MM_SMI';
% Config.ETDSDirName = 'NBACK_ver1_s2_MUTUAL_BE_2700S_DQ_MM_SMI';

% Config.ETDSDirName = 'NBACK_ver1_s1_MUTUAL_BE_2700s_DQ_PX_PUPILEXT';
% Config.ETDSDirName = 'NBACK_ver1_s2_MUTUAL_BE_2700s_DQ_PX_PUPILEXT';

% Config.ETDSDirName = 'NBACK_ver1_s1_OLD11_DQ_MM_SMI';
% Config.ETDSDirName = 'NBACK_ver1_s2_OLD11_DQ_MM_SMI';

%--------------------
Config.BehavInitFunction = 'callable_initbehavfilt_NBACK';
Config.BehavFiltFunction = 'callable_behavfilt_NBACK';

Config.SkipFirstNtrials = 2;

%--------------------
% !! Also for NBACK_2alk_2023 SMI & PupilEXT 
Config.AnalyzeFromSec = -0.7;
Config.AnalyzeToSec = 2.5;
Config.PeakFromSec = 0.0;
Config.PeakToSec = 2.5;
% Config.PeakFromSec = 1.0;
% Config.PeakToSec = 1.5;
% Config.BaselineFromSec = -0.7;
% Config.BaselineToSec = 0.0;
Config.BaselineFromSec = -0.2;
Config.BaselineToSec = 0.0;

%-------------------
Config.Filter.BaselineBlink.FromSec = 1.4;
Config.Filter.BaselineBlink.ToSec = 2.2;

Config.Filter.BaselineSaccade.FromSec = 1.4;
Config.Filter.BaselineSaccade.ToSec = 2.2;

Config.Filter.SOIBlink.FromSec = 1.4;
Config.Filter.SOIBlink.ToSec = 2.2;

Config.Filter.SOISaccade.FromSec = 1.4;
Config.Filter.SOISaccade.ToSec = 2.2;

%------------------ behav cond comb
%
% Config.Filter.Behav.CondComb = 1; % S=Target, R=Yes, (V=Correct) %%%%%%%%%%%%%%%%%% %
% % Config.Filter.Behav.CondComb = 2; % S=Target, R=No, (V=Wrong)
% Config.Filter.Behav.CondComb = 3; % S=Nontarget, R=No, (V=Correct) %%%%%%%% %
% % Config.Filter.Behav.CondComb = 4; % S=Nontarget, R=Yes, (V=Wrong)
%
% Config.Filter.Behav.CondComb = 5; % V=Correct (CORRECT all) %%%%%%%%%%%%%%%%%
% Config.Filter.Behav.CondComb = 6; % V=Wrong (WRONG all) %%%%%%%%%%%%%%%%%%%
%
% Config.Filter.Behav.CondComb = 7; % all trials with key responses
% Config.Filter.Behav.CondComb = 8; % all trials without key response

% -------------- behav filt config defs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NBACK python verzio
% RESPONSE:
% up = yes
% down = no
% STIMULUS:
% 1 = target (nback)
% 0 = nontarget
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ver1 s1 es s2
Config.Filter.Behav.StimType.A = 1;
Config.Filter.Behav.StimType.B = 0;
%
Config.Filter.Behav.RespType.A = 'up';
Config.Filter.Behav.RespType.B = 'down';
%
Config.Filter.Behav.StimType.A_friendly = 'Target';
Config.Filter.Behav.StimType.B_friendly = 'Nontarget';
%
Config.Filter.Behav.RespType.A_friendly = 'Yes';
Config.Filter.Behav.RespType.B_friendly = 'No';

% % % % ver2 es NBACK elderly
% % % Config.Filter.Behav.StimType.A = 1;
% % % Config.Filter.Behav.StimType.B = 0;
% % % %
% % % Config.Filter.Behav.RespType.A = 'up';
% % % Config.Filter.Behav.RespType.B = 'None';
% % % %
% % % Config.Filter.Behav.StimType.A_friendly = 'Target';
% % % Config.Filter.Behav.StimType.B_friendly = 'Nontarget';
% % % %
% % % Config.Filter.Behav.RespType.A_friendly = 'Yes';
% % % Config.Filter.Behav.RespType.B_friendly = 'Noresp';

% ------------------
% NBACK ver1 uj adatokkal SMI, MUTUAL-BE
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1 behav N=11 OLD11.csv';
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1 behav N=10 MUTUAL-BE HIT-FA NEWONLY (PupilEXT).csv';
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1 behav N=11 MUTUAL-BE HIT-FA NEWONLY.csv';
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1 behav N=46 MUTUAL-BE HIT-FA finderror.csv';
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1 behav N=15 MUTUAL-BE HIT-FA 2700S.csv';
Config.DynBLCorrMap.BehavDF = 'NBACK-ver1 behav N=55 MUTUAL-BE HIT-FA.csv';
Config.DynBLCorrMap.DVFrom = 3; 
Config.DynBLCorrMap.DVTo = 4; 
% %
% % Config.DynBLCorrMap.DVFrom = 3; 
% % Config.DynBLCorrMap.DVTo = 10; 

% % moindenfele valtozatra, 2alk nback esetĂ©n:
% Config.DynBLCorrMap.DVFrom = 2; 
% Config.DynBLCorrMap.DVTo = 5; 


% % NBACK 2alk 2023 s1 (SMI es PupilEXT)
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1_2alk_s1-SESPEC-BE behav N=18';
% Config.DynBLCorrMap.DVFrom = 6; 
% Config.DynBLCorrMap.DVTo = 6; 

% % NBACK 2alk 2023 s2 - SMI
% Config.DynBLCorrMap.BehavDF = 'NBACK-ver1_2alk_s2-SESPEC-BE behav N=17.csv';
% % Config.DynBLCorrMap.DVFrom = 6; 
% % Config.DynBLCorrMap.DVTo = 6; 
%
% % NBACK 2alk 2023 s2 - PupilEXT
% Config.DynBLCorrMap.BehavDF = '+ NBACK_2alk_2023_s2/NBACK_2alk_2023_s2_behav-results_N=18.csv';
% Config.DynBLCorrMap.DVFrom = 6; 
% Config.DynBLCorrMap.DVTo = 6; 

Config.Plot.DynBLcorrMap.Make = true;

%-----------------
% Config.CC.Conds = [ ...
%     1, ... % S=Target, R=Yes, (V=Correct) (HIT) (9-13 ilyen)
%     4, ... % S=Nontarget, R=Yes, (V=Wrong) (FA) (tul keves ilyen, 1-2)
% ];

% Config.CC.Conds = [ ...
%     3, ... % S=Nontarget, R=No, (V=Correct) (CR) (kb 70 ilyen)
%     4, ... % S=Nontarget, R=Yes, (V=Wrong) (FA) (tul keves ilyen, 1-2)
% ];

Config.CC.Conds = [ ...
    3, ... % S=Nontarget, R=No, (V=Correct) (CR) (kb 70 ilyen)
    1, ... % S=Target, R=Yes, (V=Correct) (HIT) (9-13 ilyen)
];

%-------------
Config.Plot.TEPR.XLim = NaN;
% Config.Plot.TEPR.YLim = [-3 3]; % Nback
Config.Plot.TEPR.YLim = [20 50]; % Nback

Config.Plot.GrandTEPR.XLim = NaN;
Config.Plot.GrandTEPR.YLim = [-0.3 0.3]; % NBACK, baseline korr, TEPR
% % Config.Plot.GrandTEPR.YLim = [-0.3 0.5]; % NBACK 2023-as adatokkal is
% % Config.Plot.GrandTEPR.YLim = [-0.3 0.8]; % NBACK 2023-as adatokkal is, ujabb, 11
% % % Config.Plot.GrandTEPR.YLim = [-0.5 2]; % NBACK, baseline korr, TEPR-SD

Config.Plot.GrandERA.YLim = [0.85, 0.97];



