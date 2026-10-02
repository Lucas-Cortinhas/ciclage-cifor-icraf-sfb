function processa(fnb)


  disp(['Processando arquivo ', fnb]);

  outfn=[fnb '.mat'];

  ano0=2019; ano1=2025;
  anos = [ano0:ano1];
  for iy=1:numel(anos)
    fns{iy}=[fnb '_' num2str(anos(iy)) '.tif'];
  end

  if(exist(outfn))
    disp(['Arquivo ' outfn ' existe. Saindo.']);
    for iff=1:numel(fns)
      info0=geotiffinfo(fns{iff});
      if(iff==1)
	info = info0;
      end
      info(iff) = info0;
    end
    return
  end


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

% Declara a função de cálculo de índices
B = @(x,n) x(:,:,evalin('base',['B',num2str(n)]),:);

NDVI = @(x) (B(x,8)-B(x,4))./(B(x,8)+B(x,4));
EVI = @(x) 2.5*(B(x,8)-B(x,4))./(B(x,8)+6*B(x,4)-7.5*B(x,2)+1);
BSI = @(x) (B(x,12) + B(x,4) - B(x,8) - B(x,2))./(B(x,12)+B(x,4)+B(x,8)+B(x,2));
NDBI = @(x) (B(x,11) - B(x,8))./(B(x,11)+B(x,8));
NDWI = @(x) (B(x,3)-B(x,8))./(B(x,3)+B(x,8));
MSI = @(x) (B(x,11)./B(x,8));
MSIn = @(x) (B(x,11)-B(x,8))./((B(x,11)+B(x,8)));
NDRE = @(x) (B(x,9)-B(x,5))./(B(x,9)+B(x,5));


% Carrega imagem
for iff=1:numel(fns)
  img0=geotiffread(fns{iff});
  info0=geotiffinfo(fns{iff});
  if(iff==1)
    img = zeros([size(img0), 0]);
    info = info0;
  end
  img = cat(4,img,img0);
  info(iff) = info0;
end

img(isnan(img))=-9999;

% Tem que remover NaNs, mas isso será feito na parte do fit.

% Número total de anos
[ni, nj, ~, N] = size(img);

% Anos
TT = 2025-[N-1:-1:0];



%% Processamento no estilo LandTrandR

% Calcula os ajustes de função linear em pedaços (piecewise linear functions)
tsf = zeros(N,ni,nj);
for ipi=1:ni
  disp([num2str(ipi) '/' num2str(ni)])
  [tsfipi iiipi jjipi kkipi iFipi iLipi] = compute_pwfits(img, 'ndvi', ipi);
  tsf(:,ipi,:) = tsfipi;
  ii(ipi,:) = iiipi;
  jj(ipi,:) = jjipi;
  kk(ipi,:) = kkipi;
  iF(ipi,:) = iFipi;
  iL(ipi,:) = iLipi;
end


% ii,jj,kk indicam as posições do 3o, 2o e 1o vértices internos 
% Mas queremos achar as quedas:
% ii é válido SE jj-ii está decrescendo e ii-N está crescendo
% etc...

for ipi=1:ni
  disp([num2str(ipi) '/' num2str(ni)])
  for ipj=1:nj
    segl(ipi,ipj) = -(tsf(iF(ipi,ipj),ipi,ipj)-tsf(kk(ipi,ipj),ipi,ipj)); nsl(ipi,ipj)=kk(ipi,ipj)-iF(ipi,ipj);
    segk(ipi,ipj) = -(tsf(kk(ipi,ipj),ipi,ipj)-tsf(jj(ipi,ipj),ipi,ipj)); nsk(ipi,ipj)=jj(ipi,ipj)-kk(ipi,ipj);
    segj(ipi,ipj) = -(tsf(jj(ipi,ipj),ipi,ipj)-tsf(ii(ipi,ipj),ipi,ipj)); nsj(ipi,ipj)=ii(ipi,ipj)-jj(ipi,ipj);

    segi(ipi,ipj) = -(tsf(ii(ipi,ipj),ipi,ipj)-tsf(iL(ipi,ipj),ipi,ipj)); nsi(ipi,ipj)=iL(ipi,ipj)-ii(ipi,ipj);
  end
end

save(outfn);

end
