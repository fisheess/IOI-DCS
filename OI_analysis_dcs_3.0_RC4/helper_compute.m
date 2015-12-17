%% helper to externalize computation-process
function handles = helper_compute(handles)

set(handles.txt_notification,'String','Busy');

force_recompute = logical(get(handles.cbox_forceRecompute,'Value'));
global DATA PARA PREF;

DATA.smoothFilter = fspecial('gaussian',PREF.smoothFilterSize,PREF.smoothFilterSize*0.1213);

DATA.jointRelDiff = zeros(PARA.frameSize);
DATA.jointTvalues = zeros(PARA.frameSize);
% DATA.jointCC = zeros(PARA.frameSize);
% DATA.jointCCOriginal = zeros(PARA.frameSize);
DATA.jointRelDiffOriginal = zeros(PARA.frameSize);
DATA.jointTvaluesOriginal = zeros(PARA.frameSize);

DATA.mask_reldiff = false(PARA.frameSize);
DATA.mask_tvalues = false(PARA.frameSize);
% DATA.mask_CC = logical(zeros(PARA.frameSize));

count = []; % will save used datasets

h_wait = waitbar(0,'calculating trepanation masks ...');
for i = 1:1:size(PARA.subdirs,2)
     if PARA.subdirs{2,i} % if data set was chosen to be analyzed
         try 
            isempty(DATA.trepanationMask{i});
        catch
            DATA.trepanationMask{i} = [];
        end
        % get trepanation mask for dataset
        if isempty(DATA.trepanationMask{i})

            I = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{1}(50,:) ]);
            I = imrotate(double(I), 180);
            I = uint8(I./PARA.grayMax.*256);
            DATA.trepanationMask{i} = built_mask(I,0);
        end 
     end
     waitbar(i/length(PARA.subdirs),h_wait);
end
close(h_wait);

% for each data set, that was chosen to be analyzed
h_wait = waitbar(0,'calculating activation map ...');
for i = 1:1:size(PARA.subdirs,2)

    if PARA.subdirs{2,i} % if data set was chosen to be analyzed
        
        count = [count i]; % save indices 
        % if variable is not yet set an error will be thrown, but catched
        % and the variable will be set

        if  force_recompute || isempty(DATA.relDiffPos{i})
        
            DATA.tvalues{i} = zeros(PARA.frameSize);
            DATA.relDiff{i} = zeros(PARA.frameSize);
%             DATA.CC{i}      = zeros(PARA.frameSize);
                
            % set stimparameter
            if PREF.stimParInd && ~isempty(PARA.cBaseStart_s{i})
                    baseStart_s = PARA.cBaseStart_s{i};
                    baseEnd_s = PARA.cBaseEnd_s{i};
                    stimStart_s = PARA.cStimStart_s{i};
                    stimEnd_s = PARA.cStimEnd_s{i};
            else
                    baseStart_s = PARA.baseStart_s;
                    baseEnd_s = PARA.baseEnd_s;
                    stimStart_s = PARA.stimStart_s;
                    stimEnd_s = PARA.stimEnd_s;
            end

            % number of frames before stimulation
            nFramesBase = find( (DATA.time_s{i} > baseStart_s) & (DATA.time_s{i} <= baseEnd_s)  );

            % number of frames after stimulation
            nFramesStim = find( (DATA.time_s{i} > stimStart_s) & (DATA.time_s{i} <= stimEnd_s)  );

            nB = length(nFramesBase);
            nS = length(nFramesStim);

