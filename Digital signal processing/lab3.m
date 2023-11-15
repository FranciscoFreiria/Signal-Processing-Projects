%% Lab 3 PDS - Filtering

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

%% Quest 1) Analyzing the audio signal

%% Quest 1a)

[x, Fs] = audioread('fugee.wav');
soundsc(x,Fs);

% Ao reproduzir o sinal de áudio, escutam-se alguns 'cliques' que são
% característicos nos vinyls mais antigos. Este ruído indesejado ocorre uma
% vez que existem algumas amostras para os quais a amplitude do
% sinal nesse momento é muito mais elevada do que seria suposto.

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

% Com esta representação gráfica do sinal, pode-se visualizar que de facto
% existem algumas amostras para as quais a amplitude do sinal é muito
% superior aos valores de intensidade dos instrumentos/parte vocal da
% música, confirmando assim o que foi referido nos comentários da questão
% anterior. Analisando os segmentos um a um, notam-se os 'clicks' no 
% início do sinal são mais relevantes (apesar de em teoria existir em todo
% o sinal, visto que o  processo de ruído é aleatório ao longo de todas as
% amostras). Esta relevância é explicada devido ao facto da música iniciar
% com intensidade baixa, sem instrumenos, apenas voz. No meio da música não
% é tão notório visto que também existem outros instrumentos, voz e uma
% maior gama de frequências, apesar de o fenómeno continuar a existir.

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

% Através da análise do gráfico do espectro de magnitude do sinal, pode-se
% verificar que nas frequências mais baixas verifica-se a amplitude da
% combinação entre instrumentos e voz é um pouco mais elevada do que nas
% frequências mais altas do sinal de áudio.


%% Quest 2 - Filtering with an LTI filter


%% Quest 2a)

[b,a] = butter(10,0.5);

[h,w] = freqz(b,a);

freqz(b,a)

% Observa-se que os -3dB se situam em 0.5 pi rad/sample, ou seja, a
% partir desse valor começa-se a ver atenuação na magnitude do sinal.
% Já relativamente ao espectro de fase nota-se que este varia entre 0 e
% -1000 graus, estando no valor intermédio (-5000 graus) no valor da
% frequência de corte do filtro. 

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

% Ruído numa zona onde a amplitude do sinal é muito baixa
figure 
plot(x(2389000: 2392700))
hold on
plot(y(2389000: 2392700))
xlabel('samples');
ylabel('amplitude');
legend('sinal inicial', 'sinal filtrado');


% Observa-se que com a aplicação do filtro há uma redução do ruido. Ou
% seja, em zonas de sinal com baixa amplitude, o ruido é muito mais baixo.
% Isto é observável uma vez que as amplitudes aleatórias e de elevada
% magnitude (muito maior que o sinal) que caracterizam o ruido são
% atenuadas com a aplicação do filtro. A amplitude do restante sinal
% (o que não é ruído) mantém-se semelhante.

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

% Através do espectro de magnitude observa-se que para frequências baixas o
% sinal fica inalterado. Para frequências acima da frequência de corte
% (2000 Hz) o sinal é atenuado. 

%% Quest 2e)

Fs2 = 2000;
soundsc(y, Fs2);

% O que é ouvido comprova os resultados anteriores.
% Apenas se ouvem sons mais graves, devido ao efeito do filtro passa-baixo
% de Butterworth - as componentes de alta frequência do sinal são
% atenuadas.
% Nota-se que em relação ao ruido, este melhora um pouco. Os cliques não
% ocorrem tantas vezes. Os cliques que se situam nas altas frequências são
% atenuados e portanto só permanece o ruido de baixa frequência. Contudo,
% a música não é perceptível e embora o ruído diminua, a solução tenta
% "usar uma caçadeira para matar uma mosca".

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


% Audição dos sinais
Fs1 = 3000;
Fs2 = 1000;
Fs3 = 500;

% soundsc(y1, Fs1);
% soundsc(y2, Fs2);
% soundsc(y3, Fs3);


% Observa-se que com a redução da frequência de corte, há melhorias em
% relação ao ruído, mas perde-se a percepção do sinal em sí. 
% Aumentando a frequência de corte, aumenta o ruído, mas o sinal torna-se
% mais perceptível. 
% Isto é visível tanto nas figuras do sinal e espectro de magnitude do
% sinal como na audição do sinal filtrado.
% Conclui-se que com um filtro passa-baixo nunca se consegue eliminar
% completamente o ruido, uma vez que este persiste nas zonas de baixa
% frequência. Uma maneira de eliminar o máximo de ruido possível é reduzir
% a largura de banda do filtro, mas isto tem consequências na qualidade do
% som.

 
%% Quest 3 - Filtering with Median Filter

