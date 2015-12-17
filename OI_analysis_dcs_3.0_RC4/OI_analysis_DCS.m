function varargout = OI_analysis_DCS(varargin)

% OI_ANALYSIS_DCS M-file for OI_analysis_DCS.fig
%      OI_ANALYSIS_DCS, by itself, creates a new OI_ANALYSIS_DCS or raises the existing
%      singleton*.
%
%      H = OI_ANALYSIS_DCS returns the handle to a new OI_ANALYSIS_DCS or the handle to
%      the existing singleton*.
%
%      OI_ANALYSIS_DCS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OI_ANALYSIS_DCS.M with the given input arguments.
%
%      OI_ANALYSIS_DCS('Property','Value',...) creates a new OI_ANALYSIS_DCS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OI_analysis_DCS_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OI_analysis_DCS_OpeningFcn via varargin.
%
%
% -------------------------------------------------------------------------
% programm analysis of OI data for direct cortical stimulation
% 
%
% ---
% version 3.0 RC1
% status: in development
%
% Tobias Meyer, Hannes Wahl, Martin Oeschlägel - 07.2011

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OI_analysis_DCS_OpeningFcn, ...
                   'gui_OutputFcn',  @OI_analysis_DCS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% --- Executes just before OI_analysis_DCS is made visible.---------------
function OI_analysis_DCS_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for OI_analysis_DCS
handles.output = hObject;

% clear command window
%clc
mkdir('C:\temp');

% initialize all parameters
initialize( hObject, handles, 'init' );

% sb = statusbar(OI_analysis_DCS,'Initializing...');
% set(sb.CornerGrip, 'visible','off');
% statusbar( ...
%     ['Welcome to "OI analysis-Module for Direct Cortical Stimulation"! You are using version '...
%     handles.versionNr ' released at ' ...
%     handles.versionDate ' and submitted by '...
%     handles.submittedBy '.' ]);

% UIWAIT makes OI_analysis_DCS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%% --- Outputs from this function are returned to the command line. -------
function varargout = OI_analysis_DCS_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%% --- Executes on slider movement.----------------------------------------
function slider_threshold_Callback(hObject, eventdata, handles)

% PREF = getappdata(0,'PREF');
global PARA PREF;
switch PARA.show 
   case 1 % reldiff
       PARA.threshold_max_rd = PREF.maxRelDiff;
       PARA.threshold_cur_rd = get(handles.slider_threshold,'Value');
       PARA.threshold_cur_rd(PARA.threshold_cur_rd > PARA.threshold_max_rd) = PARA.threshold_max_rd;
   case 2 % tvalues
       PARA.threshold_max_tv = PREF.maxTvalues;
       PARA.threshold_cur_tv = get(handles.slider_threshold,'Value');
       PARA.threshold_cur_tv(PARA.threshold_cur_tv > PARA.threshold_max_tv) = PARA.threshold_max_tv;
%    case 3 % corr coeff
%        PARA.threshold_max_rd = PREF.maxRelDiff;
%        PARA.threshold_cur_rd = get(handles.slider_threshold,'Value');
%        PARA.threshold_cur_rd(PARA.threshold_cur_rd > PARA.threshold_max_rd) = PARA.threshold_max_rd;
end
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

guidata(hObject, handles);

%% --- Executes during object creation, after setting all properties.------
function slider_threshold_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% --- Executes on change in edit box
function edit_threshold_cur_Callback(hObject, eventdata, handles)

global PARA;

threshold =  str2double(get(handles.edit_threshold_cur,'String'));

if threshold <= PARA.threshold_min
    threshold = PARA.threshold_min;
elseif threshold >= PARA.threshold_max
    threshold = PARA.threshold_max;
end

PARA.threshold_cur = threshold;
set(handles.slider_threshold,'Value',PARA.threshold_cur);
set(handles.edit_threshold_cur,'String',PARA.threshold_cur);
guidata(hObject, handles);
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

guidata(hObject, handles);


%% --- Executes on button press in cbox_overlay. --------------------------
function cbox_overlay_Callback(hObject, eventdata, handles)
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

guidata(hObject, handles);

%% --- Executes on button press in pb_compute.-----------------------------
function pb_compute_Callback(hObject, eventdata, handles)

handles = helper_compute(handles);

guidata(hObject, handles);


%% --- Executes on selection change in popup_show. ------------------------
function popup_show_Callback(hObject, eventdata, handles)

global PARA PREF;

show_cur = uint8(get(handles.popup_show,'Value'));

if show_cur ~= PARA.show % only do something if value changed
    PARA.show = show_cur;
%     threshold = str2double(get(handles.edit_threshold_cur,'String'));
    threshold = get(handles.slider_threshold,'Value');

   switch PARA.show 
       
       case 1 %reldiff
        PARA.threshold_min = 0;
%         handles.threshold_max = 0.5;
        PARA.threshold_max_rd = PREF.maxRelDiff;
        % convert tvalue-threshold to reldiff (threshold/20)*0.5
        PARA.threshold_cur_rd = PREF.maxRelDiff*(threshold/PREF.maxTvalues);
        PARA.threshold_cur_rd (PARA.threshold_cur_rd > PREF.maxRelDiff) = PREF.maxRelDiff;
    
       case 2 % tvalues
        PARA.threshold_min = 0;
