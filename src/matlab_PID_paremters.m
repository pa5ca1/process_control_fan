function PID_ideal = matlab_PID_paremters(PID)
% Conversion for Simulink PID-block
PID_ideal.P = PID.K_p;
PID_ideal.I =1/PID.T_I;
PID_ideal.D = PID.T_D;
end