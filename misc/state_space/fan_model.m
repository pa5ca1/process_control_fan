function dXdt = fan_model(t,X,p)


w_r = X(1);
i = X(2);

%% Electrical Subsystem
% electromagnetic torque
tau_em = p.k_t*i;
% ???


%% Mechanical Subsystem
% tip-speed ratio
lambda = (w_r*p.R)/p.v;
P_c = power_coefficient(lambda,p.beta,p.lookup);
% aerodynamic torque
tau_a = 0.5 * p.rho * p.pi * p.R^3 * P_c/lambda * p.v^2;
% ODE
dwrdt = 1/p.J_r * (tau_a - tau_em);
dPdt = p.eta*tau_em*w_r;

dXdt = [dPdt, dwrdt]';

end