%             handles.nFramesElectrodes = find( (DATA.time_s{i} > handles.baseEnd_s) & (DATA.time_s{i} < PARA.stimStart_s) );

            % baseline frame
            meanFrame = zeros(PARA.frameSize);
            for k = nFramesBase(1):1:nFramesBase(end)

                frame = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{i}(k,:) ]);

                meanFrame = meanFrame + double(frame);
            end

            DATA.meanBase{i} = meanFrame./nB;
            
            % stimulation frame
            meanFrame = zeros(PARA.frameSize);
            for k = nFramesStim(1):1:nFramesStim(end)

                frame = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{i}(k,:) ]);
                meanFrame = meanFrame + double(frame);
            end
            
            DATA.meanStim{i} = meanFrame./nS;
			DATA.meanStim{i}(DATA.meanStim{i} > PARA.grayMax) = PARA.grayMax;


            DATA.relDiff{i} = (DATA.meanBase{i} - DATA.meanStim{i})./DATA.meanBase{i};
            DATA.relDiff{i}(isnan(DATA.relDiff{i})) = 0;
			DATA.relDiff{i}(isinf(DATA.relDiff{i})) = 0;
            
            varBase = zeros(PARA.frameSize);
            varStim = zeros(PARA.frameSize);

            % calculate baseline variance 
            for k = nFramesBase(1):1:nFramesBase(end)
                frame = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{i}(k,:) ]);
                varBase = varBase + (double(frame) - DATA.meanBase{i}).^2;
            end
            % calculate stim variance
            for k = nFramesStim(1):1:nFramesStim(end)
                frame = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{i}(k,:) ]);
                varStim = varStim + (double(frame) - DATA.meanStim{i}).^2;
            end

            % calculate variance baseline frame
            DATA.varBase = varBase ./ (nB-1);
            % calculate variance stimulation frame
            DATA.varStim = varStim ./ (nS-1) ;

            SD = sqrt(((nB-1)*DATA.varBase + (nS-1)*DATA.varStim)./(nB + nS - 2));
            SD(isnan(SD))=0;

            DATA.tvalues{i} = (DATA.meanBase{i} - DATA.meanStim{i}) ./ SD .* sqrt( (nB.*nS)/(nB+nS ));
            DATA.tvalues{i}(isnan(DATA.tvalues{i})) = 0;
			DATA.tvalues{i}(isinf(DATA.tvalues{i})) = 0;

