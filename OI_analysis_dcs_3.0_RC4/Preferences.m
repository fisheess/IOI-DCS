function varargout = Preferences(varargin)
% PREFERENCES M-file for Preferences.fig
%      PREFERENCES, by itself, creates a new PREFERENCES or raises the existing
%      singleton*.
%
%      H = PREFERENCES returns the handle to a new PREFERENCES or the handle to
%      the existing singleton*.
%
%      PREFERENCES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREFERENCES.M with the given input arguments.
%
%      PREFERENCES('Property','Value',...) creates a new PREFERENCES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Preferences_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Preferences_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Preferences

% Last Modified by GUIDE v2.5 17-Feb-2012 09:57:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Preferences_OpeningFcn, ...
                   'gui_OutputFcn',  @Preferences_OutputFcn, ...
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


% --- Executes just before Preferences is made visible.
function Preferences_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Preferences (see VARARGIN)

% Choose default command line output for Preferences
handles.output = hObject;

% initialize preferences
drawGUI( hObject, handles, 'prefs');

% UIWAIT makes Preferences wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% draw gui

function drawGUI ( hObject, handles, storageValue )

% load stored default values
global PREF;
if strcmp(storageValue,'default')
    PREF = getappdata(0,storageValue);
end

% set GUI
set(handles.prefs_cbox_staticThreshold,'Value',PREF.staticThreshold);

set(handles.prefs_edit_radius,'String',PREF.radius);
set(handles.prefs_edit_maxdist,'String',PREF.maxdist);
set(handles.prefs_edit_thresholdRelDiff,'String',PREF.thresholdRelDiff);
set(handles.prefs_edit_thresholdTvalues,'String',PREF.thresholdTvalues);

set(handles.prefs_cbox_diffColors,'Value',PREF.differentColors);

set(handles.prefs_edit_maxRelDiff,'String',PREF.maxRelDiff);
set(handles.prefs_edit_minTvalues,'String',PREF.maxTvalues);

set(handles.prefs_edit_smoothFilterSize,'String',PREF.smoothFilterSize);
set(handles.prefs_cbox_stimParInd,'Value',PREF.stimParInd);
% set(handles.prefs_edit_spatialBinning,'String',PREF.spatialBinning);
% set(handles.prefs_edit_temporalBinning,'String',PREF.temporalBinning);


set(handles.prefs_cbox_drawElectrodeConn,'Value',PREF.drawElectrodeConn);

% if static threshold is activated on startup, enable edit-fields
if PREF.staticThreshold
    set(handles.prefs_edit_thresholdTvalues,'Enable','on');
    set(handles.prefs_edit_thresholdRelDiff,'Enable','on');
end

% if draw electrodes connection is activated on startup, enable popdown
% menu
set(handles.prefs_popup_electrodeConnPrefs,'String',{ 'line' 'line + dataset'});
set(handles.prefs_popup_electrodeConnPrefs,'Value',PREF.drawElectrodeConnPar);

if PREF.drawElectrodeConn
    set(handles.prefs_popup_electrodeConnPrefs,'Enable','on')
else
    set(handles.prefs_popup_electrodeConnPrefs,'Enable','off')
end

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Preferences_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function prefs_edit_thresholdRelDiff_Callback(hObject, eventdata, handles)

% catch values out of range
val = str2double(get(hObject,'String'));
val(val < 0) = 0.0001;
val(val > 0.5) = 0.5;

set(hObject,'String',val);

% --- Executes during object creation, after setting all properties.
function prefs_edit_thresholdRelDiff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_thresholdRelDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prefs_edit_thresholdTvalues_Callback(hObject, eventdata, handles)

% catch values out of range
val = str2double(get(hObject,'String'));
val(val < 1) = 1;
val(val > 20) = 20;

set(hObject,'String',val);


% --- Executes during object creation, after setting all properties.
function prefs_edit_thresholdTvalues_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_thresholdTvalues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prefs_cbox_staticThreshold.
function prefs_cbox_staticThreshold_Callback(hObject, eventdata, handles)

if get(handles.prefs_cbox_staticThreshold,'Value')
    set(handles.prefs_edit_thresholdTvalues,'Enable','on');
    set(handles.prefs_edit_thresholdRelDiff,'Enable','on');
else
    set(handles.prefs_edit_thresholdTvalues,'Enable','off');
    set(handles.prefs_edit_thresholdRelDiff,'Enable','off');
end

%% saves parameters
function save( handles )

global PREF;

% get checkboxes
PREF.staticThreshold = logical(get(handles.prefs_cbox_staticThreshold,'Value'));
PREF.differentColors = logical(get(handles.prefs_cbox_diffColors,'Value'));
PREF.drawElectrodeConn = logical(get(handles.prefs_cbox_drawElectrodeConn,'Value'));
PREF.stimParInd = logical(get(handles.prefs_cbox_stimParInd,'Value'));

