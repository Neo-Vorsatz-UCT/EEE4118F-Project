% Extract data from CSV file
function [dependent_var, time] = get_data(filename, column, t_start, t_end)
    %global variables
    global DATA_DIR;
    global C_TIME;

    %read the CSV into a table
    opts = detectImportOptions(strcat(DATA_DIR,"/",filename));
    tbl = readtable(strcat(DATA_DIR,"/",filename), opts);

    %extract the columns
    time = tbl.(C_TIME);
    dependent_var = tbl.(column);

    %crop data
    if nargin==4
        %create a logical mask for the time range
        %this finds indices where t_start <= time <= t_end
        mask = (time >= t_start) & (time <= t_end);
    
        %apply the mask to crop the data
        time = time(mask);
        dependent_var = dependent_var(mask);
    
        %alert user if no data was found in range
        if isempty(time)
            warning('No data points found within the specified time range.');
        end
    end
end

%% Plot data, possibly as step-response
function plt = plot_data(time, dependent_var, category)
    if category=="response"
        %plot data
        plt = plot(time, dependent_var, 'b', 'LineWidth', 1.5); %plot data

        %calculate Start and Final values
        val_start = dependent_var(1);
        val_final = dependent_var(end);
        total_rise = val_final - val_start;

        %draw horizontal dashed lines for boundaries
        yline(val_start, '--b', string(val_start));
        yline(val_final, '--b', string(val_final));

        %find the Time Constant (63.2% of rise)
        target_y = val_start+(0.632*total_rise);
        
        %find the index where data is closest to the target Y value
        [~, idx] = min(abs(dependent_var - target_y));
        tau_x = time(idx);
        tau_y = dependent_var(idx);

        %annotate the Time Constant coordinate
        plot(tau_x, tau_y, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
        
        %vertical and horizontal lines to the point
        xline(tau_x, '--b', string(tau_x));
        yline(tau_y, '--b', string(tau_y));

    elseif category=="step"
        %plot data
        plt = plot(time, dependent_var, 'r', 'LineWidth', 1.5); %plot data

        %calculate Start and Final values
        val_start = dependent_var(1);
        val_final = dependent_var(end);
        total_rise = val_final - val_start;

        %draw horizontal dashed lines for boundaries
        yline(val_start, '--r', string(val_start));
        yline(val_final, '--r', string(val_final));

        %find the index where the step starts
        target_y = val_start+0.1*total_rise;
        indices = find(dependent_var>target_y);
        start_x = time(indices(1));

        %draw the starting line
        xline(start_x, '--r', string(start_x));
    else
        %plot data
        plt = plot(time, dependent_var, 'k', 'LineWidth', 1.5); %plot data
    end
    
    
end

%% Plot step response
function plot_step(plot_title, y_label, file, t_start, t_end)
    %global variables
    global C_INPUT;
    global C_VELOCITY;

    %initialise figure
    figure;
    grid on;
    title(plot_title);
    xlabel('Time (s)');
    ylabel(y_label);
    hold on;

    %plot input step
    [y,x] = get_data(file, C_INPUT, t_start, t_end);
    input_step = plot_data(x, y, "step");

    %plot step response
    [y,x] = get_data(file, C_VELOCITY, t_start, t_end);
    velocity_response = plot_data(x, y, "response");

    %end
    legend([input_step, velocity_response], {"Input Step", "Velocity"});
    hold off;
end

%% Plot many graphs
function plot_many(plot_title, y_label, legend_names, colors, file, columns, t_start, t_end)
    %initialise figure
    figure;
    grid on;
    title(plot_title);
    xlabel('Time (s)');
    ylabel(y_label);
    hold on;

    %for each plot
    plts = gobjects(length(columns), 1);
    for i = 1:length(columns)
        [y,x] = get_data(file, columns{i}, t_start, t_end);
        plts(i) = plot_data(x, y, "other");
        plts(i).Color = colors(i);
    end

    %end
    legend(plts, legend_names);
    % hold off;
end

%% Plotting ramp response for deadband
function plot_ramp(plot_title, y_label, t_start, t_end)
    %global variables
    global D_RAMP;
    global C_INPUT;
    global C_VELOCITY;

    %initialise figure
    figure;
    grid on;
    title(plot_title);
    xlabel('Time (s)');
    ylabel(y_label);
    hold on;

    %plot input step
    [y,x] = get_data(D_RAMP, C_INPUT, t_start, t_end);
    input_ramp = plot_data(x, y, "other");
    input_ramp.Color = 'r';

    %plot step response
    [y,x] = get_data(D_RAMP, C_VELOCITY, t_start, t_end);
    velocity_response = plot_data(x, y, "other");
    velocity_response.Color = 'b';

    %label important lines
    xline(28.6, '--b', string(28.6));
    xline(54.4, '--b', string(54.4));
    yline(-0.856, '--r', string(-0.856));
    yline(0.176, '--r', string(0.176));

    %end
    legend([input_ramp, velocity_response], {"Input Ramp", "Velocity"});
    hold off;
end

%% Plotting velocity and position to get k
function plot_k_test(plot_title, y_label, t_start, t_end)
    %global variables
    global D_K_TEST;
    global C_VELOCITY;
    global C_POSITION;

    %initialise figure
    figure;
    grid on;
    title(plot_title);
    xlabel('Time (s)');
    ylabel(y_label);
    hold on;

    %plot input step
    [y_v,x] = get_data(D_K_TEST, C_VELOCITY, t_start, t_end);
    const_vel = plot_data(x, y_v, "other");
    const_vel.Color = 'b';

    %plot step response
    [y_p,x] = get_data(D_K_TEST, C_POSITION, t_start, t_end);
    pos_response = plot_data(x, y_p, "other");
    pos_response.Color = 'g';

    %label important lines
    yline(0.568, '--b', 0.568);
    xline(1.4, '--r', string(1.4));
    xline(3.8, '--r', string(3.8));
    yline(-0.708, '--r', string(-0.708));
    yline(9.932, '--r', string(9.932));
    
    %end
    legend([const_vel, pos_response], {"Velocity", "Position"});
    hold off;
end

%% Plotting random response for random input
function plot_random(plot_title, y_label, t_start, t_end)
    %global variables
    global D_RANDOM_INPUT;
    global C_INPUT;
    global C_VELOCITY;

    %initialise figure
    figure;
    grid on;
    title(plot_title);
    xlabel('Time (s)');
    ylabel(y_label);
    hold on;

    %plot input step
    [y,x] = get_data(D_RANDOM_INPUT, C_INPUT, t_start, t_end);
    input = plot_data(x, y, "other");
    input.Color = 'r';

    %plot step response
    [y,x] = get_data(D_RANDOM_INPUT, C_VELOCITY, t_start, t_end);
    velocity = plot_data(x, y, "other");
    velocity.Color = 'b';

    %end
    legend([input, velocity], {"Random Input", "Velocity"});
    hold off;
end

%% Run
% plot_step("Heavy Braking Step Response", "Amplitude (V)", ...
    % D_HEAVY_BRAKING, 17, 19);
% plot_ramp("Ramp Test", "Amplitude (V)", ...
    % 20, 70);
% plot_k_test("Position with Constant Velocity", "Amplitude (V)", ...
    % 1.4, 5);
plot_random("Response for Random Input", "Amplitude (V)", ...
    4, 32);
