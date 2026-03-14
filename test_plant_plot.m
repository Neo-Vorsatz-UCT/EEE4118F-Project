% Plot simulation versus measurement

%set variables
filename = D_STEP;
t_start = 24;
t_end = 40;

%read the CSV into a table
opts = detectImportOptions(strcat(DATA_DIR,"/",filename));
tbl = readtable(strcat(DATA_DIR,"/",filename), opts);

%extract the columns
time = tbl.(C_TIME);
velocity = tbl.(C_VELOCITY);

%cropping data
mask = (out.simulated_data.Time >= t_start) & (out.simulated_data.Time <= t_end);
simulated_data = timeseries(out.simulated_data.DATA(mask),out.simulated_data.TIME(mask));
mask = (time >= t_start) & (time <= t_end);
measured_data = timeseries(velocity(mask), time(mask));

%plotting
figure;
plot(simulated_data, 'k--', 'LineWidth', 1.5);
hold on;
plot(measured_data, 'b-', 'LineWidth', 1.5);
grid on;
legend('Simulated', 'Measured');
xlabel('Time (s)');
ylabel('Velocity (V)');
title('Measured vs. Simulated Heavy Braking Step Response');