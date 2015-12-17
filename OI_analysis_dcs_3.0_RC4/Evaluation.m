function varargout = Evaluation(varargin)
% EVALUATION M-file for Evaluation.fig
%      EVALUATION, by itself, creates a new EVALUATION or raises the existing
%      singleton*.
%
%      H = EVALUATION returns the handle to a new EVALUATION or the handle to
%      the existing singleton*.
%
%      EVALUATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EVALUATION.M with the given input arguments.
%
%      EVALUATION('Property','Value',...) creates a new EVALUATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Evaluation_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Evaluation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Evaluation

% Last Modified by GUIDE v2.5 23-Aug-2011 15:24:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Evaluation_OpeningFcn, ...
                   'gui_OutputFcn',  @Evaluation_OutputFcn, ...
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


% --- Executes just before Evaluation is made visible.
function Evaluation_OpeningFcn(hObject, eventdata, handles, varargin)
global PARA PREF DATA TEMP;

TEMP.show1 = 1;
TEMP.show2 = 2;
set(handles.cbox_overlay2,'Enable','on');
set(handles.cbox_overlay1,'Enable','on');
set(handles.cbox_activation2,'Enable','on');
set(handles.cbox_activation1,'Enable','on');
if length(DATA.electrodePosY{PARA.showCurrDataSet}) == 2;
    set(handles.cbox_electrode2, 'Enable', 'on');
    set(handles.cbox_electrode1, 'Enable', 'on');
end
set(handles.cbox_mask_contour2, 'Enable', 'on');
set(handles.cbox_mask_contour1, 'Enable', 'on');
set(handles.cbox_trepanation2, 'Enable', 'on');
set(handles.cbox_trepanation1, 'Enable', 'on');
if length(DATA.BW{PARA.showCurrDataSet}) > 1
    set(handles.cbox_showROI2,'Enable','on');
    set(handles.cbox_showROI1,'Enable','on');
end
set(handles.slider_threshold2,'Enable','on');
set(handles.slider_threshold1,'Enable','on');
set(handles.popup_show2,'Enable','on');
set(handles.popup_show1,'Enable','on');
set(handles.popup_show2,'String',{ 'rel diff' 't values'});
set(handles.popup_show1,'String',{ 'rel diff' 't values'});
set(handles.popup_show2,'Value',TEMP.show2);
set(handles.popup_show1,'Value',TEMP.show1);
set(handles.slider_threshold1,'Min',PARA.threshold_min);
set(handles.slider_threshold1,'Max',PARA.threshold_max_rd);
set(handles.slider_threshold1,'Value',PARA.threshold_cur_rd);
set(handles.edit_threshold_cur1,'String',num2str(PARA.threshold_cur_rd));
set(handles.slider_threshold2,'Min',PARA.threshold_min);
set(handles.slider_threshold2,'Max',PARA.threshold_max_tv);
set(handles.slider_threshold2,'Value',PARA.threshold_cur_tv);
set(handles.edit_threshold_cur2,'String',num2str(PARA.threshold_cur_tv));

gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);
updateTimecourse(handles.displayTC);

