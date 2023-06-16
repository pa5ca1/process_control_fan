clc; clear; close all;
%% Paramters
% Setting amplitudes for pulse
A_beta = 10;
A_alpha = -.1;
A_wind = -1;

% Determine if pulse of zero for inputs and pertubation
bool_wind = 0;
bool_alpha = 0;
bool_beta = 0;

% Simulation paramters
t_simulation = 2000; % Time for simulation [s]
T_period = 1200; % Peroid of pulse [s]
T_delay = 600; % Delay for first pulse [s]
pulse_width = 50; % Pulse width in % of T_Period [%]

v_wind = 7;

%% Transfer function 

% Wind speed: 6 m/s
G_S_numerator_6 = {-8.059,-405.4;-0.0081479,4.4195};
G_S_denominator_6 = {[75.27,17.35,1],[28.25, 16.47, 1];[0, 16.873, 1],[0, 1.7589, 1]};
G_D_numerator_6 = {364.9; 1.139};
G_D_denominator_6 = {[118.3, 21.76, 1];[65.28, 17.09, 1]};

% Wind speed: 7 m/s
G_S_numerator_7 = {-10.534,-520.3;-0.039756,5.8011};
G_S_denominator_7 = {[97.41,20.63,1],[16.61,15.81,1];[0, 14.653,1],[0, 1.2295, 1]};
G_D_numerator_7 = {340.01; 1.139};
G_D_denominator_7 = {[110.3, 21.01, 1];[52.72, 14.97, 1]};

% Wind speed: 8 m/s
G_S_numerator_8 = {-8.3951,-491.4;-0.06102,6.7614};
G_S_denominator_8 = {[118.4,21.77,1],[35.36,11.89,1];[0,16.93,1],[0,0.93526,1]};
G_D_numerator_8 = {345;2.341};
G_D_denominator_8 = {[104.6,20.45,1];[41.53,14.85,1]};

% Wind speed: 9 m/s
G_S_numerator_9 = {-45.251,-366.8;-0.3132,8.0643};
G_S_denominator_9 = {[113.4, 21.37, 1],[50.86, 14.36, 1];[0,16.803,1],[0,1.10434,1]};
G_D_numerator_9 = {287.46;2.0273};
G_D_denominator_9 = {[85.1,18.45,1];[40.73, 12.76, 1]};

% Wind speed: 10 m/s
G_S_numerator_10 = {-59.06,-300.6;-0.3932,8.6291};
G_S_denominator_10 = {[116.8, 21.62, 1],[0.01389, 13.9, 1];[0,16.395,1],[0,1.446,1]};
G_D_numerator_10 = {248.2;1.791};
G_D_denominator_10 = {[74.04, 17.21, 1];[21.91, 11.91, 1]};

% Making a table to stora all transfer_function
sz = [5 8];
varTypes = ["double","cell","cell","cell","cell","cell","cell","4x4double"];
varNames = ["wind_speed","G_S_numerator","G_S_denominator","G_D_numerator","G_D_denominator","G_S","G_D","RGA"];
%table_tf = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
table_tf = table;

table_tf(1,1:5) = {6,G_S_numerator_6,G_S_denominator_6,G_D_numerator_6,G_D_denominator_6};
table_tf(2,1:5) = {7,G_S_numerator_7,G_S_denominator_7,G_D_numerator_7,G_D_denominator_7};
table_tf(3,1:5) = {8,G_S_numerator_8,G_S_denominator_8,G_D_numerator_8,G_D_denominator_8};
table_tf(4,1:5) = {9,G_S_numerator_9,G_S_denominator_9,G_D_numerator_9,G_D_denominator_9};
table_tf(5,1:5) = {10,G_S_numerator_10,G_S_denominator_10,G_D_numerator_10,G_D_denominator_10};
table_tf.Properties.VariableNames = varNames(1:5);

for i = 1:5
    table_tf{i,6} = {tf(table_tf{i,"G_S_numerator"}{:},table_tf{i,"G_S_denominator"}{:})};
    table_tf{i,7} = {tf(table_tf{i,"G_D_numerator"}{:},table_tf{i,"G_D_denominator"}{:})};
    table_tf{i,8} = {calculate_RGA(table_tf{i,"G_S_numerator"}{:})};
end
table_tf.Properties.VariableNames = varNames;

%% ZIEGLER-NICHOLS

% Choose transfer function
G_11 = table_tf(table_tf.wind_speed==v_wind,:).G_S{:}(1,1);
t_linspace = linspace(0,100);
% Get PID controller for G_11 by Ziegler Nichols
PID_11 = PID_Ziegler_Nichols(-G_11,t_linspace);

%% T-Sum-Method
% Step response for G_22 (windspeed 7 m/s)
G_22 = table_tf(table_tf.wind_speed==v_wind,:).G_S{:}(2,2);
t_linspace = linspace(0,10);
% Get PID controller for G_22 by T-Sum-Method
PID_22 = PID_T_Sum(G_22,t_linspace);



%% Simulations in Simulink

G_D_sim_numerator_1 = table_tf(table_tf.wind_speed==v_wind,:).G_D_numerator{:}(1,1);
G_D_sim_denominator_1 = table_tf(table_tf.wind_speed==v_wind,:).G_D_denominator{:}(1,1);

G_D_sim_numerator_2 = table_tf(table_tf.wind_speed==v_wind,:).G_D_numerator{:}(2,1);
G_D_sim_denominator_2 = table_tf(table_tf.wind_speed==v_wind,:).G_D_denominator{:}(2,1);

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


%% Relativ Gain Array

% Calculation
lambda_11_array = zeros(1,5);
axh = {};
for i=1:5
lambda_11_array(i) = table_tf.RGA{i}(1,1);
end

% Ploting RGA
fig = figure(1);
tiledlayout(2,3);

for i=1:5
    nexttile;
    c = gray;
    c = flipud(c);
    axh{i} = heatmap(table_tf.RGA{i},'Colormap', c);
    %axh{i}.CLimMode = 'manual';
    axh{i}.ColorLimits = [0,1];
    axh{i}.Title= string(table_tf.wind_speed(i)) + ' m/s';
    axh{i}.ColorbarVisible = 'off';
    axh{i}.FontSize = 16; 
    axh{i}.XLabel = "Output";
    axh{i}.YLabel = "Input";
    %axh{i}.YDisplayLabels = {{'\omega_r'},{'P_g'}};
    %axh{i}.XDisplayLabels = {{'\beta'},{'\alpha'}};
end
nexttile;
plot(lambda_11_array,'+-',"LineWidth",2,"MarkerSize",10);
hold on;
plot(1-lambda_11_array,'+-',"LineWidth",2,"MarkerSize",10);
xlim([1,5])
xticks([1,2,3,4,5])
xticklabels({'6','7','8','9','10'});
xlabel('Windspeed [m/s]','FontSize',16)
ylabel('\lambda_{ii} and \lambda_{ij}','FontSize',16)
lgd = legend({'\lambda_{ii}','\lambda_{ij}'},"FontSize",16);
lgd.Location = "best";

cb = colorbar('Colormap', c);
cb.FontSize = 16;
cb.Layout.Tile = 'east';

%% Functions

function RGA = calculate_RGA(G_S_numerator)
% Computation of RGA
% See p. 123 in [2]
lambda_11 = G_S_numerator{1,1}/(G_S_numerator{1,1} - (G_S_numerator{1,2}*G_S_numerator{2,1})/G_S_numerator{2,2} );
RGA = [[lambda_11, 1-lambda_11];[1-lambda_11,lambda_11]];
end

%% Literature
% [1]
% [2]
