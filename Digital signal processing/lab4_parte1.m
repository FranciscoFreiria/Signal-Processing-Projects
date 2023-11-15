%% Lab 4 PDS - Prediction

% Parte I

% Grupo xx, turno Lxx
% Spike n� xxxxx
% Colega do Spike n� xxxxx

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
        % admitindo que o previsto � igual ao x_train, de qualquer modo, os
        % dados antes de N+1 n�o s�o relevantes
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
legend('x treino', 'x previsto', 'res�duo (r)');
xlim([N+1 p])
title('Gr�fico dos dados, previs�o e res�duo - long term model')


% A figura representa a evolu��o dos dados obtidos a partir do sistema
% real, previsto e cont�m tamb�m o res�duo que resulta da diferen�a entre
% os valores instant�neos dos dados de treino e os dados previstos.
% Tal como � dito no enunciado, o sistema em estudo � constitu�do por um
% painel solar instalado numa casa e pretende-se avaliar a varia��o de
% energia recebida nessa mesma casa. A partir dessa informa��o consegue-se
% entender que os tro�os em que a energia � aproximadamente zero, ocorrem
% durante as horas noturnas. Por outro lado, o valor � m�ximo quando o
% sol est� no ponto mais alto do c�u, que ocorre por volta do meio-dia.
% As subidas e as descidas dessa sinusoide representam as horas da manh�
% e da tarde respetivamente.
% O sistema real no entanto pode conter alguns fatores que os dados
% previstos n�o incluem. C�u nublado ou qualquer outro bloqueio de
% luminosidade no sensor pode provocar uma altera��o de dados.
% Analisando ent�o os dados previstos e os valores do res�duo, pode-se
% concluir que estes dados previstos nem sempre s�o semelhantes aos dados
% retirados do sistema real. Os valores dos res�duos tamb�m demonstram
% desvios significativos para alguns dos dias, pelo que este modelo n�o � o
% mais indicado.

% Quest 1.c)

% C�lculo da energia e coeficiente do res�duo 

En = 0;
for n = (N+1):p
    En = En + r(n)^2;   
end

disp(En)
% En = 0.3478, para a = 0.9810

% Observam-se os valores de energia e coeficiente a apresentados acima. O
% coeficiente � pr�ximo de 1, ent�o o valor do res�duo num instante � aproximadamente
% igual � diferen�a entre o sinal nesse instante e o valor desse sinal N
% instantes atr�s.
% Uma vez que se verificou que esta rela��o n�o � o melhor modelo para
% tratar os dados, o res�duo pode tomar valores fora do esperado, o que
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
title('Gr�fico dos dados, previs�o e res�duo - short term model')

% Observa-se que o sinal previsto continua a ser semelhante aos dados de treino, em forma
% e amplitude. O res�duo que se verifica � tanto positivo como negativo e
% n�o excede os 0.08. Embora os dados previstos nem sempre sejam semelhantes aos dados
% retirados do sistema real, est�o mais perto destes, em compara��o com o
% modelo de long time, o que se observa pela redu��o significativa do
% res�duo, n�o s� em termos de valor m�ximo absoluto, como ao longo de todo
% o sinal.
% Embora ainda existam esporadicamente res�duos elevados, na ordem dos 40%
% do valor do sinal, estes s�o menos frequentes e com menor amplitude que
% no modelo usado anteriormente, e portanto conclui-se que o modelo short
% term � mais adequado.

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
% O res�duo e(n) � dado pela rela��o r(n) - sum(ak*r(n-k)). Neste caso, o
% valor do res�duo em cada instante depende apenas dos valores dos k
% instantes anteriores (neste caso, k = 1:6). 
% Desta forma o resultado est� menos sens�vel a perturba��es da recolha de dados do painel, 
% confirmando assim que este modelo � mais adequado ao tratamento destes dados,
% o que � suportado pela diminui��o da energia do res�duo para 0.1248.