% Set statistical data fields
ind=strfind(PARA.pathname,'\');
pos=ind(end)+1;
patient=PARA.pathname(pos:end);
set(handles.tag_patient, 'String', patient);
set(handles.tag_dataset,'String',[PARA.subdirs{1,PARA.showCurrDataSet}]);

number_activepixel = length(find(DATA.mask_reldiff));
set(handles.tag_pixnum, 'String', num2str(number_activepixel));

mingreyvalue = min(DATA.jointRelDiffOriginal(DATA.mask_reldiff_i{PARA.showCurrDataSet}));
maxgreyvalue = max(DATA.jointRelDiffOriginal(DATA.mask_reldiff_i{PARA.showCurrDataSet}));
meangreyvalue = mean(DATA.jointRelDiffOriginal(DATA.mask_reldiff_i{PARA.showCurrDataSet}));
stdgreyvalue = std(DATA.jointRelDiffOriginal(DATA.mask_reldiff_i{PARA.showCurrDataSet}));
set(handles.tag_mingrey, 'String', num2str(mingreyvalue));
set(handles.tag_maxgrey, 'String', num2str(maxgreyvalue));
set(handles.tag_avrggrey, 'String', num2str(meangreyvalue));
set(handles.tag_std, 'String', num2str(stdgreyvalue));

number_activepixel = length(find(DATA.mask_tvalues));
set(handles.tag_pixnumtv, 'String', num2str(number_activepixel));
mingreyvalue = min(DATA.jointTvaluesOriginal(DATA.mask_tvalues_i{PARA.showCurrDataSet}));
maxgreyvalue = max(DATA.jointTvaluesOriginal(DATA.mask_tvalues_i{PARA.showCurrDataSet}));
meangreyvalue = mean(DATA.jointTvaluesOriginal(DATA.mask_tvalues_i{PARA.showCurrDataSet}));
stdgreyvalue = std(DATA.jointTvaluesOriginal(DATA.mask_tvalues_i{PARA.showCurrDataSet}));
set(handles.tag_mingreytv, 'String', num2str(mingreyvalue));
set(handles.tag_maxgreytv, 'String', num2str(maxgreyvalue));
set(handles.tag_avrggreytv, 'String', num2str(meangreyvalue));
set(handles.tag_stdtv, 'String', num2str(stdgreyvalue));




% Choose default command line output for Evaluation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Evaluation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Evaluation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function tag_export_Callback(hObject, eventdata, handles)
% hObject    handle to tag_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function single_export_Callback(hObject, eventdata, handles)
% hObject    handle to single_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function tag_imagetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tag_imagetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in pb_frame1.
function pb_frame1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_frame1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PARA;
PARA.image_path = '\Frame1_Images';
[outpath] = uigetdir('C:\', 'Please select image folder...');
outpath = [outpath,'\', PARA.subdirs{1,PARA.showCurrDataSet}, PARA.image_path];
mkdir(outpath);
PARA.outpath = outpath;
single_side_image_export(handles, 1, 0);

% export_image = getframe(handles.displayOutput2);
% [outpath] = uigetdir('C:\', 'Please select image folder...');
% mkdir([outpath, '\overlays']);
% try
%     f = getFilenamesFromDir([outpath, '\overlays'],'png');
%     buf = size(f,1)+1;
% catch
%     buf = 1;
% end
% buf = num2str(buf);
% imwrite (export_image.cdata, [outpath, '\overlays\overlay_image_', buf, '.png']);


% --- Executes on button press in pb_all_images.
function pb_all_images_Callback(hObject, eventdata, handles)
% hObject    handle to pb_all_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% import_handles = getappdata(0, 'export_handles');
global PARA;
try
    PARA.image_path = '\Frame1_Images';
    [outpath] = uigetdir('C:\', 'Please select image folder...');
    outpath1 = [outpath,'\', PARA.subdirs{1,PARA.showCurrDataSet}, PARA.image_path];
    PARA.image_path = '\Frame2_Images';
    outpath2 = [outpath,'\', PARA.subdirs{1,PARA.showCurrDataSet}, PARA.image_path];
    mkdir(outpath1);
    PARA.outpath = outpath1;
    single_side_image_export(handles, 1, 1);
    mkdir(outpath2);
    PARA.outpath = outpath2;
    single_side_image_export(handles, 2, 1);
    msgbox('All images successfully exported!', 'Export');
catch
    h = msgbox('Error during export' ,'Error' ,'error');
end





% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close Evaluation;

% --- Executes on button press in pb_statistics.
function pb_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to pb_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button = questdlg('Choose fileformat','Choose fileformat','.csv','.xls','.xls');

switch button
    case '.csv'
        xlsExport('.csv');
    case '.xls'
        xlsExport();
end


% --- Executes on button press in cbox_overlay2.
function cbox_overlay2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_overlay2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_overlay2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on button press in cbox_activation2.
function cbox_activation2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_activation2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_activation2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on button press in cbox_showROI2.
function cbox_showROI2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_showROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_showROI2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on button press in cbox_mask_contour2.
function cbox_mask_contour2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_mask_contour2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_mask_contour2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on button press in cbox_electrode2.
function cbox_electrode2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_electrode2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_electrode2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on button press in cbox_trepanation2.
function cbox_trepanation2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_trepanation2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_trepanation2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on selection change in popup_show2.
function popup_show2_Callback(hObject, eventdata, handles)
% hObject    handle to popup_show2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_show2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_show2
global TEMP;

show_cur = uint8(get(handles.popup_show2,'Value'));

if show_cur ~= TEMP.show2
    TEMP.show2 = show_cur;
    threshold = get(handles.slider_threshold2,'Value');
    changeShowModus( show_cur, threshold);

    gui_elements2 = get_gui_control_values_right(handles);
    updateAxes(gui_elements2);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function popup_show2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_show2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tb_bg_only2.
function tb_bg_only2_Callback(hObject, eventdata, handles)
% hObject    handle to tb_bg_only2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tb_bg_only2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

% --- Executes on slider movement.
function slider_threshold2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_threshold2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% PREF = getappdata(0,'PREF');
global PARA PREF;
switch get(handles.popup_show2,'Value')
   case 1 % reldiff
       PARA.threshold_max = PREF.maxRelDiff;
       PARA.threshold_cur_rd = get(handles.slider_threshold2,'Value');
       PARA.threshold_cur_rd(PARA.threshold_cur_rd > PARA.threshold_max_rd) = PARA.threshold_max_rd;
   case 2 % tvalues
       PARA.threshold_max = PREF.maxTvalues;
       PARA.threshold_cur_tv = get(handles.slider_threshold2,'Value');
       PARA.threshold_cur_tv(PARA.threshold_cur_tv > PARA.threshold_max_tv) = PARA.threshold_max_tv;
end
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider_threshold2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_threshold2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_threshold_cur2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold_cur2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold_cur2 as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold_cur2 as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_cur2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold_cur2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function slider_threshold1_Callback(hObject, eventdata, handles)
% hObject    handle to slider_threshold1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global PARA PREF;
switch get(handles.popup_show1,'Value')
   case 1 % reldiff
       PARA.threshold_max = PREF.maxRelDiff;
       PARA.threshold_cur_rd = get(handles.slider_threshold1,'Value');
       PARA.threshold_cur_rd(PARA.threshold_cur_rd > PARA.threshold_max_rd) = PARA.threshold_max_rd;
   case 2 % tvalues
       PARA.threshold_max = PREF.maxTvalues;
       PARA.threshold_cur_tv = get(handles.slider_threshold1,'Value');
       PARA.threshold_cur_tv(PARA.threshold_cur_tv > PARA.threshold_max_tv) = PARA.threshold_max_tv;
end
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_threshold1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_threshold1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_threshold_cur1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold_cur1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_threshold_cur1 as text
%        str2double(get(hObject,'String')) returns contents of edit_threshold_cur1 as a double


% --- Executes during object creation, after setting all properties.
function edit_threshold_cur1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold_cur1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbox_overlay1.
function cbox_overlay1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_overlay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_overlay1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on button press in cbox_activation1.
function cbox_activation1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_activation1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_activation1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on button press in cbox_showROI1.
function cbox_showROI1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_showROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_showROI1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on button press in cbox_mask_contour1.
function cbox_mask_contour1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_mask_contour1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_mask_contour1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on button press in cbox_electrode1.
function cbox_electrode1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_electrode1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_electrode1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on button press in cbox_trepanation1.
function cbox_trepanation1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_trepanation1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_trepanation1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on selection change in popup_show1.
function popup_show1_Callback(hObject, eventdata, handles)
% hObject    handle to popup_show1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_show1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_show1
global TEMP;

show_cur = uint8(get(handles.popup_show1,'Value'));

if show_cur ~= TEMP.show1
    TEMP.show1 = show_cur;
%     threshold = str2double(get(handles.edit_threshold_cur1,'String'));
    threshold = get(handles.slider_threshold1,'Value');
    changeShowModus( show_cur, threshold);

    gui_elements1 = get_gui_control_values_left(handles);
    updateAxes(gui_elements1);
    guidata(hObject, handles);
end

%% change between reldiff and tvalue
function  changeShowModus( show_cur, threshold)

global PARA PREF;

switch show_cur
       case 1 %reldiff
        PARA.threshold_min = 0;
%         handles.threshold_max = 0.5;
         PARA.threshold_max = PREF.maxRelDiff;
        % convert tvalue-threshold to reldiff (threshold/20)*0.5
        PARA.threshold_cur = PREF.maxRelDiff*(threshold/PREF.maxTvalues);
        PARA.threshold_cur (PARA.threshold_cur > PREF.maxRelDiff) = PREF.maxRelDiff;
       case 2 % tvalues

        PARA.threshold_min = 0;
%         handles.threshold_max = 20;
        PARA.threshold_max = PREF.maxTvalues;
        % convert reldiff-threshold to tvalue (threshold/0.5)*20
        PARA.threshold_cur = PREF.maxTvalues*(threshold/PREF.maxRelDiff);
        PARA.threshold_cur(PARA.threshold_cur > PREF.maxTvalues) = PREF.maxTvalues;
end
%%
% --- Executes during object creation, after setting all properties.
function popup_show1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_show1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%
% --- Executes on button press in tb_bg_only1.
function tb_bg_only1_Callback(hObject, eventdata, handles)
% hObject    handle to tb_bg_only1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tb_bg_only1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);
   
%%   
function gui_control_values_right = get_gui_control_values_right(handles)
% get checkboxes and their values
gui_control_values_right = struct( ...
       'activation', logical(get(handles.cbox_activation2, 'Value')), ...
       'trepanation', logical(get(handles.cbox_trepanation2, 'Value')), ...
       'background_overlay', logical(get(handles.cbox_overlay2, 'Value')), ...
       'background_only', logical(get(handles.tb_bg_only2,'Value')), ...
       'showROI', logical(get(handles.cbox_showROI2,'Value')), ...
       'electrode', logical(get(handles.cbox_electrode2,'Value')), ... 
       'mask_contour', logical(get(handles.cbox_mask_contour2, 'Value')), ...
       'slider_threshold', handles.slider_threshold2, ...
       'edit_threshold_cur', handles.edit_threshold_cur2, ...
       'txt_notification', handles.txt_notification2, ...
       'txt_cbar_bottom', handles.txt_cbar_bottom2, ...
       'displayOutput', handles.displayOutput2, ...
       'c_bar', handles.axes_cbar2, ...
       'figure', findobj('Name','Evaluation'), ...
       'popup_show', handles.popup_show2, ...
       'show_legend', logical(get(handles.cbox_legend2, 'Value'))); 
   
function gui_control_values_left = get_gui_control_values_left(handles)
% get checkboxes and their values
gui_control_values_left= struct( ...
       'activation', logical(get(handles.cbox_activation1, 'Value')), ...
       'trepanation', logical(get(handles.cbox_trepanation1, 'Value')), ...
       'background_overlay', logical(get(handles.cbox_overlay1, 'Value')), ...
       'background_only', logical(get(handles.tb_bg_only1,'Value')), ...
       'showROI', logical(get(handles.cbox_showROI1,'Value')), ...
       'electrode', logical(get(handles.cbox_electrode1,'Value')), ... 
       'mask_contour', logical(get(handles.cbox_mask_contour1, 'Value')), ...
       'slider_threshold', handles.slider_threshold1, ...
       'edit_threshold_cur', handles.edit_threshold_cur1, ...
       'txt_notification', handles.txt_notification1, ...
       'txt_cbar_bottom', handles.txt_cbar_bottom1, ...
       'displayOutput', handles.displayOutput1, ...
       'c_bar', handles.axes_cbar1, ...
       'figure', findobj('Name','Evaluation'), ...
       'popup_show', handles.popup_show1, ...
       'show_legend', logical(get(handles.cbox_legend1, 'Value')));  

function write_cbar_inf(cbar, typepos, slider)
set(gcf, 'CurrentAxes', cbar);
if typepos == 1
    threshold_cur_out = double(get(slider, 'Value'))*100;
    text(1,250,'0','FontSize',8, 'Color', 'white', 'HorizontalAlignment', 'center');
    text(1,10,num2str(threshold_cur_out, '%.2f'),'FontSize',8, 'Color', 'white', 'HorizontalAlignment', 'center')
    text(1,120,num2str('[%]'),'FontSize',8, 'Color', 'white', 'HorizontalAlignment', 'center')
else
    threshold_cur_out = get(slider, 'Value');
    text(8,250,'0','FontSize',8, 'Color', 'white');
    text(0,10,num2str(threshold_cur_out, '%.1f'),'FontSize',8, 'Color', 'white')
end

%%
% --- Executes on button press in pb_frame2.
function pb_frame2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_frame2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PARA;
PARA.image_path = '\Frame2_Images';
[outpath] = uigetdir('C:\', 'Please select image folder...');
outpath = [outpath,'\', PARA.subdirs{1,PARA.showCurrDataSet}, PARA.image_path];
mkdir(outpath);
PARA.outpath = outpath;
single_side_image_export(handles, 2, 0);
% write_cbar_inf(handles.axes_cbar2, get(handles.popup_show2, 'Value'), handles.slider_threshold2);
% cbar_image = getframe(handles.axes_cbar2);
% imwrite (cbar_image.cdata, [outpath, '\Frame2_Images\Cbar_Image.png']);
% tc_image = getframe(handles.figure1, [10 10 600 300]);
% imwrite (tc_image.cdata, [outpath, '\Frame2_Images\TC_Image.png']);
% gui_elements2 = get_gui_control_values_right(handles);
% updateAxes(gui_elements2);


%%
% --- Executes during object deletion, before destroying properties.
function popup_show1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to popup_show1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global TEMP;


%%
% --- Executes during object creation, after setting all properties.
function pb_statistics_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%
function single_side_image_export(handles, side, mode);
global PARA;
try
    if get(handles.hq_tc_export, 'Value')
        fig = export_TC();
        saveas(fig, [PARA.outpath, '\Timecourse'],'epsc');
        eps2pdf([PARA.outpath, '\Timecourse.eps'], 'C:\Programme\gs\gs9.04\bin\gswin32.exe', 0);
        tc = getframe(export_TC);
        imwrite (tc.cdata, [PARA.outpath, '\Timecourse.png']);
        close(fig);
        set(0,'CurrentFigure',findobj('Name','Evaluation'));
    end
    if (get(handles.hq_tc_export, 'Value')==0)
        fig = export_TC();
        tc = getframe(export_TC);
        imwrite (tc.cdata, [PARA.outpath, '\Timecourse.png']);
        close(fig);
        set(0,'CurrentFigure',findobj('Name','Evaluation'));
    end
    if side == 2
         PARA.gui_elements_export = get_gui_control_values_right(handles);
    else
         PARA.gui_elements_export = get_gui_control_values_left(handles);
    end
    fig = export_Image();
    close(fig);
    if mode == 0
        msgbox(['Successfully exported to ' PARA.outpath],'Export');
    end
catch
    h = msgbox('Error during export' ,'Error' ,'error');
end

%%
% --- Executes on button press in hq_tc_export.
function hq_tc_export_Callback(hObject, eventdata, handles)
% hObject    handle to hq_tc_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hq_tc_export




% --- Executes on button press in cbox_legend1.
function cbox_legend1_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_legend1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_legend1
gui_elements1 = get_gui_control_values_left(handles);
updateAxes(gui_elements1);

% --- Executes on button press in cbox_legend2.
function cbox_legend2_Callback(hObject, eventdata, handles)
% hObject    handle to cbox_legend2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbox_legend2
gui_elements2 = get_gui_control_values_right(handles);
updateAxes(gui_elements2);

guidata(hObject, handles);

