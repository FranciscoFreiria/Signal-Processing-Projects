%% Lab 4 PDS - Anomaly Detection

% Parte II

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

%%

% Quest 2.a) e b)
load('energy_test.mat');

N = 96;
p = length(x_test);
x = x_test;

% primeiro método - long term model
% para valores de n<N+1 
for n = 1:N
    h(n) = 0;
end
% para valores de n entre N+1 e p
for n = N+1:p
    h(n) = x(n-N);
end
H = h';
a = H'*x*(H'*H)^-1;
% x previsto
for n = 1:p
    if n<N+1
        xp(n) = x(n);
    else
        xp(n) = a*x(n-N);
    end
    r(n) = x(n)-xp(n);
end

for n = 1:p
    anom_(n) = abs(x_test(n) - xp(n));
end

% armazenar o nr de anomalias
i = 1;
for n = 1:p
    if anom_(n) > 0.14
        anom_index(i) = n;
            if i>1 && anom_index(i)< anom_index(i-1)+10 || i>2 && anom_index(i)< anom_index(i-2)+10|| i>3 && anom_index(i)< anom_index(i-3)+10
                anom_index(i) = 0;
            end
            i= i+1;
    end
end

% retirar as falsas anomalias
k = 1;
for i= 1:length(anom_index)
   if anom_index(i)~=0
       anom_id(k) = anom_index(i);
       k = k+1;
   end
end

figure
plot(x_test)
hold on
plot(xp)
legend('x test','x previsto')
title('Visualização dos dados de teste e das previsões - long term model')
xlabel('n')

figure
plot(anom_)
legend('anomalias')
hold on
reta = zeros(1,p) + 0.14;
plot(1:p,reta)
title('Valor absoluto da diferença entre os dados de teste e as previsões - long term')
xlabel('n')

%%
% Segundo método - short term model

P = 6;

for j = 1:p
    for i=1:P
       if (j-i)<=0
           H(j,i) = 0;
       else
           H(j,i) = r(j-i);
       end
   end
end

a = ((H'*H)^-1)*H'*r';

% predicted residual
for n = 1:p
    rp(n) = 0;
    for k = 1:P
        if(n>k)
            rp(n) = rp(n) + a(k)*r(n-k);
        else
            rp(n) = rp(n);
        end
    end
end

% obtain the new prediction for x(n)

xp2 = x - rp';

for n = 1:p
    anom_2(n) = abs(x_test(n) - xp2(n));
end


% armazenar o nr de anomalias
i = 1;
for n = 1:p
    if anom_2(n) > 0.14
        anom_index2(i) = n;
            if i>1 && anom_index2(i)< anom_index2(i-1)+10 || i>2 && anom_index2(i)< anom_index2(i-2)+10|| i>3 && anom_index2(i)< anom_index2(i-3)+10
                anom_index2(i) = 0;
            end
            i= i+1;
    end
end

% retirar as falsas anomalias
k = 1;
for i= 1:length(anom_index2)
   if anom_index2(i)~=0
       anom_id2(k) = anom_index2(i);
       k = k+1;
   end
end


figure
plot(x_test)
hold on
plot(xp2)
legend('x_test','x previsto')
title('Visualização dos dados de teste e das previsões - short term model')
xlabel('n')

figure
plot(anom_2)
legend('anomalias')
title('Valor absoluto da diferença entre os dados de teste e as previsões - short term')
xlabel('n')

% Considerou-se uma anomalia como um valor de energia previsto que seja
% muito diferente do valor real, e para isso foi feita a diferença entre
% estes dois dados, em valor absoluto. Se esta diferença estiver situada
% acima de um valor definido, por inspeção do gráfico (0.14), então existe
% uma anomalia.
% Sempre que existiam falsas anomalias em torno de uma anomalia real, ou
% seja, em torno desse valor de n, num curto espaço de tempo, essas falsas
% anomalias eram descartadas.
% Pelo primeiro modelo (long term), verificou-se a existência de 4
% anomalias, nos índices de n descritos no vetor anom_id. 
% Pelo segundo modelo (short term) verificou-se a existência de apenas uma
% anomalia, no índice descrito em anom_id2.
% Uma vez que no long term model, a predição por sí só já continha um erro
% significativo, faz sentido que neste modelo exista um maior nr de
% anomalias. Desta forma, pode-se considerar que o segundo modelo, uma vez
% que os valores previstos têm um erro menor em relação ao conjunto de
% treino, consegue detetar anomalias de um modo mais fiável. Ao reduzirmos
% a threshold para o segundo modelo consegue-se obter um número maior de
% anomalias, de uma maneira mais fiável do que o modelo long term.


% Quest 2.c)

% Podemos resolver o problema, analisando os instantes temporais onde são
% obtidas anomalias, e observando até quando é que estas são detetadas. Se
% os valores de n forem muito próximos, consideram-se falsas anomalias.
% Estas podem ser eliminadas, de modo a que a contagem de anomalias seja a
% correta. Portanto apenas é considerada a primeira anomalia que se deteta.
