function PID = T_Sum_design(G,t_linspace,plot_bool)


[y,t_out] = step(G,t_linspace);

% Get K and plot it
K = max(y);


% Find T_sum
N = size(t_out,1);
delta_A = zeros(1,N);
delta_T = gradient(t_out);

%figure()
for n=1:N
    T_sum = t_out(n);
    T_delta = t_out(end)-T_sum;

    A_1 = sum(y(1:n).*delta_T(1:n));
%    A_1_hat = K*T_sum - A_1;
    
    A_2_hat = sum(y(n+1:end).*delta_T(n+1:end));
    A_2 = K*T_delta - A_2_hat;
    
    delta_A(n) = abs(A_1-A_2);
%    scatter(n,A_1+A_1_hat,'d')
%    hold on;
%    scatter(n,A_2+A_2_hat,'*');
%    hold on;
%    scatter(n,A_1+A_2,'+');
%    hold on;
end
[~, index_min_delta_A] = min(delta_A);
T_sum = t_out(index_min_delta_A);

% Calculate PID values
PID.K_p = 1/K;
PID.T_I = 0.667 * T_sum;
PID.T_D = 0.167 * T_sum;

%% Plot
if plot_bool
    figure()
    plot(t_out,y,'DisplayName','Original tf',LineWidth=3);
    hold on;
    % Plot K
    yline(K,'--','HandleVisibility','off',LineWidth=3);
    hold on;
    % Plot T_sum
    xline(T_sum,'--','HandleVisibility','off',LineWidth=3)
    hold off;
end

end