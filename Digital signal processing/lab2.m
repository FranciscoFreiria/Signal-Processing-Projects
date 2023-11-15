%% Lab 2 PDS - DFT

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

%%
clear

% Quest 1a) & 1b)

% signal duration
M=512;

n = linspace(0,M-1,M);
w0 = 5.2*2*pi/M;
x = 5*cos(w0*n + 1) + 2*cos(2*w0*n + 2) + 3*cos(5*w0*n + 3);
figure
plot(n,x)
xlabel('samples n');
ylabel('amplitude');

% Observa-se o sinal constituido pela soma de 3 sinus�ides de amplitudes
% diferentes, desfasadas e com frequ�ncia que difere numa constante. Desta
% forma observa-se um sinal peri�dico com amplitude m�xima de x(n)=9.135. 

%%
% Quest 1c)

% Sampling frequency - dobro do maximo da freq do sinal
Fs = 1000; 
% Sampling period
T = 1/Fs;          

%DFT length
N = 512;

% normalizado a N
xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   
%P1 = P2(1:N/2+1);
%P1(2:end-1) = 2*P1(2:end-1); 
f = (-N/2:1:(N/2)-1)/N;
figure
plot(f,P2)
xlim([0 0.1]); 
title('Single-Sided Amplitude Spectrum of X(n)')
xlabel('frequency (Hz)')
ylabel('|X(f)|')

figure
plot(angle(xfft))
title('Single-Sided Phase Spectrum of X(n)')
xlabel('frequency (Hz)')
ylabel('angle X(f)')

% A transformada de fourier do sinal é par, e tem seis picos nas
% frequências que estão indicadas em cada um dos três cossenos, como seria
% de esperar. Ao reduzir para um lado, passamos a ter apenas 3 picos no
% espectro, que é o resultado pretendido. O espectro de fase tem um
% comportamento também dentro do esperado

%%
% Quest 1d)

%peaks magnitude:

%peak1: f = 0.00977 Hz ; |X(f)| = 2349; index = 262
%peak2: f = 0.01953 Hz ; |X(f)| = 805.6; index = 267
%peak3: f = 0.05078 Hz ; |X(f)| = 1514; index = 283

%peaks phase:
fase = angle(xfft);

peak1 = fase(262);
peak2 = fase(267);
peak3 = fase(283);

%peak1: f = 9.77*10^-3 Hz  ; angle X(f) = 1.6611 rad; index = 262
%peak2: f = 19.53*10^-3 Hz ; angle X(f) = -2.8673 rad; index = 267
%peak3: f = 50.78*10^-3 Hz ; angle X(f) = 3.0211 rad; index = 283

%%
% reconstruct the signal
n = linspace(0,M-1,M);

yfft1 = 2349/M*cos(0.00977*2*pi*n + 1.6611);
yfft2 = 805.6/M*cos(0.01953*2*pi*n -2.8673);
yfft3 = 1514/M*cos(0.05078*2*pi*n + 3.0211);
yfft = yfft1+yfft2+yfft3;
figure
plot(n,yfft)

% 

%%
% Quest 1e)

figure
plot(n,x)
xlabel('f (Hz)')
hold on
plot(n,yfft)
legend('x(n)', 'xr(n)');

% Nota-se que os sinais s�o id�nticos na sua forma, no entanto existem
% algumas diferen�as entre o sinal reconstruido e o sinal original. A FFT �
% um processo computacional que aplica a DFT a um sinal peri�dico, mas s� o
% pode fazer se este tiver uma dura��o finita. Ao observar os cossenos
% individualmente, nota-se que os erros de reconstrução são menores, mas ao
% somar esses cossenos, o sinal não fica exatamente igual.


%%

% Quest 1f)
clear

% novas condi��es
M = 512;
Fs = 1000;
N = 1024;
n = linspace(0,M-1,M);
w0 = 5.2*2*pi/M;
x = 5*cos(w0*n + 1) + 2*cos(2*w0*n + 2) + 3*cos(5*w0*n + 3);

% normalizado a N
xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   
%P1 = P2(1:N/2+1);
%P1(2:end-1) = 2*P1(2:end-1); 
f = (-N/2:1:(N/2)-1)/N;


figure
plot(f,P2)
title('Single-Sided Amplitude Spectrum of X(n)')
xlabel('f (Hz)')
ylabel('|X(f)|')
xlim([0 0.1]); 
figure
plot(angle(xfft))
title('Single-Sided Phase Spectrum of X(n)')
xlabel('f (Hz)')
ylabel('angle X(f)')

%%
%peaks magnitude do novo sinal:

%peak1: f = 9.766*10^-3 Hz ; |X(f)| = 2349; index = 523
%peak2: f = 0.02051 Hz ; |X(f)| = 997.9; index = 534
%peak3: f = 0.05078 Hz ; |X(f)| = 1514; index = 565

