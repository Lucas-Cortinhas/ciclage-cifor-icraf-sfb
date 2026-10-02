function shapeij = shape_xy2ij(shapexy, RR)
% function shapeij = shape_xy2ij(shapexy, RR)
% Convert shapes to indices using the reference matrix
% RR = [ 0 dx x0;
%       dy  0 y0a];
%
% RR - convert i,j -> x,y
% RRi- convert x,y -> i,j
%   
%
% B.I. 2025.09.12

%% Compute I,J, indices from X and Y.

if(all(size(RR)==[3,2]))
  RR=RR';
end
RRi = [0 1/RR(2,1) -RR(2,3)/RR(2,1); 1/RR(1,2) 0  -RR(1,3)/RR(1,2)];

shapeij=shapexy;
for is=1:length(shapexy)

  x = shapexy(is).X;
  y = shapexy(is).Y;
  IIJJ = nearest(RRi*[x;y;ones(size(x))]);
  II = IIJJ(1,:);
  JJ = IIJJ(2,:);
  shapeij(is).X = JJ;
  shapeij(is).Y = II;
  shapeij(is).RR=RR;
  shapeij(is).BoundingBox=[min(II) min(JJ); max(II) max(JJ)];
end



