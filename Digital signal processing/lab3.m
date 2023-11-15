%% Lab 3 PDS - Filtering

% Grupo xx, turno Lxx
% Spike n� xxxxx
% Colega do Spike n� xxxxx

%% Quest 1) Analyzing the audio signal

%% Quest 1a)

[x, Fs] = audioread('fugee.wav');
soundsc(x,Fs);

% Ao reproduzir o sinal de �udio, escutam-se alguns 'cliques' que s�o
% caracter�sticos nos vinyls mais antigos. Este ru�do indesejado ocorre uma
% vez que existem algumas amostras para os quais a amplitude do
% sinal nesse momento � muito mais elevada do que seria suposto.

%% Quest 1b)

% Segmento 1
figure
plot(x(1:250000))
title('Segment of the signal')
xlabel('Samples')
ylabel('Amplitude')

% Segmento 2
figure
plot(x(250000:500000))
title('Segment of the signal')
xlabel('Samples')
ylabel('Amplitude')

% Segmento 3
figure
plot(x(500000:750000))
title('Segment of the signal')
xlabel('Samples')
ylabel('Amplitude')

% Segmento 4
figure
plot(x(750000:1000000))
title('Segment of the signal')
xlabel('Samples')
ylabel('Amplitude')

% Segmentos 1-4
figure
plot(x(1:1000000))
title('Previous 4 segments merged together')
xlabel('Samples')
ylabel('Amplitude')

% Com esta representa��o gr�fica do sinal, pode-se visualizar que de facto
% existem algumas amostras para as quais a amplitude do sinal � muito
% superior aos valores de intensidade dos instrumentos/parte vocal da
% m�sica, confirmando assim o que foi referido nos coment�rios da quest�o
% anterior. Analisando os segmentos um a um, notam-se os 'clicks' no 
% in�cio do sinal s�o mais relevantes (apesar de em teoria existir em todo
% o sinal, visto que o  processo de ru�do � aleat�rio ao longo de todas as
% amostras). Esta relev�ncia � explicada devido ao facto da m�sica iniciar
% com intensidade baixa, sem instrumenos, apenas voz. No meio da m�sica n�o
% � t�o not�rio visto que tamb�m existem outros instrumentos, voz e uma
% maior gama de frequ�ncias, apesar de o fen�meno continuar a existir.

%% Quest 1c)

% Sampling frequency
Fs = 8000; 
% Sampling period
T = 1/Fs;         

% Espetro de Magnitude

N = 8192;

xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   
f = ((-N/2):1:(N/2)-1);

figure
semilogy(f,P2)
xlim([0 5000]); 
title('Single-Sided Amplitude Spectrum of X(n)')
xlabel('f (Hz)')
ylabel('|X(f)|')

% Atrav�s da an�lise do gr�fico do espectro de magnitude do sinal, pode-se
% verificar que nas frequ�ncias mais baixas verifica-se a amplitude da
% combina��o entre instrumentos e voz � um pouco mais elevada do que nas
% frequ�ncias mais altas do sinal de �udio.


%% Quest 2 - Filtering with an LTI filter


%% Quest 2a)

[b,a] = butter(10,0.5);

[h,w] = freqz(b,a);

freqz(b,a)

% Observa-se que os -3dB se situam em 0.5 pi rad/sample, ou seja, a
% partir desse valor come�a-se a ver atenua��o na magnitude do sinal.
% J� relativamente ao espectro de fase nota-se que este varia entre 0 e
% -1000 graus, estando no valor interm�dio (-5000 graus) no valor da
% frequ�ncia de corte do filtro. 

%% Quest 2b)

[x, Fs] = audioread('fugee.wav');
%soundsc(x,Fs)

y = filter(b,a,x);

% sampling freq. = 8000 Hz

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = pi/2*8000/(2*pi) = 2000 Hz.

%% Quest 2c)

figure
plot(x(1:1000000))
hold on
plot(y(1:1000000))
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');

% Ru�do numa zona onde a amplitude do sinal � muito baixa
figure 
plot(x(2389000: 2392700))
hold on
plot(y(2389000: 2392700))
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');