% get edit-fields
PREF.radius = str2double(get(handles.prefs_edit_radius,'String'));
PREF.maxdist = str2double(get(handles.prefs_edit_maxdist,'String'));

PREF.thresholdRelDiff = str2double(get(handles.prefs_edit_thresholdRelDiff,'String'));
PREF.thresholdTvalues = str2double(get(handles.prefs_edit_thresholdTvalues,'String'));

PREF.smoothFilterSize = str2double(get(handles.prefs_edit_smoothFilterSize,'String'));

% PREF.spatialBinning = str2double(get(handles.prefs_edit_spatialBinning,'String'));
% PREF.temporalBinning = str2double(get(handles.prefs_edit_temporalBinning,'String'));

PREF.maxRelDiff = str2double(get(handles.prefs_edit_maxRelDiff,'String'));
PREF.maxTvalues = str2double(get(handles.prefs_edit_minTvalues,'String'));

% get popupmenus
PREF.drawElectrodeConnPar = uint8(get(handles.prefs_popup_electrodeConnPrefs,'Value'));




% --- Executes on button press in prefs_pb_savenclose.
function prefs_pb_savenclose_Callback(hObject, eventdata, handles)

save( handles );

close;

% --- Executes on button press in prefs_pb_save.
function prefs_pb_save_Callback(hObject, eventdata, handles)

save(handles);

% close;

% --- Executes on button press in prefs_pb_cancel.
function prefs_pb_cancel_Callback(hObject, eventdata, handles)

close;



function pref_edit_radius_Callback(hObject, eventdata, handles)
% hObject    handle to pref_edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pref_edit_radius as text
%        str2double(get(hObject,'String')) returns contents of pref_edit_radius as a double


% --- Executes during object creation, after setting all properties.
function pref_edit_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pref_edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pref_edit_maxdist_Callback(hObject, eventdata, handles)
% hObject    handle to pref_edit_maxdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pref_edit_maxdist as text
%        str2double(get(hObject,'String')) returns contents of pref_edit_maxdist as a double


% --- Executes during object creation, after setting all properties.
function pref_edit_maxdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pref_edit_maxdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prefs_edit_radius_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefs_edit_radius as text
%        str2double(get(hObject,'String')) returns contents of prefs_edit_radius as a double


% --- Executes during object creation, after setting all properties.
function prefs_edit_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prefs_edit_maxdist_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_edit_maxdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefs_edit_maxdist as text
%        str2double(get(hObject,'String')) returns contents of prefs_edit_maxdist as a double


% --- Executes during object creation, after setting all properties.
function prefs_edit_maxdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_maxdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end










function prefs_edit_smoothFilterSize_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_edit_smoothFilterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefs_edit_smoothFilterSize as text
%        str2double(get(hObject,'String')) returns contents of prefs_edit_smoothFilterSize as a double


% --- Executes during object creation, after setting all properties.
function prefs_edit_smoothFilterSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_smoothFilterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prefs_cbox_drawElectrodeConn.
function prefs_cbox_drawElectrodeConn_Callback(hObject, eventdata, handles)

if get(hObject,'Value')
    set(handles.prefs_popup_electrodeConnPrefs,'Enable','on')
else
    set(handles.prefs_popup_electrodeConnPrefs,'Enable','off')
end

% --- Executes on selection change in prefs_popup_electrodeConnPrefs.
function prefs_popup_electrodeConnPrefs_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_popup_electrodeConnPrefs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns prefs_popup_electrodeConnPrefs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prefs_popup_electrodeConnPrefs


% --- Executes during object creation, after setting all properties.
function prefs_popup_electrodeConnPrefs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_popup_electrodeConnPrefs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prefs_cbox_diffColors.
function prefs_cbox_diffColors_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_cbox_diffColors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prefs_cbox_diffColors



% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_maxdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_defaultValues.
function pb_defaultValues_Callback(hObject, eventdata, handles)

answer= questdlg('Reset all values to their default?','Are you sure?');

switch answer
    case 'Yes'
% load stored default values
    drawGUI( hObject, handles, 'default');
end
% Update handles structure
guidata(hObject, handles);



function prefs_edit_maxRelDiff_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_edit_maxRelDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefs_edit_maxRelDiff as text
%        str2double(get(hObject,'String')) returns contents of prefs_edit_maxRelDiff as a double


% --- Executes during object creation, after setting all properties.
function prefs_edit_maxRelDiff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_maxRelDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prefs_edit_minTvalues_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_edit_minTvalues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefs_edit_minTvalues as text
%        str2double(get(hObject,'String')) returns contents of prefs_edit_minTvalues as a double


% --- Executes during object creation, after setting all properties.
function prefs_edit_minTvalues_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefs_edit_minTvalues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in prefs_cbox_stimParInd.
function prefs_cbox_stimParInd_Callback(hObject, eventdata, handles)
% hObject    handle to prefs_cbox_stimParInd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prefs_cbox_stimParInd
