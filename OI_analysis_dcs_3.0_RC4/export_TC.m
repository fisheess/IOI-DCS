function varargout = export_TC(varargin)
% EXPORT_TC M-file for export_TC.fig
%      EXPORT_TC, by itself, creates a new EXPORT_TC or raises the existing
%      singleton*.
%
%      H = EXPORT_TC returns the handle to a new EXPORT_TC or the handle to
%      the existing singleton*.
%
%      EXPORT_TC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORT_TC.M with the given input arguments.
%
%      EXPORT_TC('Property','Value',...) creates a new EXPORT_TC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before export_TC_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to export_TC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help export_TC

% Last Modified by GUIDE v2.5 24-Aug-2011 11:27:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @export_TC_OpeningFcn, ...
                   'gui_OutputFcn',  @export_TC_OutputFcn, ...
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


% --- Executes just before export_TC is made visible.
function export_TC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to export_TC (see VARARGIN)

% Choose default command line output for export_TC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes export_TC wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(0,'CurrentFigure',findobj('Name','export_TC'))
updateTimecourse(handles.axes_exportTC);
set(gcf,'PaperPositionMode','auto');

% --- Outputs from this function are returned to the command line.
function varargout = export_TC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