% Observa-se que com a aplica��o do filtro h� uma redu��o do ruido. Ou
% seja, em zonas de sinal com baixa amplitude, o ruido � muito mais baixo.
% Isto � observ�vel uma vez que as amplitudes aleat�rias e de elevada
% magnitude (muito maior que o sinal) que caracterizam o ruido s�o
% atenuadas com a aplica��o do filtro. A amplitude do restante sinal
% (o que n�o � ru�do) mant�m-se semelhante.

%% Quest 2d)

% Espectro de magnitude

N = 8192;

xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   

yfft1 = fft(y,N);
yfft = fftshift(yfft1);
P3 = 2*abs(yfft);   
f = ((-N/2):1:(N/2)-1);

figure
semilogy(f,P2);
hold on

semilogy(f,P3);
xlim([0 4000]); 
title('Single-Sided Amplitude Spectrum of X(n) and Y(n)')
xlabel('f (Hz)')
ylabel('|X(f)|/ |Y(f)|')
grid on

% Atrav�s do espectro de magnitude observa-se que para frequ�ncias baixas o
% sinal fica inalterado. Para frequ�ncias acima da frequ�ncia de corte
% (2000 Hz) o sinal � atenuado. 

%% Quest 2e)

Fs2 = 2000;
soundsc(y, Fs2);

% O que � ouvido comprova os resultados anteriores.
% Apenas se ouvem sons mais graves, devido ao efeito do filtro passa-baixo
% de Butterworth - as componentes de alta frequ�ncia do sinal s�o
% atenuadas.
% Nota-se que em rela��o ao ruido, este melhora um pouco. Os cliques n�o
% ocorrem tantas vezes. Os cliques que se situam nas altas frequ�ncias s�o
% atenuados e portanto s� permanece o ruido de baixa frequ�ncia. Contudo,
% a m�sica n�o � percept�vel e embora o ru�do diminua, a solu��o tenta
% "usar uma ca�adeira para matar uma mosca".

%% Quest 2f) - Repetir o processo (a-e)

% com  frequencia de cut-off do filtro de butterworth = 3*pi/4
[b,a] = butter(10,0.75);

y1 = filter(b,a,x);

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = 3pi/4*8000/(2*pi) = 3000 Hz.

figure
subplot(3,1,1);
plot(x(1:1000000))
hold on
plot(y1(1:1000000))
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');
title('filtragem com freq de corte = 3000 Hz');


% Com  frequencia de cut-off do filtro de butterworth = pi/4
[b,a] = butter(10,0.25);

y2 = filter(b,a,x);

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = pi/4*8000/(2*pi) = 1000 Hz.

subplot(3,1,2);
plot(x(1:1000000))
hold on
plot(y2(1:1000000))
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');
title('filtragem com freq de corte = 1000 Hz');

% Com  frequencia de cut-off do filtro de butterworth = pi/8
[b,a] = butter(10,0.125);

y3 = filter(b,a,x);

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = pi/8*8000/(2*pi) = 500 Hz.

subplot(3,1,3);
plot(x(1:1000000))
hold on
plot(y3(1:1000000))
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');
title('filtragem com freq de corte = 500 Hz');

% Espectro de magnitude

N = 8192;

% Com  frequencia de cut-off do filtro de butterworth = 3*pi/4
[b,a] = butter(10,0.75);

y1 = filter(b,a,x);

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = 3pi/4*8000/(2*pi) = 3000 Hz.

xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   

yfft1 = fft(y1,N);
yfft = fftshift(yfft1);
P3 = 2*abs(yfft);   
f = ((-N/2):1:(N/2)-1);

figure;
subplot(3,1,1);
semilogy(f,P2);
hold on

semilogy(f,P3);
xlim([0 4000]); 
title('Single-Sided Amplitude Spectrum of X(n) and Y(n)(freq de corte = 3000Hz)')
xlabel('f (Hz)')
ylabel('|X(f)|/ |Y(f)|')
grid on

% Espectro de magnitude

