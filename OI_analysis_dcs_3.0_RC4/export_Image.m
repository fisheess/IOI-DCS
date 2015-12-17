function varargout = export_Image(varargin)
% EXPORT_IMAGE M-file for export_Image.fig
%      EXPORT_IMAGE, by itself, creates a new EXPORT_IMAGE or raises the existing
%      singleton*.
%
%      H = EXPORT_IMAGE returns the handle to a new EXPORT_IMAGE or the handle to
%      the existing singleton*.
%
%      EXPORT_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORT_IMAGE.M with the given input arguments.
%
%      EXPORT_IMAGE('Property','Value',...) creates a new EXPORT_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before export_Image_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to export_Image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help export_Image

% Last Modified by GUIDE v2.5 22-Aug-2011 10:07:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @export_Image_OpeningFcn, ...
                   'gui_OutputFcn',  @export_Image_OutputFcn, ...
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

%%
% --- Executes just before export_Image is made visible.
function export_Image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to export_Image (see VARARGIN)

% Choose default command line output for export_Image

global PARA;
PARA.gui_elements_export.displayOutput = handles.axes_main_export;
PARA.gui_elements_export.c_bar = handles.axes_cbar_export;
PARA.gui_elements_export.figure = findobj('Name','export_Image');
set(0,'CurrentFigure',PARA.gui_elements_export.figure);
updateAxes(PARA.gui_elements_export);
main_image = getframe(handles.axes_main_export);
imwrite (main_image.cdata, [PARA.outpath, '\Main_Image.png']);
write_cbar_inf(handles.axes_cbar_export, get(PARA.gui_elements_export.popup_show, 'Value'), PARA.gui_elements_export.slider_threshold);
cbar_image = getframe(handles.axes_cbar_export);
imwrite (cbar_image.cdata, [PARA.outpath, '\Cbar_Image.png']);
set(0,'CurrentFigure',findobj('Name','Evaluation'));
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes export_Image wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% --- Outputs from this function are returned to the command line.
function varargout = export_Image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global PARA
clear PARA.gui_elements_export;
delete(hObject);

%%
function write_cbar_inf(cbar, typepos, slider)
set(gcf, 'CurrentAxes', cbar);
if typepos == 1
    threshold_cur_out = double(get(slider, 'Value'))*100;
    text(8,250,'0','FontSize',14, 'Color', 'white');
    text(3,10,num2str(threshold_cur_out, '%.2f'),'FontSize',14, 'Color', 'white')
    text(5,120,num2str('[%]'),'FontSize',14, 'Color', 'white')
else
    threshold_cur_out = get(slider, 'Value');
    text(8,250,'0','FontSize',14, 'Color', 'white');
    text(3,10,num2str(threshold_cur_out, '%.1f'),'FontSize',14, 'Color', 'white')
end


