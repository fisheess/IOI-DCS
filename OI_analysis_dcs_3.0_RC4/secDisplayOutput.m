function varargout = secDisplayOutput(varargin)
% SECDISPLAYOUTPUT M-file for secDisplayOutput.fig
%      SECDISPLAYOUTPUT, by itself, creates a new SECDISPLAYOUTPUT or raises the existing
%      singleton*.
%
%      H = SECDISPLAYOUTPUT returns the handle to a new SECDISPLAYOUTPUT or the handle to
%      the existing singleton*.
%
%      SECDISPLAYOUTPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SECDISPLAYOUTPUT.M with the given input arguments.
%
%      SECDISPLAYOUTPUT('Property','Value',...) creates a new SECDISPLAYOUTPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before secDisplayOutput_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to secDisplayOutput_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help secDisplayOutput

% Last Modified by GUIDE v2.5 15-Aug-2011 12:18:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @secDisplayOutput_OpeningFcn, ...
                   'gui_OutputFcn',  @secDisplayOutput_OutputFcn, ...
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

% try
%    if (nargout)
%       [varargout{1:nargout}] = feval(varargin{:});
%    else
%       feval(varargin{:});
%    end
% catch  
%    disp(lasterr)
% end 

% End initialization code - DO NOT EDIT


% --- Executes just before secDisplayOutput is made visible.
function secDisplayOutput_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to secDisplayOutput (see VARARGIN)
global PARA;
PARA.secDisplayAxes = handles.secdisplayOutput;
PARA.sec_cbar = handles.sec_cbar;
updateSecDisplay();

% Choose default command line output for secDisplayOutput
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes secDisplayOutput wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = secDisplayOutput_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function updateSecDisplay()
global PARA;
% if ~PARA.secDisplayOpen
    PARA.secDisplay_gui_elements.displayOutput = PARA.secDisplayAxes;
    PARA.secDisplay_gui_elements.c_bar = PARA.sec_cbar;
    PARA.secDisplay_gui_elements.figure = findobj('Name','secDisplayOutput');
% end
set(0,'CurrentFigure',PARA.secDisplay_gui_elements.figure);
updateAxes(PARA.secDisplay_gui_elements);
set(0,'CurrentFigure',findobj('Name','OI_analysis_DCS'));


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global PARA
PARA.secDisplayOpen = false;
delete(hObject);


