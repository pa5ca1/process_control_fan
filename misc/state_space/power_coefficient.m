function C_p = power_coefficient(lambda,beta,lookup)
%% Using a lookup table

% Make shure beta is an integer
beta = round(beta);
% We only use rows with corresponding beta value
%lookup = lookup(lookup.beta == beta,:);


% Interpolation
% When using 3D data
%c_p = griddata(lookup.lambda,lookup.beta,lookup.C_p,lambda,beta);
% When using 2D data
C_p = interp1(lookup.lambda(lookup.beta==beta),lookup.C_p(lookup.beta==beta),lambda);


end