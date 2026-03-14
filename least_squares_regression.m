% Least squares regression

%read the CSV into a table
opts = detectImportOptions("raw_data/Random Input.CSV");
tbl = readtable("raw_data/Random Input.CSV", opts);

%extract the data
time = tbl.("TIME_s_");
vel = tbl.("MotorVelocity");
input = tbl.("u_t__Input");

%create integrals
int_vel = cumsum(vel);
int_input = cumsum(input);

%generate matrices
resultant = int_vel;
transform = zeros(length(int_vel),3);
transform(:,1) = int_input;
transform(:,2) = vel;
transform(:,3) = 1.-time;

%get solution
solution = pinv(transform)*resultant;
disp(solution);