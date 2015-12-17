%% --- Initialization -----------------------------------------------------
function initialize( hObject, handles, mode )

%% declare global variables for easier maintenance

if strcmp(mode,'remove')
    clear global DATA;
    clear global PARA;
end

global DATA; % data storage
global PREF; % preferences
global PARA; % parameters (threshold values, slider positions, image type,...)
global MISC; % miscellaneous 

% version, date and submitted by
MISC.versionNr = '3.0 RC3';
MISC.versionDate = '15.02.2012';
MISC.submittedBy = 'Martin Oelschlägel & Hannes Wahl';
if strcmp(mode,'init')
    MISC.lastUsedPath = '..\IOI_Datensaetze\';
end
%% parameter (default initialization)
PARA.bin = 1;
PARA.tempbin = 1;
PARA.smoothFilterSize = 11;
% handles.isOverlay = false;
% handles.isElectrode = false;
PARA.show = uint8(0);
PARA.nFrames = {};
PARA.nFrames_binned = {};
PARA.nDataPoints = {};
PARA.nDataPoints_binned = {};
PARA.frameSize = [0 0];
PARA.frameSize_binned = [0 0];
PARA.grayMax = 0;

PARA.pathname = [];
PARA.filenames = {};
PARA.subdirs = {};
PARA.dirsToAnalyze = {};
PARA.subdirProperties = [];

PARA.computed = []; % save computation status 

PARA.showCurrDataSet = uint8(0);
PARA.currentPatient = '';

PARA.baseStart_s = 10;
PARA.baseEnd_s = 20;
PARA.stimStart_s = 40;
PARA.stimEnd_s = 50;

PARA.cBaseStart_s = {};
PARA.cBaseEnd_s = {};
PARA.cStimStart_s = {};
PARA.cStimEnd_s = {};

PARA.currentFrame = uint16(1);
PARA.secDisplay = 0;

PARA.threshold_min = 0;
PARA.threshold_max_rd = 0.2;
PARA.threshold_max_tv = 20;
PARA.threshold_cur_rd = 0.1;
PARA.threshold_cur_tv = 10;

PARA.medianfiltersize = 10;
PARA.strelsize = 60;
PARA.graylvlfactor = 0.7;

PARA.secDisplayOpen = 0;
PARA.showCurrDataSet = 0;

%% data
DATA.currentImage_export = [];
DATA.activationImage_export = [];

DATA.backgroundFrame = [];
DATA.meanBase = [];
DATA.meanStim = [];
DATA.varBase = [];
DATA.varStim = [];
DATA.tvalues = {};
DATA.reldiff = {};
% DATA.CC      = {};

DATA.electrodePosX = {};
DATA.electrodePosY = {};
DATA.BW = {};
DATA.timecourse = [];
DATA.trepanationMask = {};
DATA.trepanationSet = [];

DATA.smoothFilter = fspecial('gaussian',PARA.smoothFilterSize,PARA.smoothFilterSize*0.1213);

DATA.mask_reldiff = [];
DATA.mask_tvalues = [];
% DATA.mask_CC = [];
DATA.mask_reldiff_i = {};
DATA.mask_tvalues_i = {};
% DATA.mask_CC_i = {};

DATA.formFactors = {};

DATA.jointRelDiff = [];
DATA.jointTvalues = [];
% DATA.jointCC = [];
DATA.jointRelDiffOriginal = [];
DATA.jointTvaluesOriginal = [];
% DATA.jointCCOriginal = [];


%% initialize preferences
if strcmp(mode,'init') % only on startup
%     handles.lastUsedDir = 'H:\work\IOI_Datensaetze\p064';

    PREF.radius = 5;
    PREF.maxdist = 80;

    PREF.staticThreshold = true;
    PREF.thresholdRelDiff = 0.02;
    PREF.thresholdTvalues = 4;
    PREF.differentColors = false;

    PREF.stimParInd = true;
    
    PREF.maxRelDiff = 0.1;
    PREF.maxTvalues = 20;

    PREF.smoothFilterSize = 11;
    PREF.spatialBinning = 1;
    PREF.temporalBinning = 1;

    PREF.drawElectrodeConn = true;
    PREF.drawElectrodeConnPar = uint8(2);
    PREF.colors = ['r';'g';'b';'c';'m';'y';'k';'w'];
    PREF.colorsLong = {'red';'green';'blue';'cyan';'magenta';'yellow';'black';'white'};
    % PREF.colors = lines(64);

%     setappdata(0, 'PREF', PREF);
    % save PREF in default for backup
    setappdata(0, 'default', PREF);
end

%% initialize gui elements

set(handles.edit_baseStart,'String',num2str(PARA.baseStart_s));
set(handles.edit_baseEnd,'String',num2str(PARA.baseEnd_s));
set(handles.edit_stimStart,'String',num2str(PARA.stimStart_s));
set(handles.edit_stimEnd,'String',num2str(PARA.stimEnd_s));

% welcome message
if strcmp(mode,'init') % only on startup
set(handles.txt_notification,'String', ...
    ['Welcome to "OI analysis-Module for Direct Cortical Stimulation"! You are using version '...
    MISC.versionNr ' released at ' ...
    MISC.versionDate ' and submitted by '...
    MISC.submittedBy '.' ]);
end
% axes(handles.displayOutput);
set(gcf,'CurrentAxes',handles.displayOutput);
image(zeros(488,612));
axis image;
colormap(gray);

set(handles.displayOutput,'Visible', 'off','Units', 'pixels');
set(handles.displayOutput,'XTickLabel','');
set(handles.displayOutput,'YTickLabel','');
set(handles.displayOutput,'XTick',[]);
set(handles.displayOutput,'YTick',[]);

