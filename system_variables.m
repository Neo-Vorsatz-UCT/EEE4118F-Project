% Advanced Model
p = 1; %Potentiometer: radians to volts
a = 1; %Tachometer: radians/s to volts
A_0 = 1; %First-order amplitude
T_0 = 1; %First-order time constant

% Simplified Model
A = A_0*a; %First-order amplitude
T = T_0; %First-order time constant
k = p/30; %Integrator coefficient