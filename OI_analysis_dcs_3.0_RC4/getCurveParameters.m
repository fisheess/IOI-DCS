function [t idx] = getCurveParameters(tc,dataSet)

global DATA PARA PREF;

time_s = DATA.time_s{dataSet};
% set stimparameter
if PREF.stimParInd && ~isempty(PARA.cBaseEnd_s{dataSet})
        baseEnd_s = PARA.cBaseEnd_s{dataSet};
        stimStart_s = PARA.cStimStart_s{dataSet};
else
        baseEnd_s = PARA.baseEnd_s;
        stimStart_s = PARA.stimStart_s;
end
%% get indices and times for specific points
% index and time for prestim
idx.PrS = find(time_s - baseEnd_s > 0,1,'first'); % equals min(find(X))
t.PrS_s = time_s(idx.PrS);

% index and time for poststim
idx.PoS = find(time_s - stimStart_s > 0,1,'first');
t.PoS_s = time_s(idx.PoS);

% index and time for minium after poststim
idx.Min = min(find(min(tc(idx.PoS:end))== tc(idx.PoS:end))) + idx.PoS - 1;
t.Min_s = time_s(idx.Min);

% index and time for reaching poststim again after poststim
temp = find((tc - tc(idx.PoS) > 0 )); %returns probably vector
idx.PoS2 = min(temp(temp>idx.Min)); % get first element with greater index than idx.Min
t.PoS2_s = time_s(idx.PoS2);

% index and time for reaching prestim again after poststim
temp =(find((abs(tc - tc(idx.PrS)) > 0 ) & (abs(tc - tc(idx.PrS)) < 1)));
idx.PrS2 = min(temp(temp>idx.PoS));
t.PrS2_s = time_s(idx.PrS2);



%% calculate time differences
% values can be empty --> time could not be determined because of various
% reasons

% T1 = diff([t.PoS t.Min]); % time until  minimum is reached
% T2 = diff([t.PoS t.PoS2]); % time until poststim niveau is reached again
% T3 = diff([t.PoS t.PrS2]); % time until prestim niveau is reached again
% T4 = diff([t.PrS t.PrS2]); % time between prestim first and prestim again
% T1T2 = diff([t.Min t.PoS2]); % time between minimum and poststim again
% T1T3 = diff([t.Min t.PrS2]); % time between minimum and prestim again
% T2T3 = diff([t.PoS2 t.PrS2]); % time between poststim again and prestim again
% 

end % function
