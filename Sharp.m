function [R_sharp] = Sharp (ro,E,po,L1,L2,e)
% Calcula el R por método sharp

%% Referencias

%f (frecuencia - tercios de octava-)
%fc (frecuencia crítica)
%r0 (densidad del aire)
%c0 (velocidad del sonido en el aire)
%m (masa superficial)
%s (factor de radiación de ondas de flexión libres)
%sf (factor de radiacion para transmision forzada)
%nu (factor de pérdidas total - Amortiguamiento-)
%L1,L2 (longitudes de los bordes)
%E (módulo de young del material)
%ro (densidad del material)
%tf (tao)
%e (espesor)
%po (modulo de poisson)

%% Variables
c0=343; %velocidad del sonido en el aire
r0=1.293; %densidad del aire
f=[25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6000, 8000, 10000, 12500, 16000, 20000];

%% Cálculos previos
%calculo de m
m=ro*e;
% calculo de B
B=(E*(e^3))/(12*(1-(po^2)));
%calculo de fc
fc=(((c0)^2)/(1.8*e))*(sqrt(ro/E));
%calculo de f11
f11=(((c0^2)/(4*fc))*((1/(L1^2))+(1/(L2^2))));
%% Calculo de nu por banda de tercio de octava

if m<800

for i=1:length(f)
    nu(i)=((0.01)+(m/(485*sqrt(f(i)))));
end
else
    msgbox('El valor de la masa superficial es demasiado grande para estimar el amortiguamiento teoricamente.');
end


%% calculo de sharp

for i=1:length(f)
    if f(i)>=fc
       a(i)=10*log10(1+((pi*m*f(i))/(r0*c0))^2)+10*log10(2*nu(i)*f(i)/(pi*fc));
       b(i)=10*log10(1+((pi*m*f(i))/(r0*c0))^2)-5.5;
       if a(i)<b(i)
           R_sharp(i)=a(i);
       else
           R_sharp(i)=b(i);
       end
    elseif f(i)<0.5*fc && f(i)>(1.5*f11)
        R_sharp(i)=10*log10(1+((pi*m*f(i))/(r0*c0))^2)-5.5;
    elseif f(i)<1.5*f11
        R_sharp(i)=20*log10(pi^4*B*(((1/(L1^2))+(1/(L2^2)))^2))-20*log10(f(i))-20*log10(4*pi*r0*c0);
        
%interpolacion lineal
    elseif f(i)>= 0.5*fc && f(i)<fc
        fx1=10*log10(1+(((pi*m*0.5*fc)/(r0*c0))^2))-5.5;
        fx2=10*log10(1+(((pi*m*fc)/(r0*c0))^2))+10*log10((2*nu(i))/pi);
        
     R_sharp(i)= ((f(i)- 0.5*fc)/(fc-0.5*fc))*(fx2-fx1)+fx1;   
    end
    R_sharp;
end