%         handles.threshold_max = 20;
        PARA.threshold_max_tv = PREF.maxTvalues;
        % convert reldiff-threshold to tvalue (threshold/0.5)*20
        PARA.threshold_cur_tv = PREF.maxTvalues*(threshold/PREF.maxRelDiff);
        PARA.threshold_cur_tv(PARA.threshold_cur_tv > PREF.maxTvalues) = PREF.maxTvalues;
        
%        case 3 % corrcoeff
%         PARA.threshold_min = 0;
% %         handles.threshold_max = 0.5;
%         PARA.threshold_max_rd = PREF.maxRelDiff;
%         % convert tvalue-threshold to reldiff (threshold/20)*0.5
%         PARA.threshold_cur_rd = PREF.maxRelDiff*(threshold/PREF.maxTvalues);
%         PARA.threshold_cur_rd (PARA.threshold_cur_rd > PREF.maxRelDiff) = PREF.maxRelDiff;
    end
% 

gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
guidata(hObject, handles);
end

%% --- Executes during object creation, after setting all properties. -----
function popup_show_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ------------------------------------------------------------------------
function menuFile_removeData_Callback(hObject, eventdata, handles)

initialize( hObject, handles, 'remove' );

%% ------------------------------------------------------------------------
function edit_baseStart_Callback(hObject, eventdata, handles)

global PREF PARA;
PARA.baseStart_s = str2double(get(handles.edit_baseStart,'String'));
set(handles.edit_baseEnd,'String',num2str(PARA.baseStart_s + 10));
if PREF.stimParInd && PARA.showCurrDataSet
        PARA.cBaseStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimEnd,'String'));
elseif PREF.stimParInd && ~PARA.showCurrDataSet
    for i= 1:length(PARA.cBaseStart_s)
        PARA.cBaseStart_s{i} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{i} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{i} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{i} = str2double(get(handles.edit_stimEnd,'String'));
    end
end
 helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties. -----
function edit_baseStart_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ------------------------------------------------------------------------
function edit_baseEnd_Callback(hObject, eventdata, handles)

global PREF PARA;
PARA.baseEnd_s = str2double(get(handles.edit_baseEnd,'String'));
if PREF.stimParInd && PARA.showCurrDataSet
        PARA.cBaseStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimEnd,'String'));
elseif PREF.stimParInd && ~PARA.showCurrDataSet
    for i= 1:length(PARA.cBaseStart_s)
        PARA.cBaseStart_s{i} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{i} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{i} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{i} = str2double(get(handles.edit_stimEnd,'String'));
    end
end
 helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties. -----
function edit_baseEnd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ------------------------------------------------------------------------
function edit_stimStart_Callback(hObject, eventdata, handles)

global PARA PREF;
PARA.stimStart_s = str2double(get(handles.edit_stimStart,'String'));
set(handles.edit_stimEnd,'String',num2str(PARA.stimStart_s + 10));
if PREF.stimParInd && PARA.showCurrDataSet
        PARA.cBaseStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimEnd,'String'));
elseif PREF.stimParInd && ~PARA.showCurrDataSet
    for i= 1:length(PARA.cBaseStart_s)
        PARA.cBaseStart_s{i} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{i} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{i} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{i} = str2double(get(handles.edit_stimEnd,'String'));
    end
end
 helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties. -----
function edit_stimStart_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ------------------------------------------------------------------------
function edit_stimEnd_Callback(hObject, eventdata, handles)

global PREF PARA;
PARA.stimEnd_s = str2double(get(handles.edit_stimEnd,'String'));
if PREF.stimParInd && PARA.showCurrDataSet
        PARA.cBaseStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{PARA.showCurrDataSet} = str2double(get(handles.edit_stimEnd,'String'));
elseif PREF.stimParInd && ~PARA.showCurrDataSet
    for i= 1:length(PARA.cBaseStart_s)
        PARA.cBaseStart_s{i} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{i} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{i} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{i} = str2double(get(handles.edit_stimEnd,'String'));
    end
end
helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties. ---
function edit_stimEnd_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% --- Executes on slider movement. ---------------------------------------
function slider_frameNumber_Callback(hObject, eventdata, handles)

global PARA;
% uiwait(gcf,0.1);
PARA.currentFrame = uint16(round(get(handles.slider_frameNumber,'Value')));
helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);
% uiresume(gcf);
guidata(hObject, handles);

%% --- Executes during object creation, after setting all properties. -----
function slider_frameNumber_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



%% --- Executes on button press in pb_setROI. -----------------------------
function pb_setROI_Callback(hObject, eventdata, handles)

global DATA PARA;
% axes(handles.axes3);
set(gcf,'CurrentAxes',handles.displayOutput);

[DATA.BW{PARA.showCurrDataSet}] = roipoly(getimage(handles.displayOutput));
DATA.BW{PARA.showCurrDataSet} = imrotate(DATA.BW{PARA.showCurrDataSet},180);

calcTimecourse(PARA.showCurrDataSet,DATA.BW{PARA.showCurrDataSet});
 helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

