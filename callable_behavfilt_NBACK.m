function ExcludedMask = callable_behavfilt_NBACK(NumTrials, Behav, FilterConfig)

        for i = 1:NumTrials
            ExcludedMask(i) = true;
            
            if strcmp(Behav.StimType(i), '*') || ...
                strcmp(Behav.RespType(i), '*') || ...
                isnan(Behav.RespVerid(i)) % || ...
                log_w(['Mapped behav data seems to be invalid for trial ' num2str(i)]);
%                 behav.RT(i) == NaN
                continue;
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % TRIAL-SPECIFIC CODE
            if FilterConfig.CondComb == 0
%                 warning('Behav filter not specified');
                ExcludedMask(i) = false;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            elseif FilterConfig.CondComb == 1 && ... % S=Target, R=Yes, (V=Correct)      % target HIT
                    Behav.StimType(i) == FilterConfig.StimType.A && ...
                    strcmp(Behav.RespType(i), FilterConfig.RespType.A)
                ExcludedMask(i) = false;
                
            elseif FilterConfig.CondComb == 2 && ... % S=Target, R=No, (V=Wrong)         % target miss
                    Behav.StimType(i) == FilterConfig.StimType.A && ...
                    strcmp(Behav.RespType(i), FilterConfig.RespType.B)
                ExcludedMask(i) = false;
                
            elseif FilterConfig.CondComb == 3 && ... % S=Nontarget, R=No, (V=Correct)    % CR
                    Behav.StimType(i) == FilterConfig.StimType.B && ...
                    strcmp(Behav.RespType(i), FilterConfig.RespType.B)
                ExcludedMask(i) = false;
                
            elseif FilterConfig.CondComb == 4 && ... % S=Nontarget, R=Yes, (V=Wrong)     % FA
                    Behav.StimType(i) == FilterConfig.StimType.B && ...
                    strcmp(Behav.RespType(i), FilterConfig.RespType.A)
                ExcludedMask(i) = false;
          
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            elseif FilterConfig.CondComb == 5 && ... % V=Correct (CORRECT all)
                    Behav.RespVerid(i) == 1
                ExcludedMask(i) = false;
                
            elseif FilterConfig.CondComb == 6 && ... % V=Wrong (WRONG all)
                    Behav.RespVerid(i) == 0
                ExcludedMask(i) = false;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            elseif FilterConfig.CondComb == 7 && ... % all trials with key responses
                    ~strcmp(Behav.RespType(i), 'None')
                ExcludedMask(i) = false;
                
            elseif FilterConfig.CondComb == 8 && ... % all trials without key response
                    strcmp(Behav.RespType(i), 'None')
                ExcludedMask(i) = false;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
%             elseif filterConfig.CondComb < 0 || filterConfig.CondComb > 13
%                 error('Invalid filter method specified');
% %                 excludedMask(i) = true; 
            end
            
        end

end