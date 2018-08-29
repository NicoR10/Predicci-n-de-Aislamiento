function [R_teorico] = Rteorico (ro,E,po,e,K)
% Calcula el R por método teorico (ley de masa, ley de masa corregida)

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
m=ro*e;
c0=343; %velocidad del sonido en el aire
r0=1.293; %densidad del aire
f=[25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6000, 8000, 10000, 12500, 16000, 20000];

%% cálculo de B, fc, fd

%B
B=(E*(e^3))/(12*(1-(po^2)));
%fc
fc=(((c0)^2)/(1.8*e))*(sqrt(ro/E));
%fd
fd=(K/(2*pi*ro))*sqrt(m/B);
%% Calculo de nu por banda de tercio de octava

if m<800

for i=1:length(f)
    nu(i)=((0.01)+(m/(485*sqrt(f(i)))));
end
else
    msgbox('El valor de la masa superficial es demasiado grande para estimar el amortiguamiento teoricamente.');
end

%% calculo de R

for i=1:length(f)
    if f(i)<fc
        R_teorico(i)=20*log10(m*f(i))-47;
    elseif f(i)>fc && f(i)<fd
        R_teorico(i)=20*log10((2*pi*f(i)*m)/(2*r0*c0))-10*log10(pi/(4*nu(i)))+10*log10(f(i)/fc)+10*log10(1-(fc/f(i)))-5;
    elseif f(i)>fd
        R_teorico(i)=20*log10(m*f(i))-47;
    end
    R_teorico;
end        