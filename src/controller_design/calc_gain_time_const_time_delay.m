function [K, T, T_d,t_interception] = calc_gain_time_const_time_delay(y,t,tngt)

% %Find the T_d and T
% Calculate the intercept of slope with K
K = max(y);
% Get t-value when tangents hits K
% First we calculate the index in t. With this index the time t
% can be calculated
t_index_interception = find(tngt>=max(y),1,'first');
t_interception = t(t_index_interception);
t_index_T_d = find(tngt>=0,1,'first');
% Calculation of T_d and T
T_d = t(t_index_T_d);
T = t_interception-T_d;


end