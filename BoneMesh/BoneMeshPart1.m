clear all; clc;

%%
% Read the data
position = xlsread('Bone','A1:A207');       %column of position, changed from A1 to A2
area = xlsread('Bone','B1:B207');           %column of area at each position, changes from B1 to B2


%% Calculate mean and std. dev.
a_avg = mean(area);
area_avg = a_avg * 10^-6; %in m^2
sd = std(area);
scatter(position,area,'.');
xlabel('Position (mm)')
ylabel('Area (mm^2)')
title('Area vs. Length')

%% Problem Inputs and Geometry
E=18.6e9;           %N/m^2
L=205e-3;           %m
P=-1382;            %N 

num_elems=50;                           %we can change this
L_elem= L/num_elems;
num_nodes=num_elems + 1;
A_matrix=zeros(1,num_elems)             %inilitalizing Area Array with colum  equal to element number
c=1:num_elems;
for c=1                                 %this loop puts the first avg area value into the matrix
            o=1;
            b=1*L_elem*10^3;
            A=mean(area (o:b));
            A_matrix(1,1)=A; 
end
for c=2:num_elems                       %this loop fills the area matrix
    
        o=(c-1)*L_elem*10^3;
        b=1+ c*L_elem*10^3; 
        A=mean(area (o:b));
        A_matrix(1,c)=A;
end
A_matrix=A_matrix*10^-6


%% Mesh - function input A values into this matrix
connectivity=zeros(num_elems,5); %N1 N2 E A L

for elem_num = 1:num_elems
    N1=elem_num; N2=elem_num+1; 
    connectivity(elem_num,1)= N1;                       %first column
    connectivity(elem_num,2)= N2;                       %second column
    connectivity(elem_num,3)= E;                        %third column
    connectivity(elem_num,4)= A_matrix(1,elem_num);     %fourth column
    connectivity(elem_num,5)= L_elem;                   %fifth column
end

%% Assembly

K_global=zeros(num_nodes, num_nodes);
R_global=zeros(num_nodes, 1);
R_global(1)=P;

for elem_num=1:num_elems
    [N1,N2,E_elem,A_elem,L_elem] = readBarElemProp(connectivity,elem_num);
    k_elem= kBar(E_elem, A_elem, L_elem);
    [K_global,R_global] = assembleBar(N1, N2, k_elem, K_global, R_global);
end

%% Apply BC: Penalty Method

Kp= 10^10*max(max(K_global));

node_num=num_nodes;
%delta=0;
    
K_global(node_num,node_num)=K_global(node_num,node_num)+Kp;

%% Solution
D_global=(K_global\R_global)*10^3               %displacement matrix in mm


%% Stress Calculation
if num_elems < 2
    
x=input('X Location in mm: ')
X_global=(0:elem_num)*L_elem*10^3
X(:,1)=(1:length(D_global));
X(:,2)=X_global;

disp=(10^-3)*[D_global(1,1)*(x/205);...
      0];

stress=E*[-1/L 1/L]*disp
d_0=D_global(1,1)                      %displacement at node 1 aka dispacelemtn at x=0 in mm
d_100=(x/205)*d_0                      %displacement at node closest to x=100 in mm
else

x=input('X Location in mm: ')
X_global=(0:elem_num)*L_elem*10^3
X(:,1)=(1:length(D_global));
X(:,2)=X_global;

index=1;                              %index is the location of the element with displacement at length x
for i=1:length(X(:,1))
    if X(i,2)>x
        index=i-1
        break
    end
end

disp=(10^-3)*[D_global(1,1);...
      D_global(index,1)];

stress=E*[-1/L 1/L]*disp
d_0=D_global(1,1)                   %displacement at node 1 aka dispacelemtn at x=0 in mm
d_100=D_global(index,1)             %displacement at node closest to x=100 in mm
end 
