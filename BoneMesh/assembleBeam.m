function [K,R] = assembleBar(N1, N2, k_elem, K, R)


rows=    [N1 N2];
columns= [N1 N2];

for i=1:2
    row=rows(i);
    for j=1:2
        column=columns(j);
        K(row,column)=K(row,column)+k_elem(i,j);
    end
end
    

end

