function [y,t_y,u,t_u,simOut] = simulate_step_response()

simOut = sim('step_response_open_loop','SimulationMode','normal',...
            'SaveState','on','StateSaveName','xout',...
            'SaveOutput','on','OutputSaveName','yout',...
            'SaveFormat', 'Dataset', ...
            'StopTime', 'simP.t_simulation');
% Extract most important values
y = simOut.yout{1}.Values.Data;
t_y = simOut.yout{1}.Values.Time;

u = simOut.yout{3}.Values.Data;
t_u = simOut.yout{3}.Values.Time;

end