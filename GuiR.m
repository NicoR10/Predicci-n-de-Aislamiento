function varargout = GuiR(varargin)
% GUIR MATLAB code for GuiR.fig
%      GUIR, by itself, creates a new GUIR or raises the existing
%      singleton*.
%
%      H = GUIR returns the handle to a new GUIR or the handle to
%      the existing singleton*.
%
%      GUIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIR.M with the given input arguments.
%
%      GUIR('Property','Value',...) creates a new GUIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiR

% Last Modified by GUIDE v2.5 13-Nov-2016 18:34:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiR_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiR_OutputFcn, ...
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

% --- Executes just before GuiR is made visible.
function GuiR_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.Calcular,'Visible','off')
set(handles.Paneldimensiones,'visible','off')
set(handles.uipanel6,'visible','off')
set(handles.uipanel7,'visible','off')

clc
xlabel('Frecuencia (Hz)','Fontsize',8);
ylabel('Índice de reducción sonora R(dB)','Fontsize',10);
data= xlsread('MII_TP1_RacedoNicolás.xlsx');  
ro = data(1:14,1);
E = data(1:14,2);
nu = data(1:14,3);
po = data(1:14,4);
K = data(1:14,5);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiR (see VARARGIN)

% Choose default command line output for GuiR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuiR wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Calcular.
function Calcular_Callback(hObject, eventdata, handles)
set(handles.uipanel7,'visible','on')

global f
f = [25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6000 8000 10000 12500 16000 20000];
handles.f = f;
a = get(handles.Teorico,'value');
b = get(handles.ISO,'value');
c = get(handles.Sharp,'value');
d = get(handles.Davy,'value');

if a==1

global R_teorico
    
data= xlsread('MII_TP1_RacedoNicolás.xlsx');
v = get(handles.Listamateriales,'Value');
g= v;
ro = data(g,1);
E = data(g,2);
nu = data(g,3);
po = data(g,4);
e = str2double(get(handles.editespesor,'String'));
K = data(g,5);

R_teorico = Rteorico (ro,E,po,e,K);
handles.R_teorico = R_teorico;
fc = (((343^2)/(1.8*e))*sqrt(ro/E));
handles.fc= fc;
guidata(hObject, handles);

end

if b==1
    
    e=str2double(get(handles.editalto,'string'));
k=str2double(get(handles.editlargo,'string'));
if e>k
    msgbox('ERROR: El largo de la pared no puede ser menor que su altura. Ingrese nuevamente los valores.')
    set(handles.editalto,'string','')
    set(handles.editlargo,'string','')
    set(handles.Teorico,'value',0)
set(handles.ISO,'value',0)
set(handles.Sharp,'value',0)
set(handles.Davy,'value',0)
set(handles.Calcular,'Visible','off')
end
global R_iso
data= xlsread('MII_TP1_RacedoNicolás.xlsx');
v = get(handles.Listamateriales,'Value');
g = v;
ro = data(g,1);
E = data(g,2);
e = str2double(get(handles.editespesor,'String'));
L1 = str2double(get(handles.editlargo,'String'));
L2 = str2double(get(handles.editalto,'String'));

if e*ro>800
    msgbox('ISO 12354-1: El valor de la masa superficial es demasiado grande para estimar el amortiguamiento teoricamente. Desestime los valores por método ISO.');
else
    R_iso = ISO12354 (ro,E,L1,L2,e);
end
handles.R_iso = R_iso;
fc = (((343^2)/(1.8*e))*sqrt(ro/E));
handles.fc= fc;
guidata(hObject, handles);

end

if c==1
    
global R_sharp
data= xlsread('MII_TP1_RacedoNicolás.xlsx');
v = get(handles.Listamateriales,'Value');
g = v;
ro = data(g,1);
E = data(g,2);
nu = data(g,3);
po = data(g,4);
e = str2double(get(handles.editespesor,'String'));
L1 = str2double(get(handles.editlargo,'String'));
L2 = str2double(get(handles.editalto,'String'));
            
R_sharp = Sharp (ro,E,po,L1,L2,e);
handles.R_sharp = R_sharp;
fc = (((343^2)/(1.8*e))*sqrt(ro/E));
handles.fc= fc;
guidata(hObject, handles);

end

if d==1
    
global R_Davy
data= xlsread('MII_TP1_RacedoNicolás.xlsx');
v = get(handles.Listamateriales,'Value');
g = v;
ro = data(g,1);
nu = data(g,3);
po = data(g,4);
E = data(g,2);
e = str2double(get(handles.editespesor,'String'));
L1 = str2double(get(handles.editlargo,'String'));
L2 = str2double(get(handles.editalto,'String'));

R_Davy = Rdavy (ro,E,po,L1,L2,e);
handles.R_Davy = R_Davy;
fc = (((343^2)/(1.8*e))*sqrt(ro/E));
handles.fc= fc;
guidata(hObject, handles);

end
    
