function plot_PID_closed_loop(y,e,u,u_hat,r,t)

figure()
tiledlayout(7,1);

% Check if we have constants for reference values
if size(r,1) == 1
    n = size(y,1);
    r = repmat(r,n,1);
    t_r = linspace(0,t(end),n);
else
    t_r = t;
end

nexttile;
plot(t_r,r(:,1),'k--','DisplayName','wind (disturbance)',LineWidth=1.5)
title('Wind disturbance')

nexttile;
% Reference value for omega_r
plot(t_r,r(:,2),'k--','DisplayName','Reference',LineWidth=1.5)
hold on;
plot(t,y(:,1),'r:','DisplayName','Output',LineWidth=3)
title('\omega_r')

nexttile;
% Reference value for P_g
plot(t,r(:,3),'k--','DisplayName','Reference',LineWidth=1.5)
hold on;
plot(t,y(:,2),'r:','DisplayName','Output',LineWidth=3)
title('P_g')

nexttile;
% Output and saturated output for 1
plot(t,u(:,1),'b-.','DisplayName','output_1',LineWidth=3)
hold on;
plot(t,u_hat(:,1),'r:','DisplayName','sat. output_1',LineWidth=3)
title('u_1: beta and saturated beta')

nexttile;
% Output and saturated output for 1
plot(t,u(:,2),'b-.','DisplayName','output_2',LineWidth=3)
hold on;
plot(t,u_hat(:,2),'r:','DisplayName','sat. output_2',LineWidth=3)
title('u_2: alpha and saturated alpha')

nexttile;
plot(t,e(:,1),'b-.','DisplayName','e omega',LineWidth=3)
title('Error \omega_r')


nexttile;
plot(t,e(:,2),'b-.','DisplayName','e P_g',LineWidth=3)
title('Error P_g')


end