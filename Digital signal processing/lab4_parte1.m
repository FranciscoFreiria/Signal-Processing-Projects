%% Lab 4 PDS - Prediction

% Parte I

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

%%

load ('energy_train.mat');
x = x_train;

N = 96;
p = length(x);

% Quest 1.a) e b)

% para valores de n<N+1 
for n = 1:N
    h(n) = 0;
end

% para valores de n entre N+1 e p
for n = N+1:p
    h(n) = x(n-N);
end

H = h';
a = H'*x*inv(H'*H);

% x previsto
for n = 1:p
    if n<N+1
        % admitindo que o previsto é igual ao x_train, de qualquer modo, os
        % dados antes de N+1 não são relevantes
        xp(n) = x(n);
    else
        xp(n) = a*x(n-N);
    end
    
    r(n) = x(n)-xp(n);
end

figure
plot((N+1):p,x((N+1):p))
hold on
plot((N+1):p,xp((N+1):p))
hold on
plot(97:p,r((N+1):p))
legend('x treino', 'x previsto', 'resíduo (r)');
xlim([N+1 p])
title('Gráfico dos dados, previsão e resíduo - long term model')


% A figura representa a evolução dos dados obtidos a partir do sistema
% real, previsto e contém também o resíduo que resulta da diferença entre
% os valores instantâneos dos dados de treino e os dados previstos.
% Tal como é dito no enunciado, o sistema em estudo é constituído por um
% painel solar instalado numa casa e pretende-se avaliar a variação de
% energia recebida nessa mesma casa. A partir dessa informação consegue-se
% entender que os troços em que a energia é aproximadamente zero, ocorrem
% durante as horas noturnas. Por outro lado, o valor é máximo quando o
% sol está no ponto mais alto do céu, que ocorre por volta do meio-dia.
% As subidas e as descidas dessa sinusoide representam as horas da manhã
% e da tarde respetivamente.
% O sistema real no entanto pode conter alguns fatores que os dados
% previstos não incluem. Céu nublado ou qualquer outro bloqueio de
% luminosidade no sensor pode provocar uma alteração de dados.
% Analisando então os dados previstos e os valores do resíduo, pode-se
% concluir que estes dados previstos nem sempre são semelhantes aos dados
% retirados do sistema real. Os valores dos resíduos também demonstram
% desvios significativos para alguns dos dias, pelo que este modelo não é o
% mais indicado.

% Quest 1.c)

% Cálculo da energia e coeficiente do resíduo 

En = 0;
for n = (N+1):p
    En = En + r(n)^2;   
end

disp(En)
% En = 0.3478, para a = 0.9810

% Observam-se os valores de energia e coeficiente a apresentados acima. O
% coeficiente é próximo de 1, então o valor do resíduo num instante é aproximadamente
% igual á diferença entre o sinal nesse instante e o valor desse sinal N
% instantes atrás.
% Uma vez que se verificou que esta relação não é o melhor modelo para
% tratar os dados, o resíduo pode tomar valores fora do esperado, o que
% explica o valor de energia obtido.

%%
%  Quest 1.d) e e)

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

e = (r - rp)';

figure
plot((N+1):p,x((N+1):p))
hold on
plot((N+1):p,xp2((N+1):p))
hold on
plot((N+1):p,e((N+1):p))

legend('x treino', 'x previsto', 'residuo (e)');
xlim([N+1 p])
title('Gráfico dos dados, previsão e resíduo - short term model')

% Observa-se que o sinal previsto continua a ser semelhante aos dados de treino, em forma
% e amplitude. O resíduo que se verifica é tanto positivo como negativo e
% não excede os 0.08. Embora os dados previstos nem sempre sejam semelhantes aos dados
% retirados do sistema real, estão mais perto destes, em comparação com o
% modelo de long time, o que se observa pela redução significativa do
% resíduo, não só em termos de valor máximo absoluto, como ao longo de todo
% o sinal.
% Embora ainda existam esporadicamente resíduos elevados, na ordem dos 40%
% do valor do sinal, estes são menos frequentes e com menor amplitude que
% no modelo usado anteriormente, e portanto conclui-se que o modelo short
% term é mais adequado.

% Quest 1.f)

En2 = 0;
for n = (N+1):p
    En2 = En2 + e(n)^2;   
end

disp(En2)

% En2 = 0.1248
% a1 =0.5993; a2= 0.1496; a3= -0.0031;
% a4 = 0.273; a5 = -0.155; a6 = -0.0279

% Observam-se os valores de energia e coeficientes descritos acima. 
% O resíduo e(n) é dado pela relação r(n) - sum(ak*r(n-k)). Neste caso, o
% valor do resíduo em cada instante depende apenas dos valores dos k
% instantes anteriores (neste caso, k = 1:6). 
% Desta forma o resultado está menos sensível a perturbações da recolha de dados do painel, 
% confirmando assim que este modelo é mais adequado ao tratamento destes dados,
% o que é suportado pela diminuição da energia do resíduo para 0.1248.

