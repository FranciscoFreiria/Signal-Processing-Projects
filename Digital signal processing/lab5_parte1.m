%% Lab 5 PDS - Maximum Likelihood Estimators

% Parte I

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

%%

clear
% Quest 1

load('sar_image.mat')
figure
im = imagesc(I);
title('Synthetic Aperture Radar (SAR)')
imwrite(I,'water_and_ice.tif');
colormap default

%%
% quest 1 c)

I_ice = imcrop(im);
figure, imagesc(I_ice)

I_water = imcrop(im);
figure, imagesc(I_water)

% estimation of the parameters
% exponential dist - mean

A = mean(I_ice);
mean_ice = mean(A);

A = mean(I_water);
mean_water = mean(A);

% Rayleigh dist
b_ice = mean(mean(I_ice.^2))/2;
b_water = mean(mean(I_water.^2))/2;

% Normal dist

% a media é igual ao caso da exponencial
% para a estimativa da variancia

var_ice = mean(mean((I_ice-mean_ice).^2));
var_water = mean(mean((I_water-mean_water).^2));

% opçao 2 - Loureiro
[m,n] = size(I_ice);

for i=1:m
    for j=1:n
        a(i,j) = (I_ice(i,j)-mean_ice)^2;
    end
end
sigma_s_est_ice = sum(sum(a))/numel(I_ice)

% A distribuição aleatória que mais se assemelha à distribuição da
% intensidade dos pixels é a normal. Isto pode ser comprovado pela forma da
% distribuição, bem como os valores de média e variância. Em qualquer uma
% das outras duas distribuições, a forma difere muito o que representa um
% fator eliminatório visto que a distribuição todos os 3 requisitos
% especificados anteriormente.

%%
% quest 1 d)
% distribution estimation

% ice
% figure();
% histogram(I_ice, 'Normalization', 'probability');
% grid on;


%%

% quest 2a)

I_2a = zeros(2917,1847);


for i = 1:2917
    for j = 1:1847
        
        p_ice = ((I(i,j)/b_ice)*exp((-I(i,j)).^2)/(2*b_ice));
        p_water = ((I(i,j)/b_water)*exp((-I(i,j)).^2)/(2*b_water));
        
        if p_water < p_ice
            I_2a(i, j) = 0;
        else
            I_2a(i, j) = I(i,j);
        end
    end
end

figure();
imagesc(I);
hold on;
imcontour(I_2a, 'y');
title('Imagens sobrepostas com segmentação de pixels (2a)');

%%

I_2b = zeros(2917,1847);
matrix_9x9 = zeros(1,81);

for i = 5:2912
    for j = 5:1842
        p = 1;
        % m é o índice das linhas da matriz 9x9
        for m = i-4:i+4
            % n é o índice das colunas da matriz 9x9
            for n = j-4:j+4
                
                matrix_9x9(p) = I_2b(m, n);
                p = p+1;
            end
        end
        
        if sum(matrix_9x9) < 100
            I_2b(i, j) = I(i,j);
        else
            I_2b(i, j) = 0;
        end
    end
end

figure();
imagesc(I);
hold on;
imcontour(I_2b, 'r');
title('Imagens sobrepostas com segmentação de pixels (2b)');

%%
% 2c) 

% fiz com a normal porque o threshold da rayleigh era bué estupido aqui

I_2c = zeros(2917,1847);
%expected_value_ice = b_ice*sqrt(pi/2);
%expected_value_water = b_water*sqrt(pi/2);
%I_mean = mean(mean(I));

%threshold = (expected_value_ice + expected_value_water)/2;
threshold = (mean_water + mean_ice)/2;


for i = 1:2917
    for j = 1:1847
        if I(i, j) > threshold
            I_2c(i, j) = I(i,j);
        else
            I_2c(i, j) = 0;
        end
    end
end

figure();
imagesc(I);
hold on;
imcontour(I_2c, 'g');
title('Imagens sobrepostas com segmentação de pixels (2c)');