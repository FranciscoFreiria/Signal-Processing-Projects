%% Lab 5 PDS - Image Segmentation

% Parte II

% Grupo xx, turno Lxx
% Spike nº xxxxx
% Colega do Spike nº xxxxx

%%

clear
% Quest 1 b)

load('sar_image.mat')
figure
im = imagesc(I);
title('Synthetic Aperture Radar (SAR)')
imwrite(I,'water_and_ice.tif')
colormap default

% quest 1 c)
[I_ice,rect_ice]  = imcrop(im);
figure, imagesc(I_ice)

[I_water, rect_water] = imcrop(im);
figure, imagesc(I_water)

% estimation of the parameters
% exponential dist - mean

A = mean(I_ice);
mean_ice = mean(A);

B = mean(I_water);
mean_water = mean(B);

% Rayleigh dist
b_ice = mean(mean(I_ice.^2))/2;
b_water = mean(mean(I_water.^2))/2;

% Normal dist

% a media é igual ao caso da exponencial
% para a estimativa da variancia

var_ice = mean(mean((I_ice-mean_ice).^2));
var_water = mean(mean((I_water-mean_water).^2));


% parametros obtidos:
% Exponencial: miu - ice: 295.599   water: 47.4888
% Rayleigh: b - ice:  4.8474 * 10^4   water: 1.2201*10^3
% Normal: miu: same as before, sigma^2 - ice: 9.5687 *10^3 water: 185.0223
%%
% quest 1 d)
% distribution estimation

% ice
figure();
subplot(4,1,1);
hist1 = histogram(I_ice, 'Normalization', 'probability');
title('Histograma da região de gelo')
grid on

% exponential
subplot(4,1,2);
pd = makedist('Exponential',mean_ice);
I_ice_est = pdf(pd,I_ice(:));
plot(I_ice(:), I_ice_est,'r.')
title('Distribuição exponencial')
grid on;

% Rayleigh
subplot(4,1,3);
pd = makedist('Rayleigh',b_ice);
I_ice_est = pdf(pd,I_ice(:));
plot(I_ice(:), I_ice_est,'r.')
title('Distribuição de Rayleigh')
grid on;


% Normal
subplot(4,1,4);
pd = makedist('Normal',mean_ice,sqrt(var_ice));
I_ice_est = pdf(pd,I_ice(:));
plot(I_ice(:), I_ice_est,'r.')
title('Distribuição Normal')
grid on;

%%
% water
figure()
subplot(4,1,1)
histogram(I_water, 'Normalization', 'probability');
title('Histograma da região de água')
grid on;

% exponential
subplot(4,1,2);
pd = makedist('Exponential',mean_water);
I_water_est = pdf(pd,I_water(:));
plot(I_water(:), I_water_est,'b.')
title('Distribuição exponencial')
grid on;

% Rayleigh
subplot(4,1,3);
pd = makedist('Rayleigh',b_water);
I_water_est = pdf(pd,I_water(:));
plot(I_water(:), I_water_est,'b.')
title('Distribuição de Rayleigh')
grid on;

% Normal
subplot(4,1,4);
pd = makedist('Normal',mean_water,sqrt(var_water));
I_water_est = pdf(pd,I_water(:));
plot(I_water(:), I_water_est,'b.')
title('Distribuição Normal')
grid on;

% A distribuição aleatória que mais se assemelha à distribuição da
% intensidade dos pixels é a normal. Isto pode ser comprovado pela forma da
% distribuição, bem como os valores de média e variância. Em qualquer uma
% das outras duas distribuições, a forma difere muito o que representa um
% fator eliminatório visto que a distribuição todos os 3 requisitos
% especificados anteriormente.


%%
% quest 2a)

I_2a_water = zeros(2917,1847);
I_2a_ice = zeros(2917,1847);

% para a distribuição Normal
for i = 1:2917
    for j = 1:1847
        
        p_ice = 1/sqrt(2*pi*var_ice)*exp(-((I(i,j) - mean_ice).^2)/(2*var_ice));
        p_water = 1/sqrt(2*pi*var_water)*exp(-((I(i,j) - mean_water).^2)/(2*var_water));
        
        if p_water > p_ice
            I_2a(i, j) = 0;
        else
            % means ice
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
% quest 2 b)

I_2b = zeros(2917,1847);
matrix_9x9 = zeros(9,9);


for i = 5:2912
    for j = 5:1842
             
        matrix_9x9 = I((i-4):(i+4),(j-4):(j+4));
        
        log_like_assign;
        if p_water_cum < p_ice_cum
            % means ice
            I_2b(i, j) = I(i,j);
        else
            % means water
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
% quest 2c) 

I_2c = zeros(2917,1847);

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

%%
% 2 d)

% success rate = equal values/nr of pixels in the image * 100
success_a = 0;
success_b = 0;
success_c = 0;

% para o gelo
I_2a = imcrop(I_2a, rect_ice);
I_2b = imcrop(I_2b, rect_ice);
I_2c = imcrop(I_2c, rect_ice);

[mg, ng] = size(I_2a);

for i = 1:mg
    for j = 1:ng
        if I_ice(i, j) == I_2a(i,j)
            success_a = success_a +1;
        end
        if I_ice(i, j) == I_2b(i,j)
            success_b = success_b +1;
        end
        if I_ice(i, j) == I_2c(i,j)
            success_c = success_c +1;
        end
         
    end
end


% para a água
I_2a = imcrop(I_2a, rect_water);
I_2b = imcrop(I_2b, rect_water);
I_2c = imcrop(I_2c, rect_water);

[ma, na] = size(I_2a);

for i = 1:ma
    for j = 1:na
        if I_water(i, j) == I_2a(i,j)
            success_a = success_a +1;
        end
        if I_water(i, j) == I_2b(i,j)
            success_b = success_b +1;
        end
        if I_water(i, j) == I_2c(i,j)
            success_c = success_c +1;
        end
         
    end
end



success_rate_a = success_a/(ma*na + mg*ng)*100
success_rate_b = success_b/(ma*na + mg*ng)*100
success_rate_c = success_c/(ma*na + mg*ng)*100


