function plot_step_response_open_loop(y,t_y,u,t_u)

figure()
tiledlayout(5,1);

nexttile;
plot(t_u,u(:,1),'r--','DisplayName','wind (disturbance)',LineWidth=3)
%ylim(calc_axis_limit(u(:,1)));
title('Wind disturbance')
nexttile;
plot(t_u,u(:,2),'b:','DisplayName','beta',LineWidth=3)
%ylim(calc_axis_limit(u(:,2)));
title('Beta')
nexttile;
plot(t_u,u(:,3),'y-','DisplayName','alpha',LineWidth=3)
%ylim(calc_axis_limit(u(:,3)));
title('Alpha')

nexttile;
plot(t_y,y(:,1),'r-','DisplayName','omega_r',LineWidth=3)
%ylim(calc_axis_limit(y(:,1)));
title('Omega_r')
nexttile;
plot(t_y,y(:,2),'b-','DisplayName','P_g',LineWidth=3)
%ylim(calc_axis_limit(y(:,2)));
title('P_g');



end