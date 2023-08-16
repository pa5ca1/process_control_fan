function plot_PID_closed_loop(y,e,u,u_hat,r,t,simP,exp_number)

save_name = strcat('03_Simulation/fig/exp_', num2str(exp_number), '_');

figure()
tiledlayout(3,1);

% Check if we have constants for reference values
if size(r,1) == 1
    n = size(y,1);
    r = repmat(r,n,1);
    t_r = linspace(0,t(end),n);
else
    t_r = t;
end

rel_e = calc_relative_error(y,e);

nexttile;
plot(t_r,r(:,1),'k-','DisplayName','wind (disturbance)',LineWidth=1.5)
title('Wind disturbance')

nexttile;
% Reference value for omega_r
plot(t_r,r(:,2),'k-','DisplayName','Reference',LineWidth=1.5)
hold on;
plot(t,y(:,1),'r-.','DisplayName','Output',LineWidth=2)
title('$\omega_r$')

nexttile;
% Reference value for P_g
plot(t,r(:,3),'k-','DisplayName','Reference',LineWidth=1.5)
hold on;
plot(t,y(:,2),'r-.','DisplayName','Output',LineWidth=2)
title('$P_g$')

saveas(gcf,strcat(save_name,'ref.pdf'))

figure()
tiledlayout(2,1);

nexttile;
% Output and saturated output for 1
plot(t,u(:,1),'b-','DisplayName','$\beta$',LineWidth=2)
hold on;
plot(t,u_hat(:,1),'r-.','DisplayName','$\beta_{sat}$',LineWidth=2)
hold on;
yline(simP.beta_sat(1),'HandleVisibility','off',LineWidth=1.5)
hold on;
yline(simP.beta_sat(2),'HandleVisibility','off',LineWidth=1.5)
limits = calc_y_axis_limits(simP.beta_sat,u(:,1));
ylim(limits)
title('$\beta$ and $\beta_{sat}$')
legend('location','best')

nexttile;
% Output and saturated output for 2
plot(t,u(:,2),'b-','DisplayName','$\alpha$',LineWidth=2)
hold on;
plot(t,u_hat(:,2),'r-.','DisplayName','$\alpha_{sat}$',LineWidth=2)
hold on;
yline(simP.alpha_sat(1),'HandleVisibility','off',LineWidth=1.5)
hold on;
yline(simP.alpha_sat(2),'HandleVisibility','off',LineWidth=1.5)
limits = calc_y_axis_limits(simP.alpha_sat,u(:,2));
ylim(limits)
title('$\alpha$ and $\alpha_{sat}$')
legend('location','best')

saveas(gcf,strcat(save_name,"in.pdf"))

figure()
tiledlayout(2,1);

nexttile;
plot(t,e(:,1),'b-','DisplayName','$e_{\omega_r}$',LineWidth=3)
title('Absolute error $e_{\omega_r}$')

nexttile;
plot(t,e(:,2),'b-','DisplayName','$e_{P_g}$',LineWidth=3)
title('Absolute error $e_{P_g}$')

saveas(gcf,strcat(save_name, 'error.pdf'))
%nexttile;
%plot(t,e(:,1)/y(:,1),'b-.','DisplayName','e omega',LineWidth=3)
%title('Error $e_{\omega_r}$')


%nexttile;
%plot(t,e(:,2)./y(:,2),'b-.','DisplayName','e P_g',LineWidth=3)
%title('Error $e_{P_g}$')


end


function rel_e = calc_relative_error(y,e)
    [col_n,row_n] = size(e);
    rel_e = zeros(size(e));

    for k=1:row_n % for all error (omega_r and P_g)
        for i=1:col_n % for all time points
            if y(i,k) > 1e-10   % if error is high enough we calculate
                rel_e(i,k) = e(i,k)/y(i,k);
            end
        end
    end
end


function limits = calc_y_axis_limits(sat_limits,y)

    limits = [min(min(min(sat_limits,y)))*1.1 max(max(max(sat_limits,y)))*1.1];

end