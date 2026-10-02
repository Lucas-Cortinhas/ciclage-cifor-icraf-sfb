# ciclage-cifor-icraf-sfb

# Pilot 1

## Produção dos dados de entrada

Arquivos gerados seguem a forma:

	base_id_yyyy.tif

base_id é a base do nome (podendo conter path).
yyyy vai de 2019 à 2025.


## Análise dos dados

Uma vez gerados os arquivos anuais (2019 à 2025) para uma determinada área, a rotina piloto1.m executa a análise e gera as figuras.

Na rotina "piloto1.m", será necessário configuras as variáveis "fnb" e "shp", por exemplo

% fnb - com a base do nome dos arquivos de dados.
	fnb = 'teste/image_0';

% shp - com o shapefile da área em questão.
	shp = shaperead('teste/amazonia1.shp');
	shp = shp(1)


