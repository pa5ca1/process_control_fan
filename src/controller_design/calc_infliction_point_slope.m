function [slope, intcpt] = calc_infliction_point_slope(y,t)

%% Find the inflection point and tangent
% Source: https://de.mathworks.com/matlabcentral/answers/295156-how-to-find-the-inflection-point-of-a-curve-in-matlab
% gradient of step response
dydt = gradient(y);
% Find y and t of highest gradient
% Get only the unique values
[dydt,i_unique,~] = unique(dydt,'stable');
t_out = t(i_unique);
y_out = y(i_unique);

t_infl = interp1(dydt, t_out, max(dydt));
y_infl = interp1(t_out, y_out, t_infl);
% Calculate slope
slope  = interp1(t_out, dydt, t_infl);
% Find y-interception
intcpt = y_infl - slope*t_infl;


end