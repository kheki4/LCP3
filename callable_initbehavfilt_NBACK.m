function [FilterConfig, PlotConfig] = callable_initbehavfilt_NBACK(FilterConfig, PlotConfig)


        % BEHAV-FILTER-SPECIFIC CODE for NBACK
        if FilterConfig.CondComb == 0
%             warning('Behav filter not specified');
            PlotConfig.LineStyle = '-';
%             lineColor = [0 1 1]; % light sky blue (EXP1)
%             lineColor = [153/255 51/255 255/255]; % light purple (EXP2)
            FilterConfig.S = '~';
            FilterConfig.R = '~';
            FilterConfig.V = '~';
            FilterConfig.FriendlyName = 'All Trials';
        
        elseif FilterConfig.CondComb == 1 % S=Target, R=Yes, (V=Correct)      % target HIT
            PlotConfig.LineStyle = '-';
            PlotConfig.LineColor = [0 1 0]; % GREEN
            FilterConfig.S = FilterConfig.StimType.A_friendly;
            FilterConfig.R = FilterConfig.RespType.A_friendly;
            FilterConfig.V = 'C';
            FilterConfig.FriendlyName = 'Target Hits';
            
        elseif FilterConfig.CondComb == 2 % S=Target, R=No, (V=Wrong)         % target miss
            PlotConfig.LineStyle = '-';
            PlotConfig.LineColor = [1 0 0]; % RED
            FilterConfig.S = FilterConfig.StimType.A_friendly;
            FilterConfig.R = FilterConfig.RespType.B_friendly;
            FilterConfig.V = 'W';
            FilterConfig.FriendlyName = 'Target Misses';
            
        elseif FilterConfig.CondComb == 3 % S=Nontarget, R=No, (V=Correct)    % CR
            PlotConfig.LineStyle = '-';
            PlotConfig.LineColor = [0.4660 0.6740 0.1880]; % dark green
            FilterConfig.S = FilterConfig.StimType.B_friendly;
            FilterConfig.R = FilterConfig.RespType.B_friendly;
            FilterConfig.V = 'C';
            FilterConfig.FriendlyName = 'Correct Rejections';
            
        elseif FilterConfig.CondComb == 4 % S=Nontarget, R=Yes, (V=Wrong)     % FA
            PlotConfig.LineStyle = '-';
            PlotConfig.LineColor = [0.6350 0.0780 0.1840]; % dark red
            FilterConfig.S = FilterConfig.StimType.B_friendly;
            FilterConfig.R = FilterConfig.RespType.A_friendly;
            FilterConfig.V = 'W';
            FilterConfig.FriendlyName = 'False Alarms';
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        elseif FilterConfig.CondComb == 5 % V=Correct (CORRECT all)
            PlotConfig.LineStyle = '--';
            PlotConfig.LineColor = [0 1 1]; % cyan
            FilterConfig.S = '~';
            FilterConfig.R = '~';
            FilterConfig.V = 'C';
            FilterConfig.FriendlyName = 'Correct Responses';
            
        elseif FilterConfig.CondComb == 6 % V=Wrong (WRONG all)
            PlotConfig.LineStyle = '--';
            PlotConfig.LineColor = [1 1 0]; % yellow
            FilterConfig.S = '~';
            FilterConfig.R = '~';
            FilterConfig.V = 'W';
            FilterConfig.FriendlyName = 'Wrong Responses';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        elseif FilterConfig.CondComb == 7 % all trials with response
            PlotConfig.LineStyle = '--';
            PlotConfig.LineColor = [0.5 0.5 0.5]; % grey
            FilterConfig.S = '~';
            FilterConfig.R = '*';
            FilterConfig.V = '~';
            FilterConfig.FriendlyName = 'Any key response';
            
        elseif FilterConfig.CondComb == 8 % all trials without response
            PlotConfig.LineStyle = '--';
            PlotConfig.LineColor = [0 0 0]; % black
            FilterConfig.S = '~';
            FilterConfig.R = '∅';
            FilterConfig.V = '~';
            FilterConfig.FriendlyName = 'No key reponse';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        else
            error('Invalid filter method specified');
%             excludedOnBehav(i) = true; 
        end

end