% axes(handles.axes_cbar);
set(gcf,'CurrentAxes',handles.axes_cbar);
image(ones(256,20,'double').*0.9*256);
colormap(gray(256));

set(handles.axes_cbar,'Visible', 'off','Units', 'pixels');
                             
set(handles.slider_threshold,'Min',PARA.threshold_min);
set(handles.slider_threshold,'Max',PARA.threshold_max_tv);
set(handles.slider_threshold,'Value',PARA.threshold_cur_tv);
set(handles.edit_threshold_cur,'String',num2str(PARA.threshold_cur_tv));

% deactivate all ui-elements which shouldn't be touched
set(handles.cbox_overlay,'Enable','off');
set(handles.cbox_activation,'Enable','off');
set(handles.cbox_electrode, 'Enable', 'off');
set(handles.cbox_mask_contour, 'Enable', 'off');
set(handles.cbox_trepanation, 'Enable', 'off');
set(handles.cbox_forceRecompute,'Enable','off');
set(handles.cbox_showROI,'Enable','off');
set(handles.cbox_legend,'Enable','off');

set(handles.slider_frameNumber,'Enable','off');
set(handles.slider_threshold,'Enable','off');

set(handles.edit_threshold_cur,'Enable','off');
set(handles.edit_currentDataSet,'Enable','off');
set(handles.edit_currentDataSet,'String','');

set(handles.popup_show,'Enable','off');

set(handles.pb_compute,'Enable','off');
set(handles.pb_showCurrDataSet,'Enable','off');
set(handles.pb_electrodePos,'Enable','off');
set(handles.pb_amroi,'Enable','off');
set(handles.pb_setROI,'Enable','off');
set(handles.pb_add,'Enable','off');
set(handles.pb_addall,'Enable','off');
set(handles.pb_remove,'Enable','off');
set(handles.pb_removeall,'Enable','off');
set(handles.pb_updateFolders,'Enable','off');

set(handles.tb_bg_only,'Enable','off');

% load colormap
%S = load('cmap_diff.mat');
S = load('cmap_power3.mat');
DATA.cmap_diff = S.cmap_power3;

% set up color bar
DATA.CBar_diff = (0:1:255)';
DATA.CBar_diff = repmat(flipud(DATA.CBar_diff),1,20);
DATA.CBar_diff = ind2rgb(DATA.CBar_diff,DATA.cmap_diff);

% load colormaps
clear S;

if strcmp(mode,'remove')
    % clean and reset the gui
    set(handles.lb_subdir,'String','');
    set(handles.lb_dirsToAnalyze,'String','');
    
%     set(handles.txt_frameInfo_frame,'String','');
%     set(handles.txt_frameInfo_time,'String','');
%     set(handles.txt_currentDataSet,'String','');
    
    set(handles.txt_currentPatient,'String','');

    set(handles.popup_show,'String',{'---'});
    set(handles.popup_show,'Value',1);
         
    set(handles.cbox_overlay,'Value',0);
    set(handles.cbox_electrode,'Value',0);
    set(handles.cbox_forceRecompute,'Value',0);

    % reset timecourse axes
%     axes(handles.displayTimecourse);
    set(gcf,'CurrentAxes',handles.displayTimecourse);

    limit_x(1) = 0;
    limit_x(2) = 1;

    limit_y(1) = 0;
    limit_y(2) = 1;
    

    plot([0 1],[0 1], 'LineStyle','none');
    hold on
    rectangle('Position',[PARA.baseStart_s, limit_y(1), PARA.baseEnd_s-PARA.baseStart_s, limit_y(2)-limit_y(1)],'FaceColor','y','LineStyle','none');
    rectangle('Position',[PARA.stimStart_s, limit_y(1), PARA.stimEnd_s-PARA.stimStart_s, limit_y(2)-limit_y(1)],'FaceColor','y','LineStyle','none');
    plot(limit_x,limit_y,'LineStyle','none');
    
    set(gca,'XLim',limit_x);
    set(gca,'YLim',limit_y);
    set(gca,'XGrid','on');
    xlabel('time (in s)')
    ylabel('gray value')
    hold off
    
    % reset axes1, it needs to be this big array of zeros, otherwise there
    % will be colored remains of previous calculations
%     axes(handles.displayOutput);
    set(gcf,'CurrentAxes',handles.displayOutput);
    image(zeros(488,612));
    axis image;
    colormap(gray);
% 
    set(handles.displayOutput,'Visible', 'off','Units', 'pixels');
    set(handles.displayOutput,'XTickLabel','');
    set(handles.displayOutput,'YTickLabel','');
    set(handles.displayOutput,'XTick',[]);
    set(handles.displayOutput,'YTick',[]);
%     
% % %     axes(handles.axes3);
% %     set(gcf,'CurrentAxes',handles.axes3);
% %     image(zeros(800,800));
% %     colormap(gray);
% 
%     set(handles.axes3,'Visible', 'on','Units', 'pixels');
%     set(handles.axes3,'XTickLabel','');
%     set(handles.axes3,'YTickLabel','');
%     set(handles.axes3,'XTick',[]);
%     set(handles.axes3,'YTick',[]);
    
%     set(handles.txt_cbar_bottom,'String','0');
%     set(handles.txt_cbar_top,'String',num2str(handles.threshold_cur));
end

guidata(hObject, handles);

% sb = statusbar(OI_analysis_DCS,'Initializing...');
% set(sb.CornerGrip, 'visible','off');
% statusbar( ...
%     ['Welcome to "OI analysis-Module for Direct Cortical Stimulation"! You are using version '...
%     handles.versionNr ' released at ' ...
%     handles.versionDate ' and submitted by '...
%     handles.submittedBy '.' ]);