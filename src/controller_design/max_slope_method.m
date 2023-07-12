function [K_approx, T_approx, T_d_approx] = max_slope_method(G,t_linspace, plot_bool)

%% Step function of G
[y,t_out] = step(G,t_linspace);
[slope, intcpt] = calc_infliction_point_slope(y,t_out);
tngt = slope*t_out + intcpt;
[K, T, T_d, t_inter] = calc_gain_time_const_time_delay(y,t_out,tngt);

%% Calculate step response for FOPTD approximation
G_approx = tf(K,[T 1],'InputDelay',T_d);

[y_approx,t_out_approx] = step(G_approx,t_linspace);
[slope_approx, intcpt_approx] = calc_infliction_point_slope(y_approx,t_out_approx);
tngt_approx = slope_approx*t_out_approx + intcpt_approx;
[K_approx, T_approx, T_d_approx, t_inter_approx] = calc_gain_time_const_time_delay(y_approx,t_out_approx,tngt_approx);


%% Plot original and approximated transfer function
if plot_bool
    max_y = max([max(y),max(y_approx)]);

    figure()
    plot(t_out,y,'DisplayName','Original tf',LineWidth=3);
    hold on;
    plot(t_out_approx,y_approx,'DisplayName','Approximated tf',LineWidth=3);
    hold on;
    % Plot slope
    plot(t_linspace,tngt,'DisplayName','Tangent Original',LineWidth=3);
    hold on;
    ylim([0,1.1*max_y])
    % Plot K and T_d+T
    yline(K,'--','HandleVisibility','off',LineWidth=3);
    %yline(K_approx,'--','HandleVisibility','off',LineWidth=3);

    xline(t_inter,'--','HandleVisibility','off',LineWidth=3);
    %xline(t_inter_approx,'--','HandleVisibility','off',LineWidth=3);

    xline(T_d,'--','HandleVisibility','off',LineWidth=1.5);
    %xline(T_d_approx,'--','HandleVisibility','off',LineWidth=1.5);

    hold off;
    legend('Location','best')
end


end