%             % calculate correlation coefficient
%             % load data
%             data = zeros(PARA.frameSize(1), PARA.frameSize(2),length(PARA.filenames{i}));
%             for j = 1:length(PARA.filenames{i})
%                 try
%                     data(:,:,j) = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{i}(j,:) ]);
%                 catch
%                     break;
%                 end
%             end
%             
%             % find frames before and after stimulation
%             idx_corr = [find(DATA.time_s{i} > PARA.stimStart_s & DATA.time_s{i} < (PARA.stimStart_s+20) )];
% %             idx_corr = [find(DATA.time_s{i} > PARA.stimStart_s & DATA.time_s{i} < (PARA.stimStart_s+20) )];
%             time_corr = DATA.time_s{i}(idx_corr);
%             data_corr = data(:,:,idx_corr);
%             clear data;
%             
%             % initialize variables to correlate
% %             y1 = (-0.5059 .* time_corr )'; % 20 s poststim
%             y1 = (-0.5 .* time_corr )'; % 20 s poststim
% %             y1 = (-1 .* time_corr )'; % 20 s poststim
%             h_corr = waitbar(0,'calculating correlation map ...');
%             for j=1:size(data_corr,1)
%                 for k=1:size(data_corr,2)        
%                     x=single(data_corr(j,k,:));
%                     x = x(:)';
%                     R1= corrcoef(x',y1); % correlate
%                     DATA.CC{i}(j,k) = R1(1,2); % store CC        
%                 end
%                 waitbar((k*j)/(size(data_corr,1)*size(data_corr,2)) ,h_corr);
%             end 
%             close(h_corr);
            if PREF.smoothFilterSize
                DATA.relDiff{i} = imfilter(DATA.relDiff{i},fspecial('gaussian',5,5*0.1213));
                DATA.tvalues{i} = imfilter(DATA.tvalues{i},fspecial('gaussian',5,5*0.1213));
%                 DATA.CC{i}      = imfilter(DATA.CC{i},fspecial('gaussian',5,5*0.1213));
            end

%             buf = DATA.tvalues{i};
%             buf(find(DATA.tvalues{i} > 0)) = 0;
%             handles.tvaluesNeg{i} = buf;
%             buf = DATA.tvalues{i};
%             buf(find(DATA.tvalues{i} < 3)) = 0;
%             handles.tvaluesPos{i} = buf;

%             handles.tvaluesNeg{i} = zeros(PARA.frameSize);
%             handles.tvaluesNeg{i}(DATA.tvalues{i} <0) = DATA.tvalues{i}(DATA.tvalues{i} <0);
            DATA.tvaluesPos{i} = zeros(PARA.frameSize);
%             DATA.tvaluesPos{i}(DATA.tvalues{i} > 3) = DATA.tvalues{i}(DATA.tvalues{i} >3);
            DATA.tvaluesPos{i}(DATA.tvalues{i} > 0) = DATA.tvalues{i}(DATA.tvalues{i} >0);
%             DATA.tvaluesPos{i}(DATA.tvalues{i} < 0) = abs(DATA.tvalues{i}(DATA.tvalues{i} <0));
%             buf = DATA.relDiff{i};
%             buf(find(DATA.relDiff{i} > 0)) = 0;
%             handles.relDiffNeg{i} = buf;
%             buf = DATA.relDiff{i};
%             buf(find(DATA.relDiff{i} < 0.005)) = 0;
%             DATA.relDiffPos{i} = buf;
 
%             handles.relDiffNeg{i} = zeros(PARA.frameSize);
%             handles.relDiffNeg{i}(DATA.relDiff{i} <0) = DATA.relDiff{i}(DATA.relDiff{i} <0);
            DATA.relDiffPos{i} = zeros(PARA.frameSize);
%             DATA.relDiffPos{i}(DATA.relDiff{i} > 0.005) = DATA.relDiff{i}(DATA.relDiff{i} > 0.005);
            DATA.relDiffPos{i}(DATA.relDiff{i} > 0) = DATA.relDiff{i}(DATA.relDiff{i} > 0);
%             DATA.relDiffPos{i}(DATA.relDiff{i} < 0) = abs(DATA.relDiff{i}(DATA.relDiff{i} < 0));

%              DATA.CCPos{i} = zeros(PARA.frameSize);
% %             DATA.relDiffPos{i}(DATA.relDiff{i} > 0.005) = DATA.relDiff{i}(DATA.relDiff{i} > 0.005);
%             DATA.CCPos{i}(DATA.CC{i} > 0) = DATA.CC{i}(DATA.CC{i} > 0);
            
        end % if ~exist(['DATA.relDiffPos{' num2str(i) '}'],'var')

	
    end % if PARA.subdirs{2,i}

    waitbar(i/length(PARA.subdirs),h_wait);	
end % for
close(h_wait);    


% calculate image optimization
% get parameter

h_wait = waitbar(0,'calculating activation masks ...');
% calculate masks for each dataset
for i=1:1:length(count) % count contains the used indices of PARA.subdirs
        % if variable is not yet set an error will be thrown, but catched
        % and the variable will be set
        try             
            isempty(DATA.mask_reldiff_i{count(i)});
        catch
            DATA.mask_reldiff_i{count(i)} = [];
            DATA.mask_tvalues_i{count(i)} = [];
%             DATA.mask_CC_i{count(i)}      = [];
            
            DATA.formFactors{count(i),1} = [];
            DATA.formFactors{count(i),2} = [];
            DATA.formFactors{count(i),3} = [];
%             DATA.formFactors{count(i),4} = [];
        end
        
        % get every trepanation mask
        trepanationMask = rot90(DATA.trepanationMask{count(i)},2);
        
        if force_recompute || isempty(DATA.mask_tvalues_i{count(i)}) && ~isempty(DATA.tvaluesPos{count(i)})
%             DATA.mask_tvalues_i{count(i)} = calcMask(DATA.tvaluesPos{count(i)},trepanationMask, radius, maxdist, 0);
            DATA.mask_tvalues_i{count(i)} = determineMask('image',DATA.tvaluesPos{count(i)},'aoi',trepanationMask,'modus', 0,'ep',{DATA.electrodePosX{count(i)} DATA.electrodePosY{count(i)}});
        end
        if force_recompute || isempty(DATA.mask_reldiff_i{count(i)}) && ~isempty(DATA.relDiffPos{count(i)}) 
             DATA.mask_reldiff_i{count(i)} = determineMask('image',DATA.relDiffPos{count(i)},'aoi',trepanationMask, 'modus', 1,'ep',{DATA.electrodePosX{count(i)} DATA.electrodePosY{count(i)}});
        end
%         if force_recompute || isempty(DATA.mask_CC_i{count(i)}) && ~isempty(DATA.CCPos{count(i)})
%             DATA.mask_CC_i{count(i)} = calcMask(DATA.CCPos{count(i)},trepanationMask, radius, maxdist, 2);
%         end
%         
        if ~isempty(DATA.mask_reldiff_i{count(i)}) && ~isempty(DATA.mask_tvalues_i{count(i)})
            DATA.formFactors{count(i),1} = PARA.subdirs{1,count(i)};
            DATA.formFactors{count(i),2} = determineFormFactors(DATA.mask_tvalues_i{count(i)});
            DATA.formFactors{count(i),3} = determineFormFactors(DATA.mask_reldiff_i{count(i)});
%             DATA.formFactors{count(i),4} = determineFormFactors(DATA.mask_CC_i{count(i)});
            
            DATA.formFactors{count(i),2}.Max = max(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
            DATA.formFactors{count(i),2}.Min = min(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
            DATA.formFactors{count(i),2}.Mean = mean(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
            DATA.formFactors{count(i),2}.Std = std(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));

            DATA.formFactors{count(i),3}.Max = max(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
            DATA.formFactors{count(i),3}.Min = min(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)})); 
            DATA.formFactors{count(i),3}.Mean = mean(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
            DATA.formFactors{count(i),3}.Std = std(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
            
%             DATA.formFactors{count(i),4}.Max = max(DATA.CCPos{count(i)}(DATA.mask_CC_i{count(i)}));
%             DATA.formFactors{count(i),4}.Min = min(DATA.CCPos{count(i)}(DATA.mask_CC_i{count(i)})); 
%             DATA.formFactors{count(i),4}.Mean = mean(DATA.CCPos{count(i)}(DATA.mask_CC_i{count(i)}));
%             DATA.formFactors{count(i),4}.Std = std(DATA.CCPos{count(i)}(DATA.mask_CC_i{count(i)}));
        end %if
            
        if length(count) == 1
            mean_rd = mean(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
            std_rd = std(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
            mean_tv = mean(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
            std_tv = std(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
            set(handles.txt_notification,'String',['Statistical information about dataset "' PARA.subdirs{1,count(i)} '" (within activation): [reldiff] mean = ' num2str(mean_rd) ', std = ' num2str(std_rd) ' | [tvalues] mean = ' num2str(mean_tv) ', std = ' num2str(std_tv) ]);
        end
        waitbar(i/length(count),h_wait);	
end
close(h_wait);

idx = [];
if length(count) > 1
    for i=1:1:length(count) % count contains the used indices of PARA.subdirs
        % only join pixels which have higher value 
        idx = find(DATA.relDiffPos{count(i)}.*DATA.mask_reldiff_i{count(i)} > DATA.jointRelDiffOriginal);
        DATA.jointRelDiffOriginal(idx) = DATA.relDiffPos{count(i)}(idx);
        idx = find(DATA.tvaluesPos{count(i)}.*DATA.mask_tvalues_i{count(i)} > DATA.jointTvaluesOriginal);
        DATA.jointTvaluesOriginal(idx) = DATA.tvaluesPos{count(i)}(idx);
%         idx = find(DATA.CCPos{count(i)}.*DATA.mask_CC_i{count(i)} > DATA.jointCCOriginal);
%         DATA.jointCCOriginal(idx) = DATA.CCPos{count(i)}(idx);
    end
else
     DATA.jointRelDiffOriginal = DATA.relDiffPos{count(1)};
     DATA.jointTvaluesOriginal = DATA.tvaluesPos{count(1)};
%      DATA.jointCCOriginal      = DATA.CCPos{count(1)};
end

DATA.jointTvalues = imfilter(DATA.jointTvaluesOriginal,DATA.smoothFilter);
DATA.jointRelDiff = imfilter(DATA.jointRelDiffOriginal,DATA.smoothFilter);
% DATA.jointCC = imfilter(DATA.jointCCOriginal,DATA.smoothFilter);

h_wait = waitbar(0,'merging activation masks ...');
% merge masks
for i=1:1:length(count)
    if ~isempty(DATA.mask_reldiff_i{count(i)})
        DATA.mask_reldiff = DATA.mask_reldiff + DATA.mask_reldiff_i{count(i)};
    end
    if ~isempty(DATA.mask_tvalues_i{count(i)})
        DATA.mask_tvalues = DATA.mask_tvalues + DATA.mask_tvalues_i{count(i)};
    end
%     if ~isempty(DATA.mask_CC_i{count(i)})
%         DATA.mask_CC = DATA.mask_CC + DATA.mask_CC_i{count(i)};
%     end
    waitbar(i/length(count),h_wait);
end
close(h_wait); 

first_compute = false;

% set computed status
if isempty(find(PARA.computed,1))
        first_compute = true;
end
for i=1:1:length(count)
    PARA.computed(count(i)) = true;
end
 
% update the gui

% rel diff & t values
if first_compute
    set(handles.popup_show,'Enable','on');
    set(handles.popup_show,'String',{ 'rel diff' 't values'});
%     set(handles.popup_show,'String',{ 'rel diff' 't values' 'corr coeff'});
    set(handles.popup_show,'Value',2);
    PARA.show = uint8(2);    
else
    PARA.show = uint8(get(handles.popup_show,'Value'));
end

set(handles.slider_threshold,'Enable','on');
set(handles.edit_threshold_cur,'Enable','on');
set(handles.pb_amroi,'Enable','on');

% set threshold
PARA.threshold_min = 0;
switch PARA.show 
    case 1
      PARA.threshold_max = PREF.maxRelDiff;
    if first_compute 
        PARA.threshold_cur = PARA.threshold_max ;
    end
    PARA.threshold_cur (PARA.threshold_cur > PREF.maxRelDiff) = PREF.maxRelDiff;
    PARA.threshold_cur( PARA.threshold_cur < PARA.threshold_min ) = PARA.threshold_min;
    
    case 2
      PARA.threshold_max = PREF.maxTvalues;
      if first_compute
        PARA.threshold_cur = PARA.threshold_max;
      end
     PARA.threshold_cur(PARA.threshold_cur > PREF.maxTvalues) = PREF.maxTvalues;   
     PARA.threshold_cur( PARA.threshold_cur < PARA.threshold_min ) = PARA.threshold_min;
     
%     case 3
%       PARA.threshold_max = PREF.maxRelDiff;
%     if first_compute 
%         PARA.threshold_cur = PARA.threshold_max ;
%     end
%     PARA.threshold_cur (PARA.threshold_cur > PREF.maxRelDiff) = PREF.maxRelDiff;
%     PARA.threshold_cur( PARA.threshold_cur < PARA.threshold_min ) = PARA.threshold_min;
end
subdirs = get(handles.lb_subdir,'String');
% mark computed datasets with *
for i=1:1:length(count)
    if PARA.computed(count(i)) 
        str = [PARA.subdirs{1,count(i)} '*'];
        if  isempty(findstr('*',subdirs{count(i),1})) 
            subdirs{count(i),1} = str;
        end
    else
        str = PARA.subdirs{1,count(i)};
    end    
    PARA.dirsToAnalyze{i} = str;
end
set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);
set(handles.lb_subdir,'String',subdirs);

if first_compute
    set(handles.slider_threshold,'Min',PARA.threshold_min);
    set(handles.slider_threshold,'Max',PARA.threshold_max);
    set(handles.slider_threshold,'Value',PARA.threshold_cur);
end

set(handles.tb_bg_only,'Enable','on');
set(handles.cbox_forceRecompute,'Enable','on');
set(handles.cbox_trepanation, 'Enable', 'on');
set(handles.cbox_legend,'Enable','on');
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

% activate overlay-switches
if ~get(handles.tb_bg_only,'Value')
    set(handles.cbox_overlay,'Enable','on');
    set(handles.cbox_activation,'Enable','on');
    set(handles.cbox_mask_contour, 'Enable', 'on');
end

if strcmp(get(handles.txt_notification,'String'),'Busy')
    set(handles.txt_notification,'String','Ready');
end

% commandChain;



end % function