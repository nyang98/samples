function [N1,N2,E,A,L] = readBarElemProp(connectivity,elem_num)

    N1=connectivity(elem_num,1);
    N2=connectivity(elem_num,2);
    E =connectivity(elem_num,3);
    A =connectivity(elem_num,4);
    L =connectivity(elem_num,5);
    
end

