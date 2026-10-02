function [tsfipi iiipi jjipi kkipi iFipi iLipi] =  compute_pwfits(img, func, ipi)

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

%  B = @(x,n) x(:,:,evalin('base',['B',num2str(n)]),:);
  B = @(x,n) x(:,:,n,:);
  
  NDVI = @(x) (B(x,B8)-B(x,B4))./(B(x,B8)+B(x,B4));
  EVI = @(x) 2.5*(B(x,B8)-B(x,B4))./(B(x,B8)+6*B(x,B4)-7.5*B(x,B2)+1);
  BSI = @(x) (B(x,B12) + B(x,B4) - B(x,B8) - B(x,B2))./(B(x,B12)+B(x,B4)+B(x,B8)+B(x,B2));
  NDBI = @(x) (B(x,B11) - B(x,B8))./(B(x,B11)+B(x,B8));
  NDWI = @(x) (B(x,B3)-B(x,B8))./(B(x,B3)+B(x,B8));

  if(strcmpi(func,'EVI'))
    FUNC = EVI;
  elseif(strcmpi(func,'NDVI'))
    FUNC = NDVI;
  end

  [ni, nj, ~, N] = size(img);
  disp(ipi)
  for ipj=1:nj
    tt=[1:N];
    ts = squeeze(FUNC(img(ipi,ipj,:,:)))';
    tt(isnan(ts))=[];
    ts(isnan(ts))=[];
%    if(numel(tt)>=2)
      iFipi(ipj)=tt(1); iLipi(ipj)=tt(end);
      [tsf0 iiipi(ipj) jjipi(ipj) kkipi(ipj)] = pwlfit3(tt,ts);
      tsf0 = interp1(tt,tsf0, [1:N]);
      tsfipi(:,1,ipj) = tsf0;
%    else
%      iFipi(ipj)=0; iLipi(ipj)=0;
%      tsf=NaN; iiipi(ipj)=NaN; jjipi(ipj)=NaN; kkipi(ipj)=NaN;
%      tsfipi(:,1,ipj) = NaN;
%    end
  end


end
