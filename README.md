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


# Colocar scripts na pasta GEE

        users/xxxxxxxxxxxxxxxx/yyyyyyy

onde:
xxxxxxxxxxxxxxxx é o nome do usuário
yyyyyyy é o nome do projeto


# Como gerar arquivos processados de dados para os pilotos 1 e 2.

BM-P2-LT-Export_Image

No script, definir:

1. Definir um Asset com os shapefiles (exemplo: Amazonia)
   Aqui estamos usando um asset com shapefiles (linhas 3)
   e a escolha do shape particular nas linhas 20-24.
   Variáveis: AOIf, type, id.

2. Verificar as datas de início e fim.
   Variáveis START_DATE e END_DATE nas linhas 32 e 35.

3. Ajustar caminhos: Asset (linha 3). Biblioteca de rotinas (linas 107-109)

4. Alterar pasta de saída e nome do arquivo nas linhas 223-224.




# Execução do Piloto 2

BM-P2-LT-Export_results

No script, definir:

1. Definir um Asset com os shapefiles (exemplo: Amazonia)

2. Definir o arquivo de treinamento para o random forests. Aqui é o 'base_samples-v10'

3. Variável export_anual (true/false) define se, ao final do processamento de um ID, os dados utilizados são salvos em arquivos anuais para cada id.





