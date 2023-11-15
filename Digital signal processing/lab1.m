%% Lab 1 PDS - Sampling and Aliasing

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

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

%R1.a)  Observa-se que o aumento da frequência de x, que deriva do aumento da veriável de tempo ti,
%leva a uma audição de um som mais agudo, já que uma diminuição na frequência leva à audição de sons mais graves.



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

% R2.a) Pelo espectograma nota-se que as componentes mais energéticas, que
% representam a frequência do sinal ( a amarelo ) têm contornos mais
% explicitos quando se aumenta o n, ou seja, fica mais restrita em
% frequência. Um bom n será n = 400, por exemplo, uma vez que a faixa de frequências
% na qual se encontra o sinal é mais restrita em cada intervalo de
% tempo.
% Isto é, aumentando a "length" da janela, obtém-se melhor resulução na frequência.
% A contrapartida do aumento de resolução em frequência é a perda de
% resolução temporal, observada cada vez mais intensamente a partir de n =
% 400.

% R2.b) Com o aumento na escala temporal ouve-se um som cada vez mais
% agudo, que é justificado pelo aumento de frequência do sinal observado no
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

% R3.a) Sampling frequency de y(n) será 4000 samples/second uma vez que o
% sinal tem a mesma duração mas as amostras estão espaçadas duplamente.

% R3.b) Aos dois segundos verifica-se que a frequência do sinal começa a
% decrescer, portanto o som vai-se tornando mais grave até aos 4 seg.
% Isto ocorre devido ao fenómeno de aliasing, o que provoca que as
% frequências acima de 2kHz sejam espelhadas, uma vez que a frequência de
% amostragem é 4kHz e o teorema de Nyquist não é cumprido. 
% O que acontece neste fenómeno é que durante a amostragem, s transformada
% do sinal é decomposta num trem de impulsos. Se houver frequências acima e
% Fs/2, quando se faz a reconstrução do sinal, existem frequências que são
% dadas pela diferença entre a frequência de amostragem e a frequência do
% sinal. Por exemplo, se a frequência for 3kHz, quando o sinal é
% reconstruido, a frequência aparente será de 1kHz.

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
%   As linhas estão onduladas uma vez que o movimento das cordas leva a que
%   o som do violino seja algo 'vibrato', ou seja, oscile em torno de uma
%   certa nota, representada no espectrograma por uma frequência. É
%   impossível através de instrumentos analógicos atingir com precisão uma
%   dada frequência sem que haja esta oscilação, por muito pequena que seja.


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
% espaçada. 
%   Pelo espectrograma e pelo audio nota-se que o sinal é mais perceptível numa gama de
%   frequências mais baixa, portanto conclui-se que o downsampling tem
%   implicações na frequência do sinal analógico convertido. Sabe-se que
%   este sinal é amostrado a 8820 samples/segundo. Analisando o
%   espectrograma nota-se que a partir de certas frequências, o teorema da
%   amostragem não é cumprido, ocorrendo aliasing, pelo que as frequências
%   mais altas são espelhadas para uma zona de frequências mais baixa.
%%

% Quest 6

% filtragem do sinal x da alínea 4
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
% Relativamente à audição do sinal, nota-se que este é muito mais
% perceptível, situando-se na mesma gama de frequências do sinal da alínea
% 5. Isto deve-se ao facto de não ocorrer aliasing. Já o espectrograma
% apresenta também pelo mesmo facto menos valores diferentes de frequências
% em cada instante temporal.
% O filtro passa-baixo funciona então como um filtro de anti-aliasing, que
% permite que se cumpra o teorema da amostragem e portanto não haja
% espelhamento das frequências mais altas na gama inferior de frequências
% do espectro. (explicado na 3.b)
% Comparando com a questão 4, o som não tem todas as frequências, uma vez
% que foi colocado o filtro passa-baixo, no entanto, o espectro nas
% frequências que se mantém é semelhante, o que não acontece na questão 5.
