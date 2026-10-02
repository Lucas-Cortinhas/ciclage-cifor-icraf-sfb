function tsf=pwlfit_core1(tt,ts,X0)

  x0=X0(1); x1=X0(2); x2=X0(3); x3=X0(4); x4=X0(5);

  ix1=find(tt==x1,1,'last');
  ix2=find(tt==x2,1,'last');
  ix3=find(tt==x3,1,'last');
  %ix4=find(x>x3,1,'first');
  N = numel(tt);

  %        A  a b c d % e 
  beta0 = [.5 0 0 0 0]; %0];
  beta = nlinfit(tt,ts, @f, beta0);
  tsf = f(beta,tt); 

  %function [y J]=f(BETA,x)
  function y=f(BETA,x)

    % x0 x1 x2 x3 x4 
    %   a  b  c  d 

    A=BETA(1);
    a=BETA(2); b=BETA(3); c=BETA(4);
    d=BETA(5); %e=BETA(6);


%    ix1=x<=x1;
%    ix2=x>x1&x<=x2;
%    ix3=x>x2&x<=x3;
%    ix4=x>x3;
%
%    y(ix1) = A + (x(ix1)-x0).*a;
%    y(ix2) = A + (x1-x0).*a + (x(ix2)-x1).*b;
%    y(ix3) = A + (x1-x0).*a + (x2-x1).*b + (x(ix3)-x2).*c;
%    y(ix4) = A + (x1-x0).*a + (x2-x1).*b + (x3-x2).*c + (x(ix4)-x3).*d;


%    y = zeros(size(x)); 

    w1 = (x1-x0).*a; w2 = (x2-x1).*b; w3 = (x3-x2).*c; 

    y(1:ix1)     = A + (x(1:ix1)-x0).*a;
    y(ix1+1:ix2) = A + w1 + (x(ix1+1:ix2)-x1).*b;
    y(ix2+1:ix3) = A + w1 + w2 + (x(ix2+1:ix3)-x2).*c;
    y(ix3+1:N) = A + w1 + w2 + w3 + (x(ix3+1:N)-x3).*d;

%    Ja = [             x(1:ix1)-x0     zeros(1,N-ix1)];
%    Jb = [zeros(1,ix1) x(ix1+1:ix2)-x1 zeros(1,N-ix2)];
%    Jc = [zeros(1,ix2) x(ix2+1:ix3)-x2 zeros(1,N-ix3)];
%    Jd = [zeros(1,ix3) x(ix3+1:N)-x3                 ];
%    
%    J = [Ja' Jb' Jc' Jd'];

  end

end
