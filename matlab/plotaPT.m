function plota2a(fnb,shp,force)
% plota2a(fnb, shp, force)
%
% fnb - nome base do arquivo original tig
% shp - shapefile da área em questão
% force - flag para reescritura dos arquivos 

%% Cria imagens para análise baseado no cálculo LandTrandR.

% 1 - figura com imagens 2D da área (RGB, NDVI, Taxa, Score)
% 2 - figura com séries temporáis das três categorias básicas
% 3 - figura com Radas e RedEdge
% 4 - figura para apêndice, com classificação mais detalhada e séries temporais mais detalhadas

close all

%% Define parâmetros

% Cores para figuras [R G B]
DECLI=[1 0 0]; 
GROW1=[1 1 0];  
GROW2=[0 1 0];
GROW3=[0 .7 0];
STAB1=[0 .4 0];
STAB2=[0 .3 0];

% Parâmetros
TAXALIM=0.05; % Taxa absoluta mínima (ndvi/ano) haver mudança anual
NDVIMIN=0.5;  % Limite NDVI mínimo para área vegetada
NDVILIM=0.7;  % Limite NDVI mínimo para área vegetada de manutenção
NDRELIM=0.5;  % Limite NDRE mínimo para área vegetada saudável
CPRLIM=0.18;  % CpR limite para Dendê

flat = @(x) x(:);

%% Define arquivos de saída

% Define arquivos de saida
fig1 = [fnb '_fig1_PT.png'];
fig2 = [fnb '_fig2_PT.png'];
fig3 = [fnb '_fig3_PT.png'];
fig4 = [fnb '_fig4_PT.png'];
fig5 = [fnb '_fig5_PT.png'];
fig6 = [fnb '_fig6_PT.png'];

if(nargin()<3)
  force=false;
end
if(~force)
if(exist(fig1) & exist(fig2) & exist(fig3) & exist(fig4) & exist(fig5) & exist(fig6))
  disp('Figuras já existem. Quitting')
  return
end
end

%% Carrega arquivo de dados
load([fnb '.mat']);
load([fnb '.mat'],'img','info');

disp(['Figura para ' fnb]);


