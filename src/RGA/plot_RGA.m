function plot_RGA(table_tf)

% Query RGA values from table
lambda_11_array = zeros(1,5);
axh = {};
for i=1:5
    lambda_11_array(i) = table_tf.RGA{i}(1,1);
end

% Ploting RGA
fig = figure();
tiledlayout(2,3);

for i=1:5
    nexttile;
    c = gray;
    c = flipud(c);
    axh{i} = heatmap(table_tf.RGA{i},'Colormap', c);
    %axh{i}.CLimMode = 'manual';
    axh{i}.ColorLimits = [0,1];
    axh{i}.Title= string(table_tf.wind_speed(i)) + ' m/s';
    axh{i}.ColorbarVisible = 'off';
    axh{i}.FontSize = 16;
    axh{i}.XLabel = "Output";
    axh{i}.YLabel = "Input";
    %axh{i}.YDisplayLabels = {{'\omega_r'},{'P_g'}};
    %axh{i}.XDisplayLabels = {{'\beta'},{'\alpha'}};
end
nexttile;
plot(lambda_11_array,'+-',"LineWidth",2,"MarkerSize",10);
hold on;
plot(1-lambda_11_array,'+-',"LineWidth",2,"MarkerSize",10);
xlim([1,5])
xticks([1,2,3,4,5])
xticklabels({'6','7','8','9','10'});
xlabel('Windspeed [m/s]','FontSize',16)
ylabel('\lambda_{ii} and \lambda_{ij}','FontSize',16)
lgd = legend({'\lambda_{ii}','\lambda_{ij}'},"FontSize",16);
lgd.Location = "best";

cb = colorbar('Colormap', c);
cb.FontSize = 16;
cb.Layout.Tile = 'east';
end