switch a
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-')
        legend('TEORICO'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch b
    case 1
        semilogx(handles.grafico,handles.f,handles.R_iso,'r-')
        legend('ISO'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch c
    case 1
        semilogx(handles.grafico,handles.f,handles.R_sharp,'m-')
        legend('SHARP'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_Davy,'g-')
        legend('DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&b
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_iso,'r-')
        legend('TEORICO','ISO'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&c
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_sharp,'m-')
        legend('TEORICO','SHARP'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_Davy,'g-')
        legend('TEORICO','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch b&c
    case 1
        semilogx(handles.grafico,handles.f,handles.R_iso,'r-',handles.f,handles.R_sharp,'m-')
        legend('ISO','SHARP'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch b&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_iso,'r-',handles.f,handles.R_Davy,'g-')
        legend('ISO','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
        
    case 2
        0;
end
switch c&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_sharp,'m-',handles.f,handles.R_Davy,'g-')
        legend('SHARP','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&b&c
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_iso,'r-',handles.f,handles.R_sharp,'m-')
        legend('TEORICO','ISO','SHARP'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&b&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_iso,'r-',handles.f,handles.R_Davy,'g-')
        legend('TEORICO','ISO','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&c&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_sharp,'m-',handles.f,handles.R_Davy,'g-')
        legend('TEORICO','SHARP','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch b&c&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_iso,'r-',handles.f,handles.R_sharp,'m-',handles.f,handles.R_Davy,'g-')
        legend('ISO','SHARP','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
switch a&b&c&d
    case 1
        semilogx(handles.grafico,handles.f,handles.R_teorico,'b-',handles.f,handles.R_iso,'r-',handles.f,handles.R_sharp,'m-',handles.f,handles.R_Davy,'g-')
        legend('TEORICO','ISO','SHARP','DAVY'),grid on
        xlabel('Frecuencias [Hz]')
        ylabel('TL [dB]')
        set(gca,'XTickLabel',{'25','31,5','40','50','63','80','100','125','160','200','250','315','400','500','630','800','1K','1.25K','1.6K','2K','2.5K','3.15K','4K','5K','6.3K','8K','10K','12.5K','16K','20K'},...
    'XTick',[25;31.5;40;50;63;80;100;125;160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000;10000;12500;16000;20000],'fontsize',8)
    case 2
        0;
end
% hObject    handle to Calcular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Exportar.
function Exportar_Callback(hObject, eventdata, handles)
% hObject    handle to Exportar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
w = get(handles.Teorico,'value');
y = get(handles.ISO,'value');
u = get(handles.Sharp,'value');
l = get(handles.Davy,'value');

if w>0, xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',handles.R_teorico,'B7:AE7')
else xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',0,'B7:AE7')
end
if y>0, xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',handles.R_iso,'B8:AE8')
else xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',0,'B8:AE8');
end
if u>0, xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',handles.R_sharp,'B9:AE9')
else xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',0,'B9:AE9')
end
if l>0, xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',handles.R_Davy,'B10:AE10')
else xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',0,'B10:AE10')
end


d = get(handles.Listamateriales,'string');
g = get(handles.Listamateriales,'value');
p = d(g);
xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',d(g),1,'B3')
espesor = str2double(get(handles.editespesor,'String'));
alto = str2double(get(handles.editalto,'String'));
largo = str2double(get(handles.editlargo,'String'));
xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',largo,1,'G4');
xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',alto,1,'H4');
xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',espesor,1,'I4');
xlswrite('MII_TP1_EXPORT_RacedoNicolás.xlsx',handles.fc,1,'J4');


% hObject    handle to exportar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Borrar.
function Borrar_Callback(hObject, eventdata, handles)
% hObject    handle to Borrar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Listamateriales,'value',1)
set(handles.Teorico,'value',0)
set(handles.ISO,'value',0)
set(handles.Sharp,'value',0)
set(handles.Davy,'value',0)
set(handles.editalto,'string','')
set(handles.editlargo,'string','')
set(handles.editespesor,'string','')
set(handles.Calcular,'Visible','off')
set(handles.Paneldimensiones,'visible','off')
set(handles.uipanel6,'visible','off')
set(handles.uipanel7,'visible','off')

cla reset

% --- Executes on button press in ISO.
function ISO_Callback(hObject, eventdata, handles)
set(handles.Calcular,'Visible','on')
% hObject    handle to ISO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ISO


% --- Executes on button press in Davy.
function Davy_Callback(hObject, eventdata, handles)
% hObject    handle to Davy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Calcular,'Visible','on')
% Hint: get(hObject,'Value') returns toggle state of Davy


% --- Executes on button press in Sharp.
function Sharp_Callback(hObject, eventdata, handles)
% hObject    handle to Sharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Calcular,'Visible','on')
% Hint: get(hObject,'Value') returns toggle state of Sharp


% --- Executes on button press in Teorico.
function Teorico_Callback(hObject, eventdata, handles)
% hObject    handle to Teorico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Calcular,'Visible','on')
% Hint: get(hObject,'Value') returns toggle state of Teorico



function editlargo_Callback(hObject, eventdata, handles)
% hObject    handle to editlargo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editlargo as text
%        str2double(get(hObject,'String')) returns contents of editlargo as a double


% --- Executes during object creation, after setting all properties.
function editlargo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editlargo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editalto_Callback(hObject, eventdata, handles)
% hObject    handle to editalto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editalto as text
%        str2double(get(hObject,'String')) returns contents of editalto as a double


% --- Executes during object creation, after setting all properties.
function editalto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editalto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editespesor_Callback(hObject, eventdata, handles)
% hObject    handle to editespesor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6,'visible','on')

% Hints: get(hObject,'String') returns contents of editespesor as text
%        str2double(get(hObject,'String')) returns contents of editespesor as a double


% --- Executes during object creation, after setting all properties.
function editespesor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editespesor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Listamateriales.
function Listamateriales_Callback(hObject, eventdata, handles)
[~, materiales]=xlsread('MII_TP1_RacedoNicolás.xlsx','','A2:A15','basic');
set(handles.Listamateriales,'String',materiales);
set(handles.Paneldimensiones,'visible','on')
% hObject    handle to Listamateriales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Listamateriales contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Listamateriales


% --- Executes during object creation, after setting all properties.
function Listamateriales_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Listamateriales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
