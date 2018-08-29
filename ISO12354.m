function [R_iso] = ISO12354 (ro,E,L1,L2,e)

%Método de calculo teórico del índice de reduccion sonora R por norma
%ISO_12354_1

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
    msgbox('ISO 12354-1: El valor de la masa superficial es demasiado grande para estimar el amortiguamiento teoricamente.');
end

%% calculo de s

%definimos d1 y d2

for i=1:length(f)
lda(i)=sqrt(f(i)/fc);
d1(i)=(((1-(lda(i)^2))*(log(((1+lda(i))/(1-lda(i))))))+(2*lda(i)))/((4*(pi^2))*((1-(((lda(i))^2)))^(1.5)));
end

for i=1:length(f)
if f(i)>(fc/2)
    d2(i)=0;
else
    d2(i)=((8*c0*(1-(2*(lda(i)^2))))/((fc^2)*(pi^4)*L1*L2*(lda(i))*sqrt(1-((lda(i))^2))));
end
end
    
%calculo de s(i)

if f11<=(fc/2)
    for i=1:length(f)
        if f(i)>=fc
            s(i)=(1/(sqrt(1-(fc/f(i)))));
        elseif f(i)<fc
            s(i)=((((2*(L1+L2)*c0)/(L1*L2*fc))*(d1(i)))+(d2(i)));
        end
    end
%corrección
    for i=1:length(f)
    if f(i)<f11<(fc/2) && s(i)>(4*L1*L2*((f(i)/c0)^2))
        s(i)=(4*L1*L2*((f(i)/c0)^2));
    end
    end
else
    for i=1:length(f)
    if f(i)<fc && (4*L1*L2*((f(i)/c0)^2))<sqrt((2*pi*f(i)*(L1+L2))/(16*c0))
    s(i)=(4*L1*L2*((f(i)/c0)^2));
    else if f(i)>fc && (1/(sqrt(1-(fc/f(i)))))<sqrt((2*pi*f(i)*(L1+L2))/(16*c0))
            s(i)=(1/(sqrt(1-(fc/f(i)))));
        else
            s(i)=sqrt((2*pi*f(i)*(L1+L2))/(16*c0));
        end
    end
    end
end

%% calculo de sf (L1>L2)

%calculo de k0

for i=1:length(f)
    k(i)=((2*pi*f(i))/c0);
end

%calculo de A
for i=1:length(f)
A(i)=(-0.964)-(((0.5)+((L2/(pi*L1))))*log(L2/L1))+((5*L2)/(2*pi*L1))-((4*pi*L1*L2*((k(i))^2))^-1);
end

%calculo de sf

for i=1:length(f)
sf(i)=(0.5)*((log((k(i)*sqrt(L1*L2))))-A(i));
end

for i=1:length(f)
    if s(i)>2
        s(i)=2;
    end
end

for i=1:length(f)
    if sf(i)>2
        sf(i)=2;
    end
end

%% calculo de tao

for i=1:length(f)
    
if f(i)>(fc+((0.05)*fc))
    tf(i)=((((2*r0*c0)/(2*pi*f(i)*m))^2)*((pi*fc*((s(i))^2))/(2*f(i)*nu(i))));
    
else if f(i)<(fc-((0.05)*fc))
    tf(i)=((((2*r0*c0)/(2*pi*f(i)*m))^2)*((2*(sf(i)))+((((L1+L2)^2)/((L1^2)+(L2^2)))*(((s(i))^2)/nu(i))*(sqrt(fc/(f(i)))))));
    
else 
    tf(i)=((((2*r0*c0)/(2*pi*f(i)*m))^2)*((pi*((s(i))^2))/(2*nu(i))));
     end
end
end
%% calculo de R por tercio de octava

for i=1:length(f)
    R_iso(i)=((-10)*log10(tf(i)));
end
R_iso;
end
