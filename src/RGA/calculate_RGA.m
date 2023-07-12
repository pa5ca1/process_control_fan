function RGA = calculate_RGA(G_S_numerator)
% Computation of RGA
% See p. 123 in [2]
lambda_11 = G_S_numerator{1,1}/(G_S_numerator{1,1} - (G_S_numerator{1,2}*G_S_numerator{2,1})/G_S_numerator{2,2} );
RGA = [[lambda_11, 1-lambda_11];[1-lambda_11,lambda_11]];
end