clear all;
clc;
clear;
%Drone initial position
x0=-2
y0=-2
z0=-2
%Controller and sliding surface parameters
a1=6
a2=1.5
epsilon=1

k_1=10
k_2=2.4
k_3=0.3
k_4=0.15

k_5=1

%Air resistance coefficients
K_1=0.01
K_2=0.01
K_3=0.01

%drone system parameters
m=1.5                                       %drone mass
g=9.8                                        %gravity
l=0.2                                         %distance from drone center to propeller center
KT=1.4697*10^-7                     %motor coefficient1
Jx=0.05                                     %moment of inertial around x
Jy=0.08                                     %moment of inertial around y
Jz=0.08                                     %moment of inertial around z
KQ=2.925*10^-9                      %motor coefficient2

%disturbances
d1=0.1                                      %outer loop disturbance
d2=1.5                                      %inner loop disturbance

%motor model
J=0.0007
Km=0.076
Kb=0.0734
L=0.000224
R=0.23
b=0.00125
Ct=1e-8

%% Run simulink model
sim("motor_anti_windup_whole_model3.slx", "SimulationMode", "rapid");
%% X Signal
x_outSignal = ans.x_out;
t = x_outSignal.Time;
x_out = x_outSignal.Data;

figure
scatter(t,x_out,'filled')
xlabel('t (seconds)')
ylabel('x out')
grid on

%% Y Signal
y_outSignal = out.y_out;
t = y_outSignal.Time;
y_out = y_outSignal.Data;

figure
plot(t,y_out)
xlabel('t (seconds)')
ylabel('y out')
grid on

%% Z Signal
z_outSignal = out.z_out;
t = z_outSignal.Time;
z_out = z_outSignal.Data;

figure
plot(t,x_out)
xlabel('t (seconds)')
ylabel('z out')
grid on

%% Phi Signal
phi_outSignal = out.phi_out;
t = phi_outSignal.Time;
phi_out = phi_outSignal.Data;

figure
plot(t,phi_out)
xlabel('t (seconds)')
ylabel('phi out')
grid on

%% Theta Signal
theta_outSignal = out.theta_out;
t = theta_outSignal.Time;
theta_out = theta_outSignal.Data;

figure
plot(t,theta_out)
xlabel('t (seconds)')
ylabel('theta out')
grid on

%% Psi Signal
psi_outSignal = out.psi_out;
t = psi_outSignal.Time;
psi_out = psi_outSignal.Data;

figure
plot(t,psi_out)
xlabel('t (seconds)')
ylabel('psi out')
grid on

%% Change reference position
%Drone initial position
x0=-3
y0=-2
z0=-2
sim("motor_anti_windup_whole_model3.slx", "SimulationMode", "accelerator");
