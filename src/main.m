clc; clear; close all;

%% Change everything to Latex
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
% Change font size
set(groot,'defaultAxesFontSize',16)
%% Paramters
plot_bool = 0;

%% Transfer function
% Store tf and RGA in a table
table_tf = make_transfer_function();

%% Relativ Gain Array
for i = 1:5
    table_tf{i,8} = {calculate_RGA(table_tf{i,"G_S_numerator"}{:})};
end
if plot_bool
    plot_RGA(table_tf)
end


%% Controller Design
% ZN_maxS
% ZN_2p
% T_sum

% Choose transfer function by choosing windspeed
v_wind = 8;
G_11 = table_tf(table_tf.wind_speed==v_wind,:).G_S{:}(1,1);
G_22 = table_tf(table_tf.wind_speed==v_wind,:).G_S{:}(2,2);

% Calculatio of PID_11
t_linspace = linspace(0,100);
inverted_tf_bool = 1;
method_of_calculation = 'ZN_maxS';
%method_of_calculation = 'ZN_2p';
PID_11 = controller_design_fun(-G_11,t_linspace,plot_bool,method_of_calculation,inverted_tf_bool);

% Calculation of PID_22
t_linspace = linspace(0,100);
method_of_calculation = 'T_sum';
inverted_tf_bool = 0;
PID_22 = controller_design_fun(G_22,t_linspace,plot_bool,method_of_calculation,inverted_tf_bool);


% %% PID BY ZIEGLER-NICHOLS
% 
% t_linspace = linspace(0,100);
% [PID_maxS, PID_2p] = Ziegler_Nichols_design(-G_11,t_linspace,plot_bool);
% 
% 
% %% PID BY T-Sum-Method
% % Step response for G_22 (windspeed 7 m/s)
% %G_22 = table_tf(table_tf.wind_speed==v_wind,:).G_S{:}(2,2);
% %t_linspace = linspace(0,10);
% % Get PID controller for G_22 by T-Sum-Method
% PID_tSum = T_Sum_design(-G_11,t_linspace,plot_bool);
% t_linspace = linspace(0,10,100)
% PID_22_t_sum = T_Sum_design(G_22,t_linspace,plot_bool);


%% Simulations in Simulink
v_wind = 8;
% Setting amplitudes for pulse
simP.A_beta = 8;
simP.A_alpha = -.1;
simP.A_wind = -2;

% Determine if pulse of zero for inputs and pertubation
simP.bool_beta = 1;
simP.bool_alpha = 0;
simP.bool_wind = 0;

% Simulation paramters
simP.t_simulation = 2000; % Time for simulation [s]
simP.T_period = 1200; % Peroid of pulse [s]
simP.T_delay = 600; % Delay for first pulse [s]
simP.pulse_width = 50; % Pulse width in % of T_Period [%]

% As two simulink blocks
G_D_sim_numerator_1 = table_tf(table_tf.wind_speed==v_wind,:).G_D_numerator{:}(1,1);
G_D_sim_denominator_1 = table_tf(table_tf.wind_speed==v_wind,:).G_D_denominator{:}(1,1);

G_D_sim_numerator_2 = table_tf(table_tf.wind_speed==v_wind,:).G_D_numerator{:}(2,1);
G_D_sim_denominator_2 = table_tf(table_tf.wind_speed==v_wind,:).G_D_denominator{:}(2,1);

% As different blocks
% Signal path can be better seen
G_S_sim_numerator_11 = table_tf(table_tf.wind_speed==v_wind,:).G_S_numerator{:}(1,1);
G_S_sim_denominator_11 = table_tf(table_tf.wind_speed==v_wind,:).G_S_denominator{:}(1,1);
G_S_sim_numerator_12 = table_tf(table_tf.wind_speed==v_wind,:).G_S_numerator{:}(1,2);
G_S_sim_denominator_12 = table_tf(table_tf.wind_speed==v_wind,:).G_S_denominator{:}(1,2);
G_S_sim_numerator_21 = table_tf(table_tf.wind_speed==v_wind,:).G_S_numerator{:}(2,1);
G_S_sim_denominator_21 = table_tf(table_tf.wind_speed==v_wind,:).G_S_denominator{:}(2,1);
G_S_sim_numerator_22 = table_tf(table_tf.wind_speed==v_wind,:).G_S_numerator{:}(2,2);
G_S_sim_denominator_22 = table_tf(table_tf.wind_speed==v_wind,:).G_S_denominator{:}(2,2);


G_S_sim = table_tf(table_tf.wind_speed==v_wind,:).G_S;
G_D_sim = table_tf(table_tf.wind_speed==v_wind,:).G_D;

%% Simulation of step response
[y,t_y,u,t_u,simOut] = simulate_step_response();
if plot_bool
    plot_step_response_open_loop(y,t_y,u,t_u)
end


%% Simulation closed loop
exp_name = 99;

plot_bool = 1;
simP.wind_ref = 0;
PID_11_Sim = matlab_PID_paremters(PID_11);
PID_11_Sim.N = .01;
PID_22_Sim = matlab_PID_paremters(PID_22);
PID_22_Sim.N = .01;
simP.t_simulation = 1600; % Time for simulation [s]

% Saturation blocks
simP.beta_sat = [25,-25];
simP.alpha_sat = [0.7,-0.3];

simP.wind_t = 1200;
simP.noise_power_wind = [0];
simP.wind_final = 0;


simP.Pg_t = 100;
simP.Pg_final = -1;

simP.omega_t = 800;
simP.omega_final = -200;

[y,e,u,u_hat,r,t,simOut] = simulate_PID_closed_loop();
if plot_bool
    plot_PID_closed_loop(y,e,u,u_hat,r,t,simP,exp_name)
end

disp('##### Scenario step change #####')
%disp(['Derivation from steady state u_1: ' , num2str(u_hat(end,1))])
%disp(['Derivation from steady state u_2: ' , num2str(u_hat(end,2))])


%% Relay Feedback Method
simP.alpha_ref = 0;
simP.wind_ref = 0;
simP.beta_ref = 10;
simP.step_time = 10;
simP.t_simulation = 100; % Time for simulation [s]

%% Literature
% [1]
% [2]
