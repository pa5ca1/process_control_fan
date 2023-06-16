clc; clear; close all;


%% Parameters
p.R = 297.9e-3; % Rotor Radius [m]
p.P_gr = 80; % Rated Power [W]
p.w_rr = 189.5; % Rated speed [rad/s]
p.U_gr = 24; % Rated voltage [V]
p.I_gr = 2.94; % Rated current [A]
p.J_r = 11000; % Rotor inertia [g * cm^-2]
p.J_g = 1340; % Generator inertia [g * cm^-2]
p.R_a = 1.44; % Armature resistance [\Ohm]
p.L_a = 0.56; % Armature inductance [mH]
p.k_b = 95.3; % Speed constant [rpm * V^-1]
p.k_t = 100; % Torque constant [mNm * A^-1]
p.eta = .77; % Efficiency [1]
p.R_L = 22; % Load resistance [\Ohm] (for 100 W)

% Loading lookup table
p.lookup = readtable('lookuptable_c_p.csv');
p.lookup.Properties.VariableNames = {'wind_speed','rotor_speed','U','i_a','P_e','P_m','lambda','C_p','C_q','beta'};


p.rho = 1.293; % ??? density of air [kg m^-3] ???
p.v = 6; % Wind speed [m/s]
p.pi = pi; % pi [1]
p.beta = 1; % Blade angle [°]



%% Solving ODE
% Simulation time: continues from t=10 to tend=100
tspan= [0 200];
x0 = [190,6.5];
options =[];
ode_fun = @(t,X) fan_model(t,X,p);

[t,w_r]= ode45(ode_fun,tspan,x0,options);

%[t,w_r]= ode45(@(t,w_r)fan_model(t,w_r,p),tspan,x0,options);

%% Plots

figure(1)
plot(t,w_r)