%peaks phase:
fase = angle(xfft);
peak1 = fase(523);
peak2 = fase(534);
peak3 = fase(565);

%peak1: f = 9.766*10^-3 Hz   ; angle X(f) = 1.6611 rad; index = 523
%peak2: f = 0.02051 Hz  ; angle X(f) = 1.6176 rad; index = 534
%peak3: f = 0.05078 Hz ; angle X(f) = 3.0211 rad; index = 565

% reconstruct the signal

n = linspace(0,M-1,M);

yfft1 = 2349/M*cos(0.009766*2*pi*n + 1.6623);
yfft2 = 997.9/M*cos(0.02051*2*pi*n +1.6176);
yfft3 = 1514/M*cos(0.05078*2*pi*n + 3.0211);
yfft = yfft1+yfft2+yfft3;

% sinal reconstruido
figure
plot(n,yfft)

%%

% compara��o do sinal original com o sinal reconstruido
figure
plot(n,x)
xlabel('f (Hz)')
hold on
plot(n,yfft)
legend('x(n)', 'xr(n)');


% Reparando no vetor de frequ�ncia, nota-se que este tem a mesma amplitude,
% mas intervalos mais pequenos, o que provoca uma melhor resolu��o
% espectral (aquisi��o de um maior n�mero de amostras);
% Aumentando o valor de N (dura��o da FFT), o sinal � mais pr�ximo do
% original uma vez que foram aumentadas tamb�m o n�mero de amostras, o que
% provoca uma reconstru��o melhorada uma vez que s�o usados mais pontos.

%%

% Quest 2a & 2b)

M = 2048;
[x, Fs] = audioread('How_many_roads.wav');
%soundsc(x,Fs)

x1 = zeros(length(M));

for i=48500:(48500+M-1)
    
    x1(i-48499)= x(i,1);
end

%soundsc(x1,Fs)


%%
% Quest 2b

% O speaker � o prof. Jorge.

%%

% Quest 2c) e d)

% Sampling frequency
Fs = 41800; 
% Sampling period
T = 1/Fs;         

N = 2048;

% normalizado a N
xfft1 = fft(x1,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   
f = (-N/2:1:(N/2)-1)/N;

figure
plot(f,P2)
xlim([0 0.1]); 
title('Single-Sided Amplitude Spectrum of X(n)')
xlabel('f (Hz)')
ylabel('|X(f)|')

figure
plot(angle(xfft))
title('Single-Sided Phase Spectrum of X(n)')
xlabel('f (Hz)')
ylabel('angle X(f)')

%%
%peaks magnitude do novo sinal:

%peak1: f = 0.00293 Hz ; |X(f)| = 37.79; index = 1031
%peak2: f = 0.005859 Hz ; |X(f)| = 22.64; index = 1037
%peak3: f = 0.008789 Hz ; |X(f)| = 15.05; index = 1043

%peaks phase:
fase = angle(xfft);
peak1 = fase(1031);
peak2 = fase(1037);
peak3 = fase(1043);

%peak1: f = 0.00293 Hz ; angle = -0.6054; index = 1031
%peak2: f = 0.005859 Hz ; angle = -0.4384; index = 1037
%peak3: f = 0.008789 Hz ; angle = -2.6141; index = 1043

% reconstruir o sinal

% reconstruct the signal
n = linspace(0,M-1,M);

yfft1 = 37.39/M*cos(0.00293*2*pi*n -0.6054);
yfft2 = 22.64/M*cos(0.005859*2*pi*n -0.4384);
yfft3 = 15.05/M*cos(0.008789*2*pi*n - 2.6141);
yfft = yfft1+yfft2+yfft3;
figure
plot(n,yfft)

%%

% Quest 2e)

n = linspace(0,M-1,M);

% compara��o do sinal original com o sinal reconstruido
figure
plot(n,x1)
xlabel('f (Hz)')
hold on
plot(n,yfft)
legend('x(n)', 'xr(n)');


% Uma vez que s� se atendeu, na reconstru��o do sinal, �s 3 sinus�ides mais relevantes, isto faz com que 
% a reconstru��o n�o seja perfeita, uma vez que o sinal de voz �
% constituido por in�meras sinus�ides. Contudo, em termos de frequ�ncia de
% sinal e amplitude, os resultados s�o id�nticos.
% Quando a duração do sinal é maior do que a duração da FFT, ao somar os diferentes cossenos
% que compõem o sinal, ocorre aliasing no domínio do tempo. Isto é comprovado pelas
% oscilações observadas ao fazer zoom na janela da DFT e este processo é
% cada vez mais visivel com o aumento de N.