set(handles.cbox_showROI,'Enable','on');
guidata(hObject, handles);

%% --- Executes on button press in pb_amroi.
function pb_amroi_Callback(hObject, eventdata, handles)

global DATA PARA;

    switch PARA.show 
        case 1
        masks = DATA.mask_reldiff_i;
        case 2
        masks = DATA.mask_tvalues_i;
%         case 3
%         masks = DATA.mask_CC_i;
    end
    % build activation mask
            try 
               DATA.BW{PARA.showCurrDataSet} = masks{PARA.showCurrDataSet};
            catch
              set(handles.txt_notification,'String',['No mask for dataset ' PARA.subdirs{1,PARA.showCurrDataSet} ' available! Please compute first!']); 
            end
%                 stats = regionprops(double(DATA.BW),'ConvexImage','BoundingBox');
%                 for i = 1:stats.BoundingBox(4)
%                     for j = 1:stats.BoundingBox(3)
%                         DATA.BW(round(stats.BoundingBox(2))+i,round(stats.BoundingBox(1))+j) = stats.ConvexImage(i,j);
%                     end
%                 end

calcTimecourse(PARA.showCurrDataSet,DATA.BW{PARA.showCurrDataSet});
helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);
set(handles.cbox_showROI,'Enable','on');

guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of pb_amroi

%% --- Executes on button press in pb_electrodePos. -----------------------
function pb_electrodePos_Callback(hObject, eventdata, handles)

global DATA PARA;

set(gcf,'CurrentAxes',handles.displayOutput);
% axes(handles.axes3);

[x, y] = ginput(2);  

% convert to row/column indices
DATA.electrodePosY{PARA.showCurrDataSet} = round(y);
DATA.electrodePosX{PARA.showCurrDataSet} = round(x);

set(handles.cbox_electrode,'Enable','On');
set(handles.cbox_electrode,'Value',1);
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

guidata(hObject, handles);


%% --- Executes on button press in cbox_electrode. ------------------------
function cbox_electrode_Callback(hObject, eventdata, handles)

% updateAxesPlot(handles);
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

guidata(hObject, handles);

%% ------------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)


%% ------------------------------------------------------------------------
function menuHelp_about_Callback(hObject, eventdata, handles)

global MISC;
% change parameters in initialize.m
msgbox(strvcat('OI analysis','Modul: Direct Cortical Stimulation','---','(c) Tobias Meyer, Martin Oelschlägel, Hannes Wahl',...
    ['Date: ' MISC.versionDate], ...
    ['Version Number: ' MISC.versionNr], ...
    ['Submitted by: ' MISC.submittedBy]), ...
    'About');

guidata(hObject, handles);


%% --- Executes on selection change in lb_subdir. -------------------------
function lb_subdir_Callback(hObject, eventdata, handles)

%% --- Executes during object creation, after setting all properties. -----
function lb_subdir_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% ------------------------------------------------------------------------
function menuFile_selectMultiDir_Callback(hObject, eventdata, handles)

% get preferences
% PREF = getappdata(0,'PREF');
global DATA PARA PREF MISC;
PARA.bin = PREF.spatialBinning;
PARA.tempbin = PREF.temporalBinning;

