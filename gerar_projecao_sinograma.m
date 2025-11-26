clear all;   % limpa variáveis do workspace
clc;         % limpa o console
close all;   % fecha todas as figuras abertas

%------------ Configurar valores ------------

dens_quadrado = 1;   % densidade do quadrado
dens_circulo  = 3;   % densidade do círculo

theta = 30; % Definir ângulo de incidência

img = zeros(200,200); % Inicializa uma imagem preta de 200x200

% Faz máscara quadrada na figura
rect = poly2mask([40 140 140 40], [40 40 140 140], 200, 200); 
img = img + dens_quadrado * rect;

% Configurando círculo

% Definir raio
r = 35;
posx = 130;
posy = 50;

% Circulo
[x,y] = meshgrid(1:200,1:200);
circle = ((x-posx).^2 + (y-posy).^2) < r^2;
img = img + dens_circulo * circle;


% Transformada de radon para um único ângulo
[p, s] = radon(img, theta);

% Transformada de radon para vários ângulos (sinograma)
theta_vec = 0:179; % ângulos varidos
[R, xp] = radon(img, theta_vec);  % R é matriz


%% Plot das figuras (1x4)
fig = figure('Name','Projeções e Sinograma','NumberTitle','off', ...
             'Units','pixels','Position',[200 200 1100 300]);

t = tiledlayout(fig,1,4,'TileSpacing','compact','Padding','compact');

% eixo 1: imagem original
ax1 = nexttile;
imshow(img,[],'InitialMagnification','fit','Parent',ax1);
title(ax1,'Imagem Original');
axis(ax1,'image');

% eixo 2: imagem rotacionada
img_rot = imrotate(img, -theta, 'crop');
ax2 = nexttile;
imshow(img_rot,[],'InitialMagnification','fit','Parent',ax2);
title(ax2,'Imagem rotacionada (alinhada ao feixe)');
axis(ax2,'image');

% eixo 3: projeção Radon
ax3 = nexttile;
plot(ax3, s, p, 'LineWidth',2);
xlabel(ax3,'s'); ylabel(ax3,'p(s,\theta)');
title(ax3,'Projeção Radon');
grid(ax3,'on');

% eixo 4: Sinograma
ax4 = nexttile;
% imagesc com XData = theta_vec e YData = xp
imagesc(theta_vec, xp, R, 'Parent', ax4);
axis(ax4,'xy');                  % xp cresce para cima
xlabel(ax4,'\theta (degrees)');
ylabel(ax4,'x'' (pixels from center)');
title(ax4,'Sinograma (R_{\theta}(x''))');
colormap(ax4, gray);
colorbar('peer', ax4);

drawnow;