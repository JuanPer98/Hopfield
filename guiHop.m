function varargout = guiHop(varargin)
% GUIHOP MATLAB code for guiHop.fig
%      GUIHOP, by itself, creates a new GUIHOP or raises the existing
%      singleton*.
%
%      H = GUIHOP returns the handle to a new GUIHOP or the handle to
%      the existing singleton*.
%
%      GUIHOP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIHOP.M with the given input arguments.
%
%      GUIHOP('Property','Value',...) creates a new GUIHOP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiHop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiHop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiHop

% Last Modified by GUIDE v2.5 07-Nov-2018 18:35:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiHop_OpeningFcn, ...
                   'gui_OutputFcn',  @guiHop_OutputFcn, ...
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


% --- Executes just before guiHop is made visible.
function guiHop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiHop (see VARARGIN)

% Choose default command line output for guiHop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiHop wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global patrones nfiles dim W
imagefiles = dir('*.PNG');
nfiles = length(imagefiles) %-> Patrones
dim=round(sqrt(nfiles*20/0.15))

for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   images{ii} = currentimage;
   images2{ii}=currentimage;
end

for i=1:nfiles
    images{i} = im2bw(images{i}); 
    images{i} = imcomplement(images{i});
    s=regionprops(images{i});
    images{i}=imcrop(images{i},s.BoundingBox);
    images{i} = imcomplement(images{i});
end

for i=1:nfiles
    images{i} = imresize(images{i},[dim dim]);
    images{i} = (images{i}.*2)-1;
end

for i=1:nfiles
    images{i} = images{i}(:);
end

patrones = zeros(dim^2, nfiles);

for i=1:nfiles
    patrones(1:dim^2,i)=images{i};
%     imshow(ensamb(images{i},dim,dim),'InitialMagnification','fit');
%     pause(0.5);
end

N=size(patrones,1);
M=nfiles; %->Patrones
s=zeros(M,1);

Pi=((patrones'*patrones)^-1)*patrones';
W=patrones*Pi;

% --- Outputs from this function are returned to the command line.
function varargout = guiHop_OutputFcn(hObject, eventdata, handles) 
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
global dim prueba im
[im,~,~]=uigetfile('*.png');
prueba=imread(im);
prueba=im2bw(prueba);

prueba=imcomplement(prueba);
s=regionprops(prueba);
prueba=imcrop(prueba,s.BoundingBox);
prueba=imcomplement(prueba);

prueba=imresize(prueba,[dim dim]);

imshow(prueba,'Parent',handles.axes1,'InitialMagnification','fit');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prueba dim
prueba=prueba(:)
n=length(prueba);
porc=str2double(get(handles.edit1,'String'))/100;
nu=round(porc*n);

% min1=1;
% min2=1;
% max1=size(prueba,1);
% max2=size(prueba,2);
% 
% a=round(min1 + (max1 - min1).*rand(1,n));
% b=round(min2 + (max2 - min2).*rand(1,n));
% 
% for i=1:length(a)
%     prueba((a(i)),(b(i)))=(prueba((a(i)),(b(i)))*-1)+1;
% end

ran=randperm(n,nu);

for i=1:nu
    prueba(ran(i))=(prueba(ran(i))*-1)+1;
end

prueba=ensamb(prueba,dim,dim);
prueba=(prueba.*2)-1;
imshow(prueba,'Parent',handles.axes1,'InitialMagnification','fit');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global prueba dim W S

prueba=prueba(:);
imshow(ensamb(prueba,dim,dim),'InitialMagnification','fit','Parent',handles.axes2);
c=0;
rep=0;
while true
    c=c+1

    imshow(ensamb(prueba,dim,dim),'InitialMagnification','fit','Parent',handles.axes2);
    drawnow

    pruebaant=prueba;
    S=W*prueba;
    for i=1:length(S)
        if S(i)==0
            S(i)==pruebaant(i)
        end
    end
    prueba=S>0;
    prueba=(prueba.*2)-1;
    if pruebaant==prueba
        rep=rep+1;
        if rep>15
            break
        end
    end
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dim prueba im
prueba=imread(im);
prueba=im2bw(prueba);

prueba=imcomplement(prueba);
s=regionprops(prueba);
prueba=imcrop(prueba,s.BoundingBox);
prueba=imcomplement(prueba);

prueba=imresize(prueba,[dim dim]);

imshow(prueba,'Parent',handles.axes1,'InitialMagnification','fit');