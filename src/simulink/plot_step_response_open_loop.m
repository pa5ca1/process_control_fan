function plot_step_response_open_loop(y,t_y,u,t_u)

figure()
tiledlayout(2,3);



nexttile;
plot(t_u,u(:,2),'b:','DisplayName','beta',LineWidth=3)
%ylim(calc_axis_limit(u(:,2)));
title('$\beta$')
axis padded
xlim('tight')

nexttile;
plot(t_u,u(:,3),'k-','DisplayName','alpha',LineWidth=3)
%ylim(calc_axis_limit(u(:,3)));
title('$\alpha$')
axis padded
xlim('tight')

nexttile;
plot(t_u,u(:,1),'r--','DisplayName','wind(disturbance)',LineWidth=3)
%ylim(calc_axis_limit(u(:,1)));
title('$v_{wind}$')
axis padded
xlim('tight')

nexttile;
plot(t_y,y(:,1),'r-','DisplayName','omega_r',LineWidth=3)
%ylim(calc_axis_limit(y(:,1)));
title('$\omega_r$')
axis padded
xlim('tight')

nexttile;
plot(t_y,y(:,2),'b-','DisplayName','P_g',LineWidth=3)
%ylim(calc_axis_limit(y(:,2)));
title('$P_g$');
axis padded
xlim('tight')


end