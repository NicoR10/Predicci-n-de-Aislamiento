function [R_davy] = Rdavy (ro,E,po,L1,L2,e)

% Calcula el R por método Davy

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

%% Constantes
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
%% Metodo davy

%calculo de a y fi

for i=1:length(f)
    a(i)=((pi*f(i)*m)/(r0*c0))*(1-((f(i)/fc)^2));
    fi(i)=(1/cos(c0/(f(i)*2*pi*sqrt(L1*L2))));
end

%Davy

for i=1:length(f)
    if f(i)<=0.8*fc
        R_davy(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+20*log10(1-((f(i)/fc)^2))-10*log10(log((1+(a(i)^2))/(1+(a(i)*(cos(fi(i))))^2)));
    elseif f(i)>0.8*fc && f(i)<0.95*fc
        c(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+20*log10(1-((f(i)/fc)^2))-10*log10(log((1+a(i)^2)/(1+(a(i)^2)*((cos(fi(i)))^2))));
        d(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+10*log10((2*nu(i)*0.236)/pi);
        if c(i)>d(i)
            R_davy(i)=c(i);
        else
            R_davy(i)=d(i);
        end
    elseif f(i)>=0.95*fc && f(i)<=1.05*fc
        R_davy(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+10*log10((2*nu(i)*0.236)/pi);
    elseif f(i)>1.05*fc && f(i)<=1.7*fc
        h(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+10*log10(((2*nu(i))/pi)*((f(i)/fc)-1));
        g(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+10*log10((2*nu(i)*0.236)/pi);
        if h(i)>g(i)
            R_davy(i)=h(i);
        else
            R_davy(i)=g(i);
        end
    elseif f(i)>1.7*fc
            R_davy(i)=10*log10(1+((pi*f(i)*m)/(r0*c0))^2)+10*log10(((2*nu(i))/pi)*((f(i)/fc)-1));
    end
end
R_davy;
end
            



