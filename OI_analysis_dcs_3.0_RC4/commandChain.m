% clc;
tic;
% clear cTimecourses;
global DATA PARA;
% exportTC2xls('.xls');
% tempFunc;
% exportPolynoms2xls('.xls',polynoms_rd,'reldiff');
% exportPolynoms2xls('.xls',polynoms_tv,'tvalue');
% exportPolynoms2xls('.xls',polynoms_mean,'mean');
exportFormFactors2xls('.xls',DATA.formFactors,'reldiff'); 
exportFormFactors2xls('.xls',DATA.formFactors,'tvalues');

trepMask = DATA.trepanationMask;save([PARA.currentPatient '_trepMask.mat'],'trepMask')
electrodePosX = DATA.electrodePosX; electrodePosY = DATA.electrodePosY; save([PARA.currentPatient '_electrodePos.mat'],'electrodePosX','electrodePosY');
stimDesign{1} = PARA.cBaseStart_s;stimDesign{2} =PARA.cBaseEnd_s ;stimDesign{3} =PARA.cStimStart_s;stimDesign{4} =PARA.cStimEnd_s;
save([PARA.currentPatient '_stimDesign.mat'],'stimDesign');

toc

