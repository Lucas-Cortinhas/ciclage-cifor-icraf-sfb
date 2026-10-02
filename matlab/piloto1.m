%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Piloto 1 - Amazônia
%% Ciclage Concultoria Ambiental
%% CIFOR-ICRAF
%% 2026
%%
%% Consultor: Prof. Dr. Breno C. de O. Imbiriba

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Implementação computacional do Piloto 1 para o bioma Amazônia.
%% em MATLAB 2016b 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% Define índices dos canais de arquivos pre-processados com Sentinel 2 (bandas espectrais) e Sentinel 1(CpR e VH_dB)

B1 = 1; 
B2 = 2;
B3 = 3;
B4 = 4;
B5 = 5;
B6 = 6;
B7 = 7;
B8 = 8;
B8A = 9;
B9 = 10;
B11 = 11;
B12 = 12;
CpR = 13;
VH_dB = 14;

% Nome do arquivo a ser processado.
% Arquivos da forma base_yyyy.tif
% base - a base do nome do arquivo
% yyyy - ano associado à imagem tif.
fnb = 'teste/image_0';

processa(fnb);


shp=shaperead('teste/amazonia1.shp');
shp = shp(1);

plotaPT(fnb,shp);


