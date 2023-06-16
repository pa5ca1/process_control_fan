function PID = PID_Ziegler_Nichols(G,t_linspace)

%% Step function of G
[y,t_out] = step(G,t_linspace);


%% Find the inflection point and tangent
% Source: https://de.mathworks.com/matlabcentral/answers/295156-how-to-find-the-inflection-point-of-a-curve-in-matlab
% gradient of step response
dydt = gradient(y);
% Find y and t of highest gradient
t_infl = interp1(dydt, t_linspace, max(dydt));
y_infl = interp1(t_linspace, y, t_infl);
% Calculate slope
slope  = interp1(t_linspace, dydt, t_infl);
% Find y-interception
intcpt = y_infl - slope*t_infl;
% Calculation of tangent
tngt = slope*t_linspace + intcpt; 


% %Find the T_d and T
% Calculate the intercept of slope with K
K = max(y);
% Get t-value when tangents hits K
% First we calculate the index in t_linspace. With this index the time t
% can be calculated
t_index_interception = find(tngt>=max(y),1,'first');
t_interception = t_linspace(t_index_interception);
t_index_T_d = find(tngt>=0,1,'first');
% Calculation of T_d and T
T_d = t_linspace(t_index_T_d);
T = t_interception-T_d;


% Calculation of control parameters
PID.K_p = 1.2 * T/(K * T_d);
PID.T_I = 2 * T_d;
PID.T_D = 1/2* T_d;


%% Plots

figure()
plot(t_linspace,y);
hold on;
% Plot slope
plot(t_linspace,tngt,LineWidth=3);
hold on;
ylim([0,1.1*max(y)])
% Plot K and T_d+T
yline(K,'--',LineWidth=3);
xline(t_interception,'--',LineWidth=3);
xline(T_d,'--',LineWidth=1.5);
hold off;

end