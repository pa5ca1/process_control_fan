function [y,e,u,u_hat,r,t,simOut] = simulate_PID_closed_loop()

simOut = sim('closed_loop_PID','SimulationMode','normal',...
            'SaveState','on','StateSaveName','xout',...
            'SaveOutput','on','OutputSaveName','yout',...
            'SaveFormat', 'Dataset', ...
            'StopTime', 'simP.t_simulation');

% Extract most important values
y = simOut.yout{1}.Values.Data;
t = simOut.yout{1}.Values.Time;

e1 = simOut.yout{2}.Values.Data(:,1);
u1 = simOut.yout{2}.Values.Data(:,2);
u1_sat = simOut.yout{2}.Values.Data(:,3);

e2 = simOut.yout{2}.Values.Data(:,4);
u2 = simOut.yout{2}.Values.Data(:,5);
u2_sat = simOut.yout{2}.Values.Data(:,6);

e = [e1,e2];
u = [u1,u2];
u_hat = [u1_sat,u2_sat];

r = simOut.yout{3}.Values.Data;

end