%% Carrega shapefile da área
shpij = shape_xy2ij(shp, info(1).RefMatrix');


%% Define funções inline
B = @(x,n) x(:,:,evalin('base',['B',num2str(n)]),:);
%B = @(x,n) x(:,:,eval(['global B',num2str(n) ';B',num2str(n)]),:);

NDVI = @(x) (B(x,8)-B(x,4))./(B(x,8)+B(x,4));
EVI = @(x) 2.5*(B(x,8)-B(x,4))./(B(x,8)+6*B(x,4)-7.5*B(x,2)+1);
BSI = @(x) (B(x,12) + B(x,4) - B(x,8) - B(x,2))./(B(x,12)+B(x,4)+B(x,8)+B(x,2));
NDBI = @(x) (B(x,11) - B(x,8))./(B(x,11)+B(x,8));
NDWI = @(x) (B(x,3)-B(x,8))./(B(x,3)+B(x,8));
MSI = @(x) (B(x,11)./B(x,8));
MSIn = @(x) (B(x,11)-B(x,8))./((B(x,11)+B(x,8)));
NDRE = @(x) (B(x,9)-B(x,5))./(B(x,9)+B(x,5));


%% Calcula taxa
% Taxa 1 - Decrescimento
% Taxa 2 - Manutenção
% Taxa 3 - Crescimento
taxa = (segi<-TAXALIM)+2*(abs(segi)<=TAXALIM) + 3*(segi>TAXALIM);


%% Calcula Qualidade baseada no NDVI e NDRE
% Qual 0 - Sem qualidade
% Qual 1 - NDVI alto - possivel qualidade
% Qual 2 - NDVI e NDRE alto - Com qualidade
ndvi = NDVI(img(:,:,:,end));
ndre = NDRE(img(:,:,:,end));
qual = (ndvi>NDVILIM)+2*(ndre>NDRELIM);

% Como está:
% Para a validação = Crescimento (independente da qualidade)
% Nas figuras: 0 - taxa 1
%              1 - taxa 3
%              2 - qual 1
%              3 - taxa 3 + qual 1

% Sugestão mais lógica:
%
%
% Crescimento fotosintético: taxa 3
% Crescimento com qualidade: taxa 3 + qual 2
% Manutenção com qualidade taxa 2 + qual 2

%% Define as classes detalhadas

class = zeros(size(taxa));
class(taxa==3 & ndvi>NDVIMIN) = 1;  % taxa>0 & ndvi>0.5
class(taxa==3 & ndvi>NDVILIM) = 2;  % taxa>0 & ndvi>0.7 (qual==1)
class(taxa==3 & ndvi>NDVILIM & ndre>NDRELIM) = 3; % taxa>0 & qual==3
class(taxa==2 & ndvi>NDVILIM ) = 4;  % taxa==0 & ndvi>0.7 (qual==1)
class(taxa==2 & ndvi>NDVILIM & ndre>NDRELIM) = 5; % taxa==0 & qual==3


%% FIGURA 4 - Figura do resultado da classificação
figure(4);set(4,'Visible','off');
imagesc(class);
caxis([-.5 5.5]);
colormap([1 0 0; 1 1 0; 0 1 0; 0 .7 0; 0 .4 0; 0 .3 0]);
colorbar
title('Classes');
set(colorbar,'TickLabels',{'Sem Aumento','Aumento esparso','Aumento denso', 'Aumento saudável','Estável','Estável saudável'});
%
saveas(4,fig4);


%% FIGURA 5 - Séries temporais do NDVI por cada classe
% Seleção dos pontos pertencentes a cada classe
 
ndvit = reshape(squeeze(NDVI(img)),[size(img,1)*size(img,2),size(img,4)]);
ndvit2 = squeeze(NDVI(img));

figure(5); set(5,'Visible','off');
subplot(3,2,1)
sbplts(ndvit', class==0); title('Sem aumento')
subplot(3,2,2)
sbplts(ndvit', class==1); title('Aumento -');
subplot(3,2,3)
sbplts(ndvit', class==2); title('Aumento o');
subplot(3,2,4)
sbplts(ndvit', class==3); title('Aumento +');
subplot(3,2,5)
sbplts(ndvit', class==4); title('Estável o');
subplot(3,2,6)
sbplts(ndvit', class==5); title('Estável +');

saveas(5,fig5);


%% FIGURA 6 - Séries temporais para classes simplificadas
%%            Para todos os pixels do arquivo
%% Sem aumento = Classe 0
%% Aumento = Classes 1, 2 ou 3
%% Estável = Classes 4 ou 5

figure(6); set(6,'Visible','off');
subplot(1,3,1)
sbplts(ndvit', class==0); title('Sem Aumento')
subplot(1,3,2)
sbplts(ndvit', class==1 | class==2 | class==3); title('Aumento')
subplot(1,3,3)
sbplts(ndvit', class==4 | class==5); title('Estável')

saveas(6,fig6);


%% FIGURA 1 - Mosaico
%%  RGB     NDVI
%% Score  Taxa NDVI

ax=[]; sz=size(img);
figure(1); set(1,'visible','off');
ax(1)=subplot(2,2,1);
hold on
imgrgb = img(:,:,[4 3 2],end); [inn jnn]=find(imgrgb(:,:,1)<0);
for iii=1:numel(inn); imgrgb(inn(iii),jnn(iii),:)=NaN; end;
imghsv = rgb2hsv(imgrgb);
imghsv(:,:,3)=log(imghsv(:,:,3)); aa=quantile(flat(imghsv(:,:,3)),[.01 .99]); imghsv(:,:,3)=(imghsv(:,:,3)-aa(1))./(aa(2)-aa(1)); imgrgb = hsv2rgb(max(0,min(1,real(imghsv))));
image(imgrgb); title('RGB'); axis ij; axis([0 sz(2) 0 sz(1)]+.5);
plot(shpij.X, shpij.Y)
set(ax(1),'DataAspectRatio',[1 1 1]);
axs1=get(ax(1),'Position');

%figure
ax(2)=subplot(2,2,2);
hold on
imagesc(NDVI(img(:,:,:,end))); title('NDVI'); axis ij; axis([0 sz(2) 0 sz(1)]+.5);
plot(shpij.X, shpij.Y)
caxis([0.3 0.9]); colormap(ax(2),jet(12)); colorbar
set(ax(2),'DataAspectRatio',[1 1 1]);
axs2=get(ax(2),'Position');
set(ax(2),'Position',[axs2(1)*0.9 axs2(2) axs1(3) axs1(4)]);

%figure
ax(3)=subplot(2,2,3);
hold on 
score = 1*(class==1 | class==2 | class==3) + 2*(class==4 | class==5);
imagesc(score);  axis ij; axis([0 sz(2) 0 sz(1)]+.5);
plot(shpij.X, shpij.Y)
colormap(ax(3),[DECLI; GROW2; STAB1; ])
set(ax(3),'DataAspectRatio',[1 1 1]);

% Calcula fração de pontos OK dentro do polígono
[jj ii] = meshgrid(1:size(img,2),1:size(img,1));
ipt=isinpolygon(ii(:)',jj(:)',shpij.Y(:)',shpij.X(:)');
iptij=reshape(abs(ipt),[size(img,1) size(img,2)]);
N0 = numel(find(score(find(iptij))==0));
N1 = numel(find(score(find(iptij))==1));
N2 = numel(find(score(find(iptij))==2)); 
Ntot = numel(find(iptij));
F123 = (N1+N2)./Ntot*100;
title(['Score (', num2str(F123,'%02.0f') '%)'])
axs3=get(ax(3),'Position');

ax(4)=subplot(2,2,4);
hold on 
imagesc(segi);
axis ij; axis([0 sz(2) 0 sz(1)]+.5);
caxis([0 0.1]);
colorbar
colormap(ax(4),parula(10))
title('Taxa do NDVI')
set(ax(4),'DataAspectRatio',[1 1 1]);
plot(shpij.X, shpij.Y)
axs4=get(ax(4),'Position');
set(ax(4),'Position',[axs4(1)*0.9 axs4(2) axs3(3) axs3(4)]);

saveas(1,fig1);

%% FIGURA 2 - Séries temporais do NDIV por classe simplificada
%%            Apenas para os pixels dentro do polígono
%% Sem aumento = Classe 0
%% Aumento = Classes 1, 2 ou 3
%% Estável = Classes 4 ou 5



figure(2); set(2,'visible','off');
subplot(1,3,1)
sbplts(ndvit', class(:)==0 & ipt(:)~=0); title('Sem aumento')
subplot(1,3,2)
sbplts(ndvit', ipt(:)~=0 & (class(:)==1 | class(:)==2 | class(:)==3)); title('Aumento')
subplot(1,3,3)
sbplts(ndvit', ipt(:)~=0 & (class(:)==4 | class(:)==5)); title('Estável')

saveas(2,fig2);

%% FIGURA 3 - Informação auxiliar - CpR e NDRE
%%
%%    Flag CpR      Valor CpR
%%   Série T NDRE   Valor NDRE

i0=find(score==0);
i1=find(score==1);
i2=find(score==2); ic3=find(class==3); ic5=find(class==5);
ndre10 =squeeze( NDRE(reshape(img,[sz(1)*sz(2) 1 sz(3) sz(4)])))';
ndre1 = ndre10;
uniflag = NDVI(img(:,:,:,end))>0.7 & img(:,:,CpR,end)<0.18;
iu = find(uniflag);
figure(3); set(3,'visible','off');
axx1=subplot(2,2,1);
hold on
cpr1 = squeeze( reshape(img(:,:,CpR,:),[sz(1)*sz(2) 1 1 sz(4)]))';
if (numel(iu)>0)
  sbplts(cpr1,iu,false,[.1 .3]);
end
title('CpR (marcado)');

axx2=subplot(2,2,2);
hold on
cpr=img(:,:,CpR,end);
[ny nx] = size(cpr);
cpr0=nan(size(cpr)); cpr0(ic3)=cpr(ic3); cpr0(ic5)=cpr(ic5);
cpr0(:,end+1)=nan;
cpr0(end+1,:)=nan;
pcolor([0:nx]+.5,[0:ny]+.5,cpr0); title('CpR (NDVI>0.7)'); axis ij; shading flat
plot(shpij.X, shpij.Y)
colorbar; caxis([0.13 0.30]);
colormap(axx2, [[.3:.175:1]'*[0 1 0]; parula(12)]);
axis([0 sz(2) 0 sz(1)]);
axx2s=get(axx2,'Position');
set(axx2,'Position', [axx2s(1)*0.9 axx2s(2) axs3(3) axs3(4)]);
set(axx2,'DataAspectRatio',[1 1 1]);



axx3=subplot(2,2,3);
sbplts(ndre10,[ic3; ic5]); title('NDRE (NDVI>0.7)');

axx4=subplot(2,2,4);
hold on
%imagesc(ndre1(:,:,1,end)); 
ndre0=nan(size(ndre)); ndre0(ic3)=ndre(ic3); ndre0(ic5)=ndre(ic5);
ndre0(end+1,:)=nan; ndre0(:,end+1)=nan;
pcolor([0:nx]+.5, [0:ny]+.5, ndre0); shading flat
plot(shpij.X, shpij.Y); title('NDRE (NDVI>0.7)'); axis ij
axis([0 nx 0 ny]);
colorbar
caxis([0.3 0.8]);
colormap(axx4, [.6 0 0; .7 .2 0; .8 .4 0; .75 .55 0; .7 .7 0;  .5 .65 .1; .3 .6 .2; .15 .45 .1; 0 .3 0]);
%colormap(axx1, [1 1 1; .6 0 0; .8 .4 0; .7 .7 0;  .3 .6 .2; 0 .3 0]);
%colormap(axx4, [1 1 1; .6 0 0; .7 .2 0; .8 .4 0; .75 .55 0; .7 .7 0;  .5 .65 .1; .3 .6 .2; .15 .45 .1; 0 .3 0]);
%tl = get('TickLabels'); tl{1}='';
%set('TickLabels',tl);
%set(cb,'TickLabels')
axis([0 sz(2) 0 sz(1)]);
axx4s=get(axx4,'Position');
set(axx4,'Position', [axx4s(1)*0.9 axx4s(2) axs3(3) axs3(4)]);
set(axx4,'DataAspectRatio',[1 1 1]);


saveas(gcf,fig3);

end