%% Quest 3a) Propriedades do filtro

% tomando como exemplo o sinal f[n] = [1 -2 2 3 1] e g[n] = [4 5 7 1 2] e
% M = 1.

% Causalidade: Para o fitro ser um sistema causal, significa que não pode
% depender de instantes futuros, o que acontece neste caso, uma vez que
% para valores positivos de M, o princípio da causalidade não é respeitado.
% Por exemplo, no caso de f, se n = 3, a mediana depende de n+1, pelo que
% não é causal.

% Linearidade: Para o filtro ser um sistema linear, y(n) = y1(n) + y2(n) =
% med(x1+x2), o que não ocorre neste caso. Por exemplo:
% tomando n = 3 - f(n) = med(f(n-1),f(n),f(n+1))= 2.
% g(n) = med(g(n-1),g(n),g(n+1)) = 5.
% med(g(n)) + med(f(n)) = 7.
% p = f + g = [5 3 9 4 3]
% med(p(n-1),p(n),p(n+1))= 4 ~= 7. Logo o filtro não é linear.


% Invariância no Tempo: O filtro é um sistema invariante no tempo uma vez
% que y(n) depende exclusivamente de x(n) e não do instante temporal em que
% é aplicada.

% Exemplo:
% Para o input f[n], o output será F[n] = [1 1 2 2 1]. 
% Para uma versão deslocada de f[n]: f2[n] = f[n-2] = [0 0 1 -2 2 3 1], o
% output é F2[n] = [0 0 1 1 2 2 1], o que é o mesmo que F[n-2], logo o
% filtro é invariante no tempo.

% Estabilidade: O fltro é um sistema estável uma vez que se o input for
% limitado, o output também será, nessas circunstâncias haverá um número
% infinito de elementos para fazer a operação da mediana. O output da
% filtragem para um certo n, corresponde a um elemento da amostra.

%% Quest 3b) - filtragem com um filtro de 3ª ordem

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
% filtradas pelo median filter. Foi criada uma 'janela admissível' onde se
% situam todas as amplitudes que contêm as samples da música.

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


% O filtro processa de acordo com as amplitudes vizinhas, os 'clicks' têm
% alta intensidade por isso são reorganizados e posteriormente eliminados o
% que permite eliminar os efeitos indesejados sem prejudicar as altas
% frequências da música em si.

%% Quest 3d) 

% Verifica-se que o som tem uma qualidade muito superior ao original, de um
% modo geral já era esperado visto que o filtro consegue aplicar o processo
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

% Ao filtrar a música por median filters de ordens entre 1 a 8,
% verifica-se que se o n for um valor demasiado baixo (n=1 ou n=2), existem
% ainda alguns 'cliques' que não são eliminados, como tal o sinal ainda não
% é de boa qualidade. No entanto, ao aumentar em demasia a ordem do filtro,
% existem frequências da música que são filtradas sem que fosse esse o
% objetivo. Isto ocorre porque ao restringir a janela de atuação do filtro,
% este vai acabar por fazer um processo de seleção de forma exagerada,
% utilizando a mediana de um intervalo maior, filtrando assim  samples 
% importantes da música em si, tornando o sinal com menor qualidade. Este
% processo de filtragem inadequado é observado para valores de n iguais ou
% superior a 5.
% Como tal, conclui-se que as ordens adequadas de filtragem para este sinal
% em específico são n=3 ou n=4.

%% Quest 3f)

% Após o estudo adequado e a análise aprofundada de filtragem do sinal com
% LTI e median filter, conclui-se que o median filter é o mais adequado
% para remover ruído do sinal. O processo de filtragem através dos valores
% de mediana é o ideal para remover ruído uma vez que estabelece uma
% comparação direta entre o valor de amplitude de frequências
% adjacentes e elimina a que tiver um valor muito superior. É um processo
% mais rigoroso do que o filtro LTI uma vez que percorre todas as samples e
% aplica este algoritmo.
% Já no processo de filtragem do LTI, a partir da frequência de corte,
% todas as frequências são eliminadas inclusivamente algumas que não são
% ruído, mas sim notas mais altas da música em si, o que não é um efeito
% desejado para a qualidade do sinal.


