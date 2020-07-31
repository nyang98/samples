%% ME4508 Project 2
clear all; clc;

total=csvread('Project2BASIC.csv');         %total nodes
elem_node=csvread('Project2NOP.csv');       %element nodes
node_coor=csvread('Project2NODES.csv');     %node coordinates

num_elem=length(elem_node);      %number of elements
num_nodes=total(:,2);            %number of nodes
x_coor=node_coor(:,1);           %x-coordinates
y_coor=node_coor(:,2);           %y-coordinates
elem_dof=zeros(num_nodes,4);     

%% Element degree of freedom
for n=1:num_nodes
elem_dof(elem_node,1)= elem_node(n,1);
elem_dof(elem_node,2)= elem_node(n,2);
elem_dof(elem_node,3)= elem_node(n+1,1);
elem_dof(elem_node,4)= elem_node(n+1,2);
end

%%
E= 186e4;                        % MPa
A= 0.01;                         % mm^2

%% Initial Zero Matrix for All Matrices
displacement=zeros(2*num_nodes,1);
K_global=zeros(2*num_nodes);

%% Computation of the System Stiffness Matrix
for n=1:num_elem
 L(n)=sqrt((node_coor(elem_node(n,2),1)-node_coor(elem_node(n,1),1))^2+(node_coor(elem_node(n,2),2)-node_coor(elem_node(n,1),2))^2);
 C=(node_coor(elem_node(n,2),1)-node_coor(elem_node(n,1),1))/L(n);
 S=(node_coor(elem_node(n,2),2)-node_coor(elem_node(n,1),2))/L(n);
 k=(A*E/L(n)* [ C*C  C*S  -C*C -C*S;...
                C*S  S*S  -C*S -S*S;...
               -C*C -C*S   C*C  C*S;...
               -C*S -S*S   C*S  S*S]);

% Extract the Rows of Element DOF (for each element n)
elem_dof_vec=elem_dof(n,:);
    for i=1:4
        for j=1:4
            K_global(elem_dof_vec(1,i),elem_dof_vec(1,j))= K_global(elem_dof_vec(1,i),elem_dof_vec(1,j))+k(i,j);
        end
    end
end

%% Boundary Conditions
L=5;
R=0.1;

for x_coor=0:num_nodes
    if x_coor==0
        displacement(L,1)=displacement(i,1)
    elseif x_coor==5
        displacement(x_coor,1)=R
    end 
end
    
% displacement(1,1)=0;
% displacement(2000,1)=0.1;

%% Plot
for n=1:num_elem
    x=[node_coor(elem_node(n,1),1) node_coor(elem_node(n,2),1)];
    y=[node_coor(elem_node(n,1),2) node_coor(elem_node(n,2),2)];
plot(x,y,'b')
hold on
end


%% Solve
displacement=k\nodal_forces;





