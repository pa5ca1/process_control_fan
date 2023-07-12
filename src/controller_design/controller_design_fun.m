function PID = controller_design_fun(G,t_linspace,plot_bool,method,inverted_tf_bool)


if strcmp(method,'ZN_maxS')
    %% Approximation of FOPTD via max slope method
    % We have an S-shape and approximate our original tf by a FOPTD-tf
    % FOPTD-tf: First Order Plus Time Delay transfer function
    [K_maxS, T_maxS, T_d_maxS] = max_slope_method(G,t_linspace, plot_bool);
    PID = calculate_PID_parameters(K_maxS, T_maxS, T_d_maxS,inverted_tf_bool);
elseif strcmp(method,'ZN_2p')
    %% Approximation of FOPTD via two point method
    [K_2p, T_2p, T_d_2p] = two_point_method(G,t_linspace, plot_bool);
    PID = calculate_PID_parameters(K_2p, T_2p, T_d_2p,inverted_tf_bool);
elseif strcmp(method,'T_sum')
    PID = T_Sum_design(G,t_linspace,plot_bool);
    if inverted_tf_bool
        PID.K_p = - PID.K_p;
    end
end


end

function PID = calculate_PID_parameters(K,T,T_d,inverted_tf_bool)
% Calculation of control parameters
% IMPORTANT
% We are using neg. -G11! So we use here -K_P again
if inverted_tf_bool
    PID.K_p = - 1.2 * T/(K * T_d);
    PID.T_I = 2 * T_d;
    PID.T_D = 1/2* T_d;
else
    PID.K_p = 1.2 * T/(K * T_d);
    PID.T_I = 2 * T_d;
    PID.T_D = 1/2* T_d;
end
end