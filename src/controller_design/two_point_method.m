function [K_approx, T_approx, T_d_approx] = two_point_method(G,t_linspace, plot_bool)

[y,t] = step(G,t_linspace);
% Get maximum value of y
y_inf = max(y);
y_0 = min(y);
y_hat =  y_inf-y_0;
y_28 = y_0 + 0.28 * y_hat;
y_63 = y_0 + 0.63 * y_hat;
% Making y unique valued
[y_out,i_unique,~] = unique(y,'stable');
t_out = t(i_unique);
% Calculation of time points where y reaches 28/63 percent
t_28 = interp1(y_out,t_out,y_28);
t_63 = interp1(y_out,t_out,y_63);

%% Calculation of T, T_d
T = 3/2 * (t_63-t_28);
T_d = t_63 - T;
K = y_inf;

G_approx = tf(K,[T 1],'InputDelay',T_d);

[y_approx,t_out_approx] = step(G_approx,t_linspace);
[slope_approx, intcpt_approx] = calc_infliction_point_slope(y_approx,t_out_approx);
tngt_approx = slope_approx*t_out_approx + intcpt_approx;
[K_approx, T_approx, T_d_approx, t_inter_approx] = calc_gain_time_const_time_delay(y_approx,t_out_approx,tngt_approx);

if plot_bool
    figure()
    plot(t_out,y,'DisplayName','Original tf',LineWidth=3)
    hold on;
    plot(t_out_approx,y_approx,'DisplayName','Approximated tf',LineWidth=3)
    hold on;
    yline(y_28,'--','HandleVisibility','off',LineWidth=3)
    hold on;
    xline(t_28,'--','HandleVisibility','off',LineWidth=3)
    hold on;
    yline(y_63,'--','HandleVisibility','off',LineWidth=3)
    hold on;
    xline(t_63,'--','HandleVisibility','off',LineWidth=3)
    hold off;
    legend();
end


end
