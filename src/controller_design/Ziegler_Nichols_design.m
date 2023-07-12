function [PID_maxS, PID_2p] = Ziegler_Nichols_design(G,t_linspace,plot_bool)

%% Approximation of FOPTD via max slope method
% We have an S-shape and approximate our original tf by a FOPTD-tf
% FOPTD-tf: First Order Plus Time Delay transfer function
[K_maxS, T_maxS, T_d_maxS] = max_slope_method(G,t_linspace, plot_bool);
PID_maxS = calculate_PID_parameters(K_maxS, T_maxS, T_d_maxS);

%% Approximation of FOPTD via two point method
[K_2p, T_2p, T_d_2p] = two_point_method(G,t_linspace, plot_bool);
PID_2p = calculate_PID_parameters(K_2p, T_2p, T_d_2p);

end


function PID = calculate_PID_parameters(K,T,T_d)
% Calculation of control parameters
% IMPORTANT
% We are using neg. -G11! So we use here -K_P again
PID.K_p = - 1.2 * T/(K * T_d);
PID.T_I = 2 * T_d;
PID.T_D = 1/2* T_d;
end