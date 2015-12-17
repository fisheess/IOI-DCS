function t = loadTrepElec()
global DATA PARA;
t = false(1,3);
try
    load([PARA.currentPatient '_trepMask.mat']);
    DATA.trepanationMask = trepMask;
    t(1)=true;
catch
    warning(['File: ' PARA.currentPatient '_trepMask.mat not found!']);
end
try
    load([PARA.currentPatient '_electrodePos.mat']);
    DATA.electrodePosX = electrodePosX; 
    DATA.electrodePosY = electrodePosY;
    t(2)=true;
catch
    warning(['File: ' PARA.currentPatient '_electrodePos.mat not found!']);
end
try
    load([PARA.currentPatient '_stimDesign.mat']);
    PARA.cBaseStart_s = stimDesign{1};
    PARA.cBaseEnd_s = stimDesign{2};
    PARA.cStimStart_s = stimDesign{3};
    PARA.cStimEnd_s = stimDesign{4};
    t(3) = true;
catch
    warning(['File: ' PARA.currentPatient '_stimDesign.mat not found!']);
end

end % function