function varargout = ui_helper(varargin)
% UI_HELPER MATLAB code for ui_helper.fig
%      UI_HELPER, by itself, creates a new UI_HELPER or raises the existing
%      singleton*.
%
%      H = UI_HELPER returns the handle to a new UI_HELPER or the handle to
%      the existing singleton*.
%
%      UI_HELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI_HELPER.M with the given input arguments.
%
%      UI_HELPER('Property','Value',...) creates a new UI_HELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_helper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_helper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui_helper

% Last Modified by GUIDE v2.5 29-Jan-2017 00:23:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ui_helper_OpeningFcn, ...
    'gui_OutputFcn',  @ui_helper_OutputFcn, ...
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


% --- Executes just before ui_helper is made visible.
function ui_helper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui_helper (see VARARGIN)

% Choose default command line output for ui_helper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ui_helper wait for user response (see UIRESUME)
% uiwait(handles.figure1_helper);

set(handles.text5, 'visible', 'off')
set(handles.text6, 'visible', 'off')
set(handles.pushbutton2, 'visible', 'off')
set(handles.text7, 'visible', 'off')
set(handles.text8, 'visible', 'off')
set(handles.text9, 'visible', 'off')
set(handles.axes2, 'visible', 'off')
set(handles.apushbutton, 'visible', 'off')
set(handles.text10, 'visible', 'off')
set(handles.touchbutton, 'visible', 'off')
set(handles.text11, 'visible', 'off')

axes(handles.axes1)
matlabImage = imread('app_data/pics/taylor.png');
image(matlabImage)
axis off
axis image


% --- Outputs from this function are returned to the command line.
function varargout = ui_helper_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text2, 'visible', 'off')
set(handles.text3, 'visible', 'off')
set(handles.text4, 'visible', 'off')
set(handles.pushbutton1, 'visible', 'off')
set(handles.text5, 'visible', 'on')
set(handles.text6, 'visible', 'on')
set(handles.text9, 'visible', 'on')
set(handles.pushbutton2, 'visible', 'on')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text5, 'visible', 'off')
set(handles.text6, 'visible', 'off')
set(handles.text9, 'visible', 'off')
set(handles.pushbutton2, 'visible', 'off')
set(handles.text7, 'visible', 'on')
set(handles.text8, 'visible', 'on')
set(handles.axes2, 'visible', 'on')

axes(handles.axes2)
matlabImage = imread('app_data/pics/partial.png');
image(matlabImage)
axis off
axis image

pause(7)

global app
app.play();


% --- Executes on button press in apushbutton.
function apushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to apushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hangle_figure_helper = findobj('Tag', 'figure1_helper');
figure(hangle_figure_helper)
set(handles.text7, 'visible', 'off')
set(handles.text8, 'visible', 'off')
set(handles.text10, 'visible', 'on')
handle_image = findobj(hangle_figure_helper, 'Type', 'image');
delete(handle_image(1))

t = 0;
while t < 8
    figure(hangle_figure_helper)
    t = t + 0.01;
    pause(0.01)
end


% --- Executes on button press in touchbutton.
function touchbutton_Callback(hObject, eventdata, handles)
% hObject    handle to touchbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hangle_figure_helper = findobj('Tag', 'figure1_helper');
figure(hangle_figure_helper)
set(handles.text10, 'visible', 'off')
set(handles.text11, 'visible', 'on')