% get directory with image data
% pathname = uigetdir(handles.lastUsedFolder,'Select directory with
% images');
pathname = uigetdir(MISC.lastUsedPath,'Select directory with images');

if pathname ~= 0
    
    MISC.lastUsedPath = pathname;
    PARA.pathname = pathname;
    PARA.filenames = [];
    ind=regexp(PARA.pathname,'p\d{3}');
    PARA.currentPatient = PARA.pathname(ind:ind+3);
    PARA.subdirs = getSubdirFromDir(PARA.pathname);
    
    if length(PARA.subdirs) > 1
        for i=1:1:size(PARA.subdirs,2)
            field = char(PARA.subdirs(1,i));
            field = field(2:end);
            numbers(i,1) = str2num(field);
        end
        numbers = sort(numbers);
        for i=1:1:size(PARA.subdirs,2)
            numberstring = num2str(numbers(i,1));
            subdirs_sorted(1,i) = cellstr(strcat('s',numberstring));
        end
        PARA.subdirs(1,:) = subdirs_sorted(1,:);
    end
    
    for i = 1:1:size(PARA.subdirs,2)
        % get the image file names
        f = getFilenamesFromDir([PARA.pathname,'\\',PARA.subdirs{1,i}],'tif');
        PARA.filenames{i} = f;
        
        % get the time info
        timeInfo = dir([PARA.pathname,'\', PARA.subdirs{1,i},'\','*.info']);
        if isempty(timeInfo)
            timeInfo = dir([PARA.pathname,'\', PARA.subdirs{1,i},'\','*.xml']);
        end
        
        try
           [info] = getTimevector([PARA.pathname,'\', PARA.subdirs{1,i},'\',timeInfo.name]);
        catch
            [info] = zviMetaScanner([PARA.pathname,'\', PARA.subdirs{1,i},'\',timeInfo.name]);
            info.bit = 12;
        end
        
        PARA.grayMax = 2^info.bit - 1;
        
        DATA.time_s{i} = info.time_ms./1000;
        DATA.time_s_binned{i} = DATA.time_s{i}(1:PARA.tempbin:end);
        
        PARA.nFrames{i} = length(info.time_ms);
        PARA.nFrames_binned{i} = ceil(PARA.nFrames{i}./PARA.tempbin);
        
        PARA.nDataPoints{i} = PARA.nFrames{i};
        PARA.nDataPoints_binned{i} = ceil(PARA.nFrames{i}./PARA.tempbin);
        
        % initialize subdirs cell
        PARA.subdirs{2,i} = false;
    %  may cause trouble with update-folder functionality
        DATA.mask_reldiff_i{i} =[];
        DATA.mask_tvalues_i{i} =[];
%         DATA.mask_CC_i{i} =[];
        DATA.relDiffPos{i} = [];
        PARA.computed(i) = false;
        
        PARA.cBaseStart_s{i} = str2double(get(handles.edit_baseStart,'String'));
        PARA.cBaseEnd_s{i} = str2double(get(handles.edit_baseEnd,'String'));
        PARA.cStimStart_s{i} = str2double(get(handles.edit_stimStart,'String'));
        PARA.cStimEnd_s{i} = str2double(get(handles.edit_stimEnd,'String'));
    end
    
    frame1 = imread( [PARA.pathname,'\\', PARA.subdirs{1,1},'\\',PARA.filenames{1}(1,:) ] );
    
    nRows = size(frame1,1);
    nCols = size(frame1,2);
    
    PARA.frameSize = [nRows nCols];
    PARA.frameSize_binned = [ceil(nRows./PARA.bin) ceil(nCols./PARA.bin)];
    
    DATA.electrodePosX = cell(size(PARA.subdirs,2),1);
    DATA.electrodePosY = cell(size(PARA.subdirs,2),1);
    
%    if (~isempty(PARA.filenames) && PARA.nFrames( ~= 0)
%        set(handles.pb_getData,'Enable','On');
%    end
    
    % set up list box

    set(handles.lb_subdir,'String',PARA.subdirs(1,:));
    set(handles.lb_subdir,'Value',1);
    % enable show-button
    set(handles.pb_showCurrDataSet,'Enable','on');
    set(handles.pb_add,'Enable','on');
    set(handles.pb_addall,'Enable','on');
    set(handles.txt_currentPatient,'String',PARA.currentPatient);
    set(handles.pb_updateFolders,'Enable','on');
    PARA.subdirProperties = folderSizeTree(PARA.pathname);
    
end

guidata(hObject, handles);


%% --- Executes on selection change in lb_dirsToAnalyze. ------------------
function lb_dirsToAnalyze_Callback(hObject, eventdata, handles)


%% --- Executes during object creation, after setting all properties. -----
function lb_dirsToAnalyze_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in pb_add. --------------------------------
function pb_add_Callback(hObject, eventdata, handles)

global PARA PREF;
selection = uint8(get(handles.lb_subdir,'Value'));
if ~PARA.subdirs{2,selection}
    
    PARA.subdirs{2,selection} = true;
    if PARA.computed(selection) %&& isempty(strmatch('*',PARA.subdirs{1,selection})) 
        str = [PARA.subdirs{1,selection} '*'];
    else
        str = PARA.subdirs{1,selection};
    end
    
    PARA.dirsToAnalyze{length(PARA.dirsToAnalyze)+1} = str;
    if length(PARA.dirsToAnalyze) > 1
        helper_sortList();
    end
    
    
    if PREF.stimParInd && ~isempty(PARA.cBaseStart_s{selection})
        set(handles.edit_baseStart,'String',PARA.cBaseStart_s{selection});
        set(handles.edit_baseEnd,'String',PARA.cBaseEnd_s{selection});
        set(handles.edit_stimStart,'String',PARA.cStimStart_s{selection});
        set(handles.edit_stimEnd,'String',PARA.cStimEnd_s{selection});
%         guidata(hObject, handles);
    end
    
    
    set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);
    set(handles.lb_dirsToAnalyze,'Value',1);
    set(handles.pb_compute,'Enable','on');
    set(handles.pb_remove,'Enable','on');
    set(handles.pb_removeall,'Enable','on');
    set(handles.pb_showCurrDataSet,'Enable','on');
    
    set(handles.edit_currentDataSet,'Enable','on');
    
    set(handles.txt_notification,'String','Remember to COMPUTE to get a correct image!');
    
    
       
    pb_showCurrDataSet_Callback(hObject, eventdata, handles);
%     guidata(hObject, handles);
end

%% --- Executes on button press in pb_addall.
function pb_addall_Callback(hObject, eventdata, handles)

global PARA;
for i = 1:1:size(PARA.subdirs,2)
       if ~PARA.subdirs{2,i}
           
        PARA.subdirs{2,i} = true;   
        
        if PARA.computed(i) %&& isempty(strmatch('*',PARA.subdirs{1,i})) 
            str = [PARA.subdirs{1,i} '*'];
        else
            str = PARA.subdirs{1,i};
        end          
        
        PARA.dirsToAnalyze{length(PARA.dirsToAnalyze)+1} = str;
        if length(PARA.dirsToAnalyze) > 1
            helper_sortList();
        end
        
     
       end
end
try % if electrode position have been externally loaded
    if ~isempty(DATA.electrodePosX{1})
        set(handles.cbox_electrode,'Enable','on');
    end
catch
end
set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);
set(handles.lb_dirsToAnalyze,'Value',1);
set(handles.pb_compute,'Enable','on');
set(handles.pb_remove,'Enable','on');
set(handles.pb_removeall,'Enable','on');
set(handles.pb_showCurrDataSet,'Enable','on');

set(handles.edit_currentDataSet,'Enable','on');

    set(handles.txt_notification,'String','Remember to COMPUTE to get a correct image!');

pb_showCurrDataSet_Callback(hObject, eventdata, handles);
% guidata(hObject, handles);

%% --- Executes on button press in pb_remove. -----------------------------
function pb_remove_Callback(hObject, eventdata, handles)

global PARA;
if ~isempty(get(handles.lb_dirsToAnalyze,'String'))
    selection = uint8(get(handles.lb_dirsToAnalyze,'Value'));

    buf = PARA.dirsToAnalyze{selection};
    for i = 1:1:size(PARA.subdirs,2)
        str = PARA.subdirs{1,i};
        if strcmp(str,buf) || strcmp([str '*'], buf)
            PARA.subdirs{2,i} = false;
            break;
        end
    end
    
    PARA.dirsToAnalyze(selection) = [];
        
    if size(PARA.dirsToAnalyze) > 1
        helper_sortList();
    end

%     set(handles.lb_dirsToAnalyze,'Value',1);
    set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);


end

if isempty(PARA.dirsToAnalyze)
    
    PARA.showCurrDataSet = 0;
    
    set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);
    
    set(handles.pb_compute,'Enable','off');
    set(handles.pb_remove,'Enable','off');
    set(handles.pb_removeall,'Enable','off');
    set(handles.pb_showCurrDataSet,'Enable','off');
    
    set(handles.edit_currentDataSet,'Enable','off');
    guidata(hObject, handles);
else
    if selection > 1
        selection = selection - 1;
    end
    set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);
    set(handles.lb_dirsToAnalyze,'Value',selection);
    set(handles.txt_notification,'String','Remember to COMPUTE to get a correct image!');
    pb_showCurrDataSet_Callback(hObject, eventdata, handles);
end
% updateAxesDiff( handles );



%% --- Executes on button press in pb_removeall.
function pb_removeall_Callback(hObject, eventdata, handles)

global PARA;
if ~isempty(get(handles.lb_dirsToAnalyze,'String'))
    PARA.dirsToAnalyze = {};
    
    for i = 1:1:size(PARA.subdirs,2)
        PARA.subdirs{2,i} = false;
    end
end

PARA.showCurrDataSet = 0;
set(handles.lb_dirsToAnalyze,'String',PARA.dirsToAnalyze);

set(handles.pb_compute,'Enable','off');
set(handles.pb_remove,'Enable','off');
set(handles.pb_removeall,'Enable','off');
set(handles.pb_showCurrDataSet,'Enable','off');

set(handles.edit_currentDataSet,'Enable','on');

set(handles.txt_notification,'String','Ready');

guidata(hObject, handles);

%% --- Executes on button press in pb_showCurrDataSet. --------------------
function pb_showCurrDataSet_Callback(hObject, eventdata, handles)

global DATA PARA PREF;
% PARA.showCurrDataSet = get(handles.lb_dirsToAnalyze,'Value');
selection = uint8(get(handles.lb_dirsToAnalyze,'Value'));
buf = PARA.dirsToAnalyze{selection};

for i = 1:1:size(PARA.subdirs,2)

    str = PARA.subdirs{1,i};      
    if strcmp(str,buf) || strcmp([str '*'], buf)
        PARA.showCurrDataSet = uint8(i);
    end
end

PARA.currentFrame = uint16(1);

DATA.timecourse = [];
DATA.BW{PARA.showCurrDataSet} = [];


if PREF.stimParInd && ~isempty(PARA.cBaseStart_s{PARA.showCurrDataSet})
    set(handles.edit_baseStart,'String',PARA.cBaseStart_s{PARA.showCurrDataSet});
    set(handles.edit_baseEnd,'String',PARA.cBaseEnd_s{PARA.showCurrDataSet});
    set(handles.edit_stimStart,'String',PARA.cStimStart_s{PARA.showCurrDataSet});
    set(handles.edit_stimEnd,'String',PARA.cStimEnd_s{PARA.showCurrDataSet});
end

set(handles.slider_frameNumber,'Enable','on');
set(handles.slider_frameNumber,'Min',1);
set(handles.slider_frameNumber,'Max',PARA.nFrames{PARA.showCurrDataSet});
set(handles.slider_frameNumber,'Value',PARA.currentFrame);

set(handles.edit_currentDataSet,'Enable','on');
set(handles.edit_currentDataSet,'String',PARA.subdirs{1,PARA.showCurrDataSet} );

set(handles.pb_electrodePos,'Enable','on');
set(handles.pb_setROI,'Enable','on');

set(handles.cbox_showROI,'Value',0);
set(handles.cbox_showROI,'Enable','off');

% guidata(hObject, handles);

helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

guidata(hObject, handles);


%% --------------------------------------------------------------------
function menu_edit_Callback(hObject, eventdata, handles)


%% --- Executes during object creation, after setting all properties.
function edit_method_delete_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_method_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in cbox_img_opt.
function cbox_img_opt_Callback(hObject, eventdata, handles)
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
% Hint: get(hObject,'Value') returns toggle state of cbox_img_opt


% --- Executes on button press in cbox_activation.
function cbox_activation_Callback(hObject, eventdata, handles)
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
% Hint: get(hObject,'Value') returns toggle state of cbox_activation

% --- Executes on button press in tb_bg_only.
function tb_bg_only_Callback(hObject, eventdata, handles)

if get(handles.tb_bg_only,'Value')
%     set(handles.cbox_overlay,'Value',0);
%     set(handles.cbox_img_opt,'Value',0);
    set(handles.cbox_activation,'Value',0);
    set(handles.cbox_overlay,'Enable','off');
%     set(handles.cbox_img_opt,'Enable','off');
    set(handles.cbox_activation,'Enable','off');
else
    set(handles.cbox_overlay,'Enable','on');
%     set(handles.cbox_img_opt,'Enable','on');
    set(handles.cbox_activation,'Enable','on');
end
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

% --- Executes on button press in cbox_activation_contour.
function cbox_mask_contour_Callback(hObject, eventdata, handles)

% updateAxesPlot(handles);
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
% Hint: get(hObject,'Value') returns toggle state of cbox_activation_contour


% --- Executes on button press in pb_updateFolders.
function pb_updateFolders_Callback(hObject, eventdata, handles)

global DATA PARA PREF;
% get preferences

PARA.bin = PREF.spatialBinning;
PARA.tempbin = PREF.temporalBinning;

watchDir = folderSizeTree(PARA.pathname);
dir = PARA.subdirProperties;
if length(dir.name) ~= length(watchDir.name)
    
    PARA.subdirs = getSubdirFromDir(PARA.pathname);
    for i=1:1:size(PARA.subdirs,2)
        field = char(PARA.subdirs(1,i));
        field = field(2:end);
        numbers(i,1) = str2num(field);
    end
    numbers = sort(numbers);
    for i=1:1:size(PARA.subdirs,2)
        numberstring = num2str(numbers(i,1));
        subdirs_sorted(1,i) = cellstr(strcat('s',numberstring));
    end
    PARA.subdirs(1,:) = subdirs_sorted(1,:);
    
    for i = 1:1:size(PARA.subdirs,2)
        % get the image file names
        f = getFilenamesFromDir([PARA.pathname,'\\',PARA.subdirs{1,i}],'tif');
        PARA.filenames{i} = f;
        
        % get the time info
        [info] = getTimevector([PARA.pathname,'\', PARA.subdirs{1,i},'\','time.info']);
        
        DATA.time_s{i} = info.time_ms./1000;
        DATA.time_s_binned{i} = DATA.time_s{i}(1:PARA.tempbin:end);
        
        PARA.nFrames{i} = length(info.time_ms);
        PARA.nFrames_binned{i} = ceil(PARA.nFrames{i}./PARA.tempbin);
        
        PARA.nDataPoints{i} = PARA.nFrames{i};
        PARA.nDataPoints_binned{i} = ceil(PARA.nFrames{i}./PARA.tempbin);
        
        PARA.subdirs{2,i} = false;
%         DATA.mask_reldiff_i{i} =[];
%         DATA.mask_tvalues_i{i} =[];
%         DATA.relDiffPos{i} = [];
        try
            isempty(DATA.mask_reldiff_i{i});
        catch
            DATA.mask_reldiff_i{i} =[];
        end
        try
            isempty(DATA.mask_tvalues_i{i});
        catch
           DATA.mask_tvalues_i{i} =[];
        end
        try
            isempty(DATA.relDiffPos{i});
        catch
            DATA.relDiffPos{i} = [];
            DATA.tvaluesPos{i} = [];
        end
        try
            isempty(PARA.computed(i));
        catch
            PARA.computed(i) = false;
        end
        try
            isempty(PARA.cBaseStart_s{i});
        catch
            PARA.cBaseStart_s{i}  = [];
            PARA.cBaseEnd_s{i}  = [];
            PARA.cStimStart_s{i}  = [];
            PARA.cStimEnd_s{i} = [];
        end
    end
    % save new properties
    PARA.subdirProperties = watchDir;
    % update list box
    set(handles.lb_subdir,'String',PARA.subdirs(1,:));
    set(handles.txt_notification,'String','Added datasets should be computed separately.');
end

guidata(hObject, handles);


%% --------------------------------------------------------------------
function menuEdit_detectTrepanation_Callback(hObject, eventdata, handles)

global DATA PARA;
selected = PARA.dirsToAnalyze{get(handles.lb_dirsToAnalyze,'Value')};

for i = 1:1:size(PARA.subdirs,2)
    if strcmp(PARA.subdirs{1,i},selected) || strcmp([PARA.subdirs{1,i} '*'],selected)
        dataSet = i;
        break;
    end
end
I = imread([PARA.pathname,'\', PARA.subdirs{1,dataSet},'\',PARA.filenames{dataSet}(50,:) ]);
I = imrotate(double(I), 180);
I = uint8(I./PARA.grayMax.*256);

DATA.trepanationMask{dataSet} = trepanation_mask(I,1);
set(handles.cbox_trepanation, 'Enable', 'on');
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
guidata(hObject, handles);


% --- Executes on button press in cbox_trepanation.
function cbox_trepanation_Callback(hObject, eventdata, handles)

% updateAxesPlot(handles);
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);


% --------------------------------------------------------------------
function menuEdit_Eval_Callback(hObject, eventdata, handles)

global DATA PARA;
DATA.currentImage_export = imread([PARA.pathname,'\', PARA.subdirs{1,PARA.showCurrDataSet},'\',PARA.filenames{PARA.showCurrDataSet}(PARA.currentFrame,:) ]);
% handles.activationImage_export = getappdata(0, 'activationImage_export');
% setappdata(0, 'export_handles', handles);
Evaluation();


%% --------------------------------------------------------------------
function menuEdit_setActivationMask_Callback(hObject, eventdata, handles)

global DATA PARA PREF;
% modus = questdlg('(1) Find new activation in ROI or (2) cut actual activation to ROI?','Choose what to do','(1)','(2)','Cancel','(1)');
% if ~strcmp(modus,'Cancel')

    set(gcf,'CurrentAxes',handles.displayOutput);
    frame = DATA.activationImage_export;

    BW = rot90(roipoly(frame),2);

    % get selection lb_dirs2analyze
    % roipoly -> gebiet für maskenanalyse
    % neue maske erstellen mit definierterem gebiet
    selected = get(handles.lb_dirsToAnalyze,'Value');
    % dir2analyze = strings{selected};
    radius = PREF.radius;
    maxdist = PREF.maxdist;

    for i = 1:1:size(PARA.subdirs,2)
        if strcmp(PARA.subdirs{1,i},PARA.dirsToAnalyze{selected}) ||strcmp([PARA.subdirs{1,i} '*'],PARA.dirsToAnalyze{selected})
%             try
%                 switch modus
%                     case '(1)'
                        if PARA.show == 1
                           DATA.mask_reldiff_i{i} = determineMask('image',DATA.relDiffPos{i},'aoi',BW,'modus', 1,'ep',{DATA.electrodePosX{i} DATA.electrodePosY{i}});
                           DATA.jointRelDiff = DATA.jointRelDiff.* BW ;
                        elseif PARA.show == 2
                           DATA.mask_tvalues_i{i} = determineMask('image',DATA.tvaluesPos{i},'aoi',BW, 'modus', 0,'ep',{DATA.electrodePosX{i} DATA.electrodePosY{i}});
                           DATA.jointTvalues = DATA.jointTvalues.* BW;
                        end
                    DATA.formFactors{i,1} = PARA.subdirs{1,i};
                    DATA.formFactors{i,2} = determineFormFactors(DATA.mask_tvalues_i{i});
                    DATA.formFactors{i,3} = determineFormFactors(DATA.mask_reldiff_i{i});
                    
                    DATA.formFactors{i,2}.Max = max(DATA.tvaluesPos{i}(DATA.mask_tvalues_i{i}));
                    DATA.formFactors{i,2}.Min = min(DATA.tvaluesPos{i}(DATA.mask_tvalues_i{i}));
                    DATA.formFactors{i,2}.Mean = mean(DATA.tvaluesPos{i}(DATA.mask_tvalues_i{i}));
                    DATA.formFactors{i,2}.Std = std(DATA.tvaluesPos{i}(DATA.mask_tvalues_i{i}));

                    DATA.formFactors{i,3}.Max = max(DATA.relDiffPos{i}(DATA.mask_reldiff_i{i}));
                    DATA.formFactors{i,3}.Min = min(DATA.relDiffPos{i}(DATA.mask_reldiff_i{i})); 
                    DATA.formFactors{i,3}.Mean = mean(DATA.relDiffPos{i}(DATA.mask_reldiff_i{i}));
                    DATA.formFactors{i,3}.Std = std(DATA.relDiffPos{i}(DATA.mask_reldiff_i{i}));
                    
%                     case '(2)'
%                         if PARA.show == 1
%                            handles.jointRelDiff = handles.jointRelDiff.* BW ;
%                         elseif PARA.show == 2
%                            handles.jointTvalues = jointTvalues.* BW; 
%                         end
%                 end
%             catch
%               set(handles.txt_notification,'String',['No mask for dataset ' PARA.subdirs{1,i} ' available! Please compute first!']); 
%             end
            break;
        end
    end
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
    guidata(hObject, handles);
% end


% --------------------------------------------------------------------
function menuEdit_preferences_Callback(hObject, eventdata, handles)

Preferences();


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

delete(Preferences);
delete(hObject);
global DATA PARA PREF MISC;
% clear global variables
clear global DATA PARA PREF MISC;
% --------------------------------------------------------------------
function menuFile_Quit_Callback(hObject, eventdata, handles)


% close Preferences window
delete(Preferences);
% close OI_analysis_DCS window
delete(OI_analysis_DCS);
global DATA PARA PREF MISC;
% clear global variables
clear global DATA PARA PREF MISC;

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lb_dirsToAnalyze.
function lb_dirsToAnalyze_ButtonDownFcn(hObject, eventdata, handles)

pb_showCurrDataSet_Callback(hObject, eventdata, handles);


% --- Executes on button press in cbox_showROI.
function cbox_showROI_Callback(hObject, eventdata, handles)

% updateAxesPlot(handles);
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);

guidata(hObject, handles);




%% ---
function edit_currentDataSet_Callback(hObject, eventdata, handles)

S= handles.dirsToAnalyze; % cellarray of chosen datasets
test_str = uint8(get(handles.edit_currentDataSet,'String')); % dataset given by user
for i=1:1:length(S)
    if strcmp(S{i}, test_str)
        str = test_str;
    elseif strcmp(S{i}, [test_str '*'])
        str = [test_str '*'];
    end
end

selection = strmatch(str,S,'exact');

if ~isempty(selection) % check for exact match of strings --> if user-given string is not available, notify user of failure
    set(handles.lb_dirsToAnalyze,'Value',selection);
    set(handles.txt_notification,'String',['Busy']);
    pb_showCurrDataSet_Callback(hObject, eventdata, handles);
else
    set(handles.edit_currentDataSet,'String','');
    set(handles.txt_notification,'String',['Input "', str, '" is either not valid or not available as da dataset.']);
    guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function axes_cbar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_cbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_cbar


% --- Executes during object creation, after setting all properties.
function edit_currentDataSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currentDataSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in cbox_forceRecompute.
function cbox_forceRecompute_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_forceRecompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_forceRecompute


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pb_setROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_setROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%



%% --------------------------------------------------------------------
function menu_sDVis_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sDVis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PARA;

PARA.secDisplay_gui_elements = helper_getGUIControlValues(handles);
if ~PARA.secDisplayOpen 
    
    secDisplayOutput();
    secDisplayFigure = findobj('Name','secDisplayOutput');
    monpos = get(0,'MonitorPositions');
    figpos = get(secDisplayFigure, 'Position');
    try
        if (monpos(2,1) > 0)
        xpos = (monpos(2,3)-monpos(2,1))/2 + monpos(2,1) - figpos(1,3)/2;
        ypos = (monpos(2,4)/2) - figpos(1,4)/2;
        else
        xpos = (monpos(2,1))/2 - figpos(1,3)/2;
        ypos = (monpos(2,4)/2) - figpos(1,4)/2;
        end
        set(secDisplayFigure,'Position',[xpos ypos figpos(1,3) figpos(1,4)])
        PARA.secDisplayOpen = true;
    catch
        h = msgbox('No second display found, opening on primary display' ,'Error' ,'error');
    end
else
    secDisplayOutput('updateSecDisplay')
end



% --- Executes on button press in cbox_legend.
function cbox_legend_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_legend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_elements = helper_getGUIControlValues(handles);
updateAxes(gui_elements);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of cbox_legend




% --------------------------------------------------------------------
function menu_external_Callback(hObject, eventdata, handles)
% hObject    handle to menu_external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuExternal_commandChain_Callback(hObject, eventdata, handles)
% hObject    handle to menuExternal_commandChain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
commandChain



% --------------------------------------------------------------------
function menuExternal_loadTrep_Callback(hObject, eventdata, handles)
% hObject    handle to menuExternal_loadTrep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = loadTrepElec;

if t(2)
    set(handles.cbox_electrode,'Enable','On');
    set(handles.cbox_electrode,'Value',1);
end
guidata(hObject, handles);


% --- Executes on button press in pb_EllipROI.
function pb_EllipROI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_EllipROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DATA PARA;
% axes(handles.axes3);
set(gcf,'CurrentAxes',handles.displayOutput);

% [DATA.BW] = roipoly(getimage(handles.displayOutput));
% DATA.BW = imrotate(DATA.BW,180);
i = PARA.showCurrDataSet;
EP = {DATA.electrodePosX{i} DATA.electrodePosY{i}};
EP_center = [ round((EP{1}(1) + EP{1}(2))/2) round((EP{2}(1) + EP{2}(2))/2) ];
EP_radius = round(sqrt( (EP{2}(1)-EP{2}(2))^2 + (EP{1}(1)-EP{1}(2))^2 ));
mask = false(PARA.frameSize);
circ = logical(imcircle(EP_radius+1));
mask(EP_center(2)-(EP_radius/2):EP_center(2)+(EP_radius/2), EP_center(1)-(EP_radius/2):EP_center(1)+(EP_radius/2)) =circ;
DATA.BW{PARA.showCurrDataSet} = rot90(mask, 2) & rot90(DATA.trepanationMask{PARA.showCurrDataSet},2);


calcTimecourse(PARA.showCurrDataSet,DATA.BW{PARA.showCurrDataSet});
 helper_checkShownDataset(handles);
updateTimecourse(handles.displayTimecourse);

set(handles.cbox_showROI,'Enable','on');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menuExternal_MoveTC_Callback(hObject, eventdata, handles)
% hObject    handle to menuExternal_MoveTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Test();
