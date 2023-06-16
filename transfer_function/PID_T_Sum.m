function PID = PID_T_Sum(G,t_linspace)

[y,t_out] = step(G,t_linspace);

% Get K and plot it
K_t_sum = max(y);


% Find T_sum
N = size(t_out,1); 
delta_A = zeros(1,N);
delta_T = t_out/N;

for n=1:N
    A_1 = sum(y(1:n).*delta_T(1:n));
    A_2 = sum((K_t_sum - y(n:end)).*delta_T(n:end));
    delta_A(n) = abs(A_1-A_2);
end
[~, index_min_delta_A] = min(delta_A);
T_sum = t_out(index_min_delta_A);

% Calculate PID values
PID.K_p = 1/K_t_sum;
PID.T_I = 0.667 * T_sum;
PID.T_D = 0.167 * T_sum;

%% Plot
figure()
plot(t_linspace,y,LineWidth=3);
hold on;
% Plot K
yline(K_t_sum,LineWidth=3);
hold on;
% Plot T_sum 
xline(T_sum,LineWidth=3)
hold off;


end