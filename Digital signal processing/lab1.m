%% Lab 1 PDS - Sampling and Aliasing

% Grupo xx, turno Lxx
% Spike n� xxxxx
% Colega do Spike n� xxxxx

%%
clear;

% Quest 1
t = (1:8000);
k = 1000;

% 4*8000 = 32000 samples during 4 seconds
i = 1;
ti = linspace(0,4,32000);
x = cos(2*pi*(0.5*k.*(ti).^2));

soundsc(x,8000)

%R1.a)  Observa-se que o aumento da frequ�ncia de x, que deriva do aumento da veri�vel de tempo ti,
%leva a uma audi��o de um som mais agudo, j� que uma diminui��o na frequ�ncia leva � audi��o de sons mais graves.



%%
% Quest 2

% n should be a multiple of 4 
n = 32;
figure;
spectrogram(x, hann(n), 3*n/4, 4*n, 8000, 'yaxis')

figure(2);
n = 80;
spectrogram(x, hann(n), 3*n/4, 4*n, 8000, 'yaxis')

figure(3);
n = 160;
spectrogram(x, hann(n), 3*n/4, 4*n, 8000, 'yaxis')


figure(4);
n = 400;
spectrogram(x, hann(n), 3*n/4, 4*n, 8000, 'yaxis')


figure(5);
n = 800;
spectrogram(x, hann(n), 3*n/4, 4*n, 8000, 'yaxis')

% R2.a) Pelo espectograma nota-se que as componentes mais energ�ticas, que
% representam a frequ�ncia do sinal ( a amarelo ) t�m contornos mais
% explicitos quando se aumenta o n, ou seja, fica mais restrita em
% frequ�ncia. Um bom n ser� n = 400, por exemplo, uma vez que a faixa de frequ�ncias
% na qual se encontra o sinal � mais restrita em cada intervalo de
% tempo.
% Isto �, aumentando a "length" da janela, obt�m-se melhor resulu��o na frequ�ncia.
% A contrapartida do aumento de resolu��o em frequ�ncia � a perda de
% resolu��o temporal, observada cada vez mais intensamente a partir de n =
% 400.

% R2.b) Com o aumento na escala temporal ouve-se um som cada vez mais
% agudo, que � justificado pelo aumento de frequ�ncia do sinal observado no
% espectograma.

%% 
% Quest 3
% Subsampling
close all;

% 32000/2 = 16000

for n=1:16000
y(n) = x(n*2);
end
soundsc(y,4000)

n = 180;
figure;
spectrogram(y, hann(n), 3*n/4, 4*n, 4000, 'yaxis')

% R3.a) Sampling frequency de y(n) ser� 4000 samples/second uma vez que o
% sinal tem a mesma dura��o mas as amostras est�o espa�adas duplamente.

% R3.b) Aos dois segundos verifica-se que a frequ�ncia do sinal come�a a
% decrescer, portanto o som vai-se tornando mais grave at� aos 4 seg.
% Isto ocorre devido ao fen�meno de aliasing, o que provoca que as
% frequ�ncias acima de 2kHz sejam espelhadas, uma vez que a frequ�ncia de
% amostragem � 4kHz e o teorema de Nyquist n�o � cumprido. 
% O que acontece neste fen�meno � que durante a amostragem, s transformada
% do sinal � decomposta num trem de impulsos. Se houver frequ�ncias acima e
% Fs/2, quando se faz a reconstru��o do sinal, existem frequ�ncias que s�o
% dadas pela diferen�a entre a frequ�ncia de amostragem e a frequ�ncia do
% sinal. Por exemplo, se a frequ�ncia for 3kHz, quando o sinal �
% reconstruido, a frequ�ncia aparente ser� de 1kHz.

%%
% Quest 4
close all;
clear;

n = 1200;
[x, Fs] = audioread('romanza_pe.wav');
soundsc(x,Fs);

% signal's sampling freq (Fs) =  44100;

% x1 is the first 10 sec of x
x1 = zeros(10*Fs,1);
for i = 1:(10*Fs)
    x1(i) = x(i);
end

figure;
spectrogram(x1, hann(n), 3*n/4, 4*n, Fs, 'yaxis')

% R4.a) Window duration used: 1200 

% R4.b) 
%   As linhas est�o onduladas uma vez que o movimento das cordas leva a que
%   o som do violino seja algo 'vibrato', ou seja, oscile em torno de uma
%   certa nota, representada no espectrograma por uma frequ�ncia. �
%   imposs�vel atrav�s de instrumentos anal�gicos atingir com precis�o uma
%   dada frequ�ncia sem que haja esta oscila��o, por muito pequena que seja.


%% 
% Quest 5

close all;
clear;

n = 800;
[x, Fs] = audioread('romanza_pe.wav');

% x2 corresponde ao novo sinal amostrado com Fs = Fs/5 durante 10 segundos
x2 = zeros((Fs/5)*10,1);
for i=1:((Fs/5)*10)
    x2(i) = x(i*5);
end

soundsc(x2,Fs/5);

% signal's new sampling freq (Fs) =  44100/5 = 8820;

figure;
spectrogram(x2, hann(n), 3*n/4, 4*n, Fs/5, 'yaxis');

% R5.a) O sinal perde alguma qualidade, resultado da amostragem mais
% espa�ada. 
%   Pelo espectrograma e pelo audio nota-se que o sinal � mais percept�vel numa gama de
%   frequ�ncias mais baixa, portanto conclui-se que o downsampling tem
%   implica��es na frequ�ncia do sinal anal�gico convertido. Sabe-se que
%   este sinal � amostrado a 8820 samples/segundo. Analisando o
%   espectrograma nota-se que a partir de certas frequ�ncias, o teorema da
%   amostragem n�o � cumprido, ocorrendo aliasing, pelo que as frequ�ncias
%   mais altas s�o espelhadas para uma zona de frequ�ncias mais baixa.
%%

% Quest 6

% filtragem do sinal x da al�nea 4
xf = filter(fir1(100,0.2),1,x);

x3 = zeros((Fs/5)*10,1);
for i=1:((Fs/5)*10)
x3(i) = xf(i*5);
end

soundsc(x3,Fs/5);

n = 1000;

figure;
spectrogram(x3, hann(n), 3*n/4, 4*n, Fs/5, 'yaxis');

% R6.a) 
% Relativamente � audi��o do sinal, nota-se que este � muito mais
% percept�vel, situando-se na mesma gama de frequ�ncias do sinal da al�nea
% 5. Isto deve-se ao facto de n�o ocorrer aliasing. J� o espectrograma
% apresenta tamb�m pelo mesmo facto menos valores diferentes de frequ�ncias
% em cada instante temporal.
% O filtro passa-baixo funciona ent�o como um filtro de anti-aliasing, que
% permite que se cumpra o teorema da amostragem e portanto n�o haja
% espelhamento das frequ�ncias mais altas na gama inferior de frequ�ncias
% do espectro. (explicado na 3.b)
% Comparando com a quest�o 4, o som n�o tem todas as frequ�ncias, uma vez
% que foi colocado o filtro passa-baixo, no entanto, o espectro nas
% frequ�ncias que se mant�m � semelhante, o que n�o acontece na quest�o 5.
