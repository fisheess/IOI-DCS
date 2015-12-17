function varargout = Trep_param(varargin)
% TREP_PARAM M-file for Trep_param.fig
%      TREP_PARAM, by itself, creates a new TREP_PARAM or raises the existing
%      singleton*.
%
%      H = TREP_PARAM returns the handle to a new TREP_PARAM or the handle to
%      the existing singleton*.
%
%      TREP_PARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREP_PARAM.M with the given input arguments.
%
%      TREP_PARAM('Property','Value',...) creates a new TREP_PARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Trep_param_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Trep_param_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Trep_param

% Last Modified by GUIDE v2.5 28-Apr-2011 14:21:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Trep_param_OpeningFcn, ...
                   'gui_OutputFcn',  @Trep_param_OutputFcn, ...
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


% --- Executes just before Trep_param is made visible.
function Trep_param_OpeningFcn(hObject, eventdata, handles, varargin)
global PARA;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Trep_param (see VARARGIN)
% medianfiltersize = getappdata(0, 'medianfiltersize');
set(handles.edit_median, 'String', PARA.medianfiltersize);
% strelsize = getappdata(0, 'strelsize');
set(handles.edit_strel, 'String', PARA.strelsize);
% graylvlfactor = getappdata(0, 'graylvlfactor');
set(handles.edit_graylvl, 'String', PARA.graylvlfactor);



% Choose default command line output for Trep_param
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Trep_param wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Trep_param_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_median_Callback(hObject, eventdata, handles)
% hObject    handle to edit_median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_median as text
%        str2double(get(hObject,'String')) returns contents of edit_median as a double


% --- Executes during object creation, after setting all properties.
function edit_median_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_strel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_strel as text
%        str2double(get(hObject,'String')) returns contents of edit_strel as a double


% --- Executes during object creation, after setting all properties.
function edit_strel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_graylvl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_graylvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_graylvl as text
%        str2double(get(hObject,'String')) returns contents of edit_graylvl as a double


% --- Executes during object creation, after setting all properties.
function edit_graylvl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_graylvl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_recompute.
function pb_recompute_Callback(hObject, eventdata, handles)
global PARA
% hObject    handle to pb_recompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PARA.medianfiltersize = str2double(get(handles.edit_median,'String'));
PARA.strelsize = str2double(get(handles.edit_strel,'String'));
PARA.graylvlfactor = str2double(get(handles.edit_graylvl,'String'));
% setappdata(0, 'medianfiltersize', medianfiltersize);
% setappdata(0, 'strelsize', strelsize);
% setappdata(0, 'graylvlfactor', graylvlfactor);
close(Trep_param);



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pb_recompute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_recompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


