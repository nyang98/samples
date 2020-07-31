function [r] = rBeamConstant(w,L)

r=[ -w*L/2   ;...
    -w*L^2/12;...
    -w*L/2   ;...
    w*L^2/12];

end
