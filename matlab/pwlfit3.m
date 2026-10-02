function [tsf ii jj kk ] = pwlfit3(tt, ts)
  % Brute force piecewise linear fit
  % Similar to pwlfit.m but takes a time index array tt that indicates valid locations 
  % (non NaNs)
  % Experimenta com menos segmentos - fazendo eles serem iguais

  warning('off');

  N = length(tt);

  % Calcula todas as possibilidades
  %                    N-2 N-1 N
  % |------------------x   x   x|
  %  123 
  % |xxx------------------------|
  ixx=0;
  idx=[];
  err=[];
  for ii=N-1:-1:3
    %disp(ii)
    for jj=ii-1:-1:2
      for kk=jj-1:-1:1
	ixx = ixx+1;
	idx(ixx,:) = [ii,jj,kk];
	rl = tt([1:kk]);
	rk = tt([kk:jj]);
	rj = tt([jj:ii]);
	ri = tt([ii:N]);

        ijk(:,ixx) = [ii jj kk];

        % Aqui vamos usar nlinfit 
	tsff = pwlfit_core1(tt, ts, [tt(1) tt(kk) tt(jj) tt(ii) tt(N)]);
        err(ixx) = sqrt(sum((ts-tsff).^2));
      end
    end
  end

[emin imin] = min(err);

ii = ijk(1,imin);
jj = ijk(2,imin);
kk = ijk(3,imin);

% Calculate pwfunction
tsf = pwlfit_core1(tt, ts, [tt(1) tt(kk) tt(jj) tt(ii) tt(N)]);

% salva ii,jj,kk na numeração original
ii = tt(ijk(1,imin));
jj = tt(ijk(2,imin));
kk = tt(ijk(3,imin));

	

  warning('on');


end

