function varargout = Test(varargin)
% TEST MATLAB code for Test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test

% Last Modified by GUIDE v2.5 24-Feb-2012 12:07:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Test_OpeningFcn, ...
                   'gui_OutputFcn',  @Test_OutputFcn, ...
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


% --- Executes just before Test is made visible.
function Test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test (see VARARGIN)

% Choose default command line output for Test
handles.output = hObject;
global DATA PARA PREF;
time_s = DATA.time_s{PARA.showCurrDataSet};
idx_t = find(time_s > PARA.cStimStart_s{PARA.showCurrDataSet},1,'first');
PARA.currentFrame = idx_t;
% max_frames = PARA.nFrames{PARA.showCurrDataSet}(end) - idx_t;
vidObj = VideoWriter('Video.avi');
open(vidObj);
for i=1:1:PARA.nFrames{PARA.showCurrDataSet}(end)
    PARA.currentFrame = i;
    if PARA.currentFrame >= idx_t
        PARA.cStimStart_s{PARA.showCurrDataSet}=time_s(PARA.currentFrame);
        PARA.cStimEnd_s{PARA.showCurrDataSet}=PARA.cStimStart_s{PARA.showCurrDataSet}+10;
    end
    updateTimecourse(handles.axes1);
    tc_image = getframe(handles.axes1);
%     writeVideo(vidObj,tc_image);
    imwrite (tc_image.cdata, ['Bilder\' 'TC' num2str(i) '.tif']);
%     saveas(handles.displayTimecourse,['Bild' num2str(i) '.tif']); 
%     uiwait(gcf, 0.5);
end
close(vidObj);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
