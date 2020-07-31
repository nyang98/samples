
function [k] = kBeam(E,A,L)

k=E*A/L*  [1  -1;...
           -1  1];
           
end