N = 8192;
% Com  frequencia de cut-off do filtro de butterworth = pi/4
[b,a] = butter(10,0.25);

y2 = filter(b,a,x);

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = pi/4*8000/(2*pi) = 1000 Hz.

xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   

yfft1 = fft(y2,N);
yfft = fftshift(yfft1);
P3 = 2*abs(yfft);   
f = ((-N/2):1:(N/2)-1);


subplot(3,1,2);
semilogy(f,P2);
hold on

semilogy(f,P3);
xlim([0 4000]); 
title('Single-Sided Amplitude Spectrum of X(n) and Y(n) (freq de corte = 1000 Hz)')
xlabel('f (Hz)')
ylabel('|X(f)|/ |Y(f)|')
grid on

% Espectro de magnitude

N = 8192;
% Com  frequencia de cut-off do filtro de butterworth = pi/8
[b,a] = butter(10,0.125);

y3 = filter(b,a,x);

% Nova freq. cut off da filtragem do sinal de tempo continuo:
% = pi/8*8000/(2*pi) = 500 Hz.

xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   

yfft1 = fft(y3,N);
yfft = fftshift(yfft1);
P3 = 2*abs(yfft);   
f = ((-N/2):1:(N/2)-1);


subplot(3,1,3);
semilogy(f,P2);
hold on

semilogy(f,P3);
xlim([0 4000]); 
title('Single-Sided Amplitude Spectrum of X(n) and Y(n) (freq de corte = 500 Hz)')
xlabel('f (Hz)')
ylabel('|X(f)|/ |Y(f)|')
grid on


% Audi��o dos sinais
Fs1 = 3000;
Fs2 = 1000;
Fs3 = 500;

% soundsc(y1, Fs1);
% soundsc(y2, Fs2);
% soundsc(y3, Fs3);


% Observa-se que com a redu��o da frequ�ncia de corte, h� melhorias em
% rela��o ao ru�do, mas perde-se a percep��o do sinal em s�. 
% Aumentando a frequ�ncia de corte, aumenta o ru�do, mas o sinal torna-se
% mais percept�vel. 
% Isto � vis�vel tanto nas figuras do sinal e espectro de magnitude do
% sinal como na audi��o do sinal filtrado.
% Conclui-se que com um filtro passa-baixo nunca se consegue eliminar
% completamente o ruido, uma vez que este persiste nas zonas de baixa
% frequ�ncia. Uma maneira de eliminar o m�ximo de ruido poss�vel � reduzir
% a largura de banda do filtro, mas isto tem consequ�ncias na qualidade do
% som.

 
%% Quest 3 - Filtering with Median Filter

%% Quest 3a) Propriedades do filtro

% tomando como exemplo o sinal f[n] = [1 -2 2 3 1] e g[n] = [4 5 7 1 2] e
% M = 1.

% Causalidade: Para o fitro ser um sistema causal, significa que n�o pode
% depender de instantes futuros, o que acontece neste caso, uma vez que
% para valores positivos de M, o princ�pio da causalidade n�o � respeitado.
% Por exemplo, no caso de f, se n = 3, a mediana depende de n+1, pelo que
% n�o � causal.

% Linearidade: Para o filtro ser um sistema linear, y(n) = y1(n) + y2(n) =
% med(x1+x2), o que n�o ocorre neste caso. Por exemplo:
% tomando n = 3 - f(n) = med(f(n-1),f(n),f(n+1))= 2.
% g(n) = med(g(n-1),g(n),g(n+1)) = 5.
% med(g(n)) + med(f(n)) = 7.
% p = f + g = [5 3 9 4 3]
% med(p(n-1),p(n),p(n+1))= 4 ~= 7. Logo o filtro n�o � linear.


% Invari�ncia no Tempo: O filtro � um sistema invariante no tempo uma vez
% que y(n) depende exclusivamente de x(n) e n�o do instante temporal em que
% � aplicada.

% Exemplo:
% Para o input f[n], o output ser� F[n] = [1 1 2 2 1]. 
% Para uma vers�o deslocada de f[n]: f2[n] = f[n-2] = [0 0 1 -2 2 3 1], o
% output � F2[n] = [0 0 1 1 2 2 1], o que � o mesmo que F[n-2], logo o
% filtro � invariante no tempo.

