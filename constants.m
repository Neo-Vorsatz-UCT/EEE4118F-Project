% Files
global DATA_DIR; %raw data directory
global D_RAMP; %ramp test
global D_STEP; %normal step test
global D_LIGHT_BRAKING; %light braking step test
global D_HEAVY_BRAKING; %heavy braking step test
global D_HEAVY_DISC; %heavy disc step test
global D_K_TEST; %k-value test
global D_SPEED; %test for speed-voltage ratio
global D_RANDOM_INPUT; %random input test
DATA_DIR = "raw_data";
D_RAMP = "ServoMotorData_ramp.CSV";
D_STEP = "ServoMotorData_step_test.CSV";
D_LIGHT_BRAKING = "light_brake.CSV";
D_HEAVY_BRAKING = "heavy_brake.CSV";
D_HEAVY_DISC = "heavy_disc.CSV";
D_K_TEST = "ServoMotorData_k_value.CSV";
D_SPEED = "ServoMotorData_step_test.CSV";
D_RANDOM_INPUT = "Random Input.CSV";


% Column Labels
global C_TIME;
global C_POSITION;
global C_SETPOINT;
global C_VELOCITY;
global C_INPUT;
C_TIME = "TIME_s_";
C_POSITION = "y_t__Output";
C_SETPOINT = "r_t__SetPoint";
C_VELOCITY = "MotorVelocity";
C_INPUT = "u_t__Input";