% Estabilidade: O fltro � um sistema est�vel uma vez que se o input for
% limitado, o output tamb�m ser�, nessas circunst�ncias haver� um n�mero
% infinito de elementos para fazer a opera��o da mediana. O output da
% filtragem para um certo n, corresponde a um elemento da amostra.

%% Quest 3b) - filtragem com um filtro de 3� ordem

[x, Fs] = audioread('fugee.wav');

n = 3;
y = medfilt1(x,n);

figure
plot(x)
hold on
plot(y)
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');

% As altas amplitudes que eram representadas pelos 'clicks' foram agora
% filtradas pelo median filter. Foi criada uma 'janela admiss�vel' onde se
% situam todas as amplitudes que cont�m as samples da m�sica.

%% Quest 3c) Graphs of magnitude spectra 

N = 8192;

xfft1 = fft(x,N);
xfft = fftshift(xfft1);
P2 = 2*abs(xfft);   

yfft1 = fft(y,N);
yfft = fftshift(yfft1);
P3 = 2*abs(yfft);   
f = ((-N/2):1:(N/2)-1);

figure
semilogy(f,P2);
hold on

semilogy(f,P3);
xlim([0 4000]); 
title('Single-Sided Amplitude Spectrum of X(n) and Y(n)')
xlabel('f (Hz)')
ylabel('|X(f)|/ |Y(f)|')
grid on


% O filtro processa de acordo com as amplitudes vizinhas, os 'clicks' t�m
% alta intensidade por isso s�o reorganizados e posteriormente eliminados o
% que permite eliminar os efeitos indesejados sem prejudicar as altas
% frequ�ncias da m�sica em si.

%% Quest 3d) 

% Verifica-se que o som tem uma qualidade muito superior ao original, de um
% modo geral j� era esperado visto que o filtro consegue aplicar o processo
% descrito em 3c)

%% Quest 3e)

[x, Fs] = audioread('fugee.wav');

for n=1:8
    
y = medfilt1(x,n);

figure
plot(x)
hold on
plot(y)
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');

end

% Ao filtrar a m�sica por median filters de ordens entre 1 a 8,
% verifica-se que se o n for um valor demasiado baixo (n=1 ou n=2), existem
% ainda alguns 'cliques' que n�o s�o eliminados, como tal o sinal ainda n�o
% � de boa qualidade. No entanto, ao aumentar em demasia a ordem do filtro,
% existem frequ�ncias da m�sica que s�o filtradas sem que fosse esse o
% objetivo. Isto ocorre porque ao restringir a janela de atua��o do filtro,
% este vai acabar por fazer um processo de sele��o de forma exagerada,
% utilizando a mediana de um intervalo maior, filtrando assim  samples 
% importantes da m�sica em si, tornando o sinal com menor qualidade. Este
% processo de filtragem inadequado � observado para valores de n iguais ou
% superior a 5.
% Como tal, conclui-se que as ordens adequadas de filtragem para este sinal
% em espec�fico s�o n=3 ou n=4.

%% Quest 3f)

% Ap�s o estudo adequado e a an�lise aprofundada de filtragem do sinal com
% LTI e median filter, conclui-se que o median filter � o mais adequado
% para remover ru�do do sinal. O processo de filtragem atrav�s dos valores
% de mediana � o ideal para remover ru�do uma vez que estabelece uma
% compara��o direta entre o valor de amplitude de frequ�ncias
% adjacentes e elimina a que tiver um valor muito superior. � um processo
% mais rigoroso do que o filtro LTI uma vez que percorre todas as samples e
% aplica este algoritmo.
% J� no processo de filtragem do LTI, a partir da frequ�ncia de corte,
% todas as frequ�ncias s�o eliminadas inclusivamente algumas que n�o s�o
% ru�do, mas sim notas mais altas da m�sica em si, o que n�o � um efeito
% desejado para a qualidade do sinal.


