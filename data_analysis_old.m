% Extracts and crops data
function [dependent_var, time] = get_data(filename, column, t_start, t_end)
    %global variables
    global DATA_DIR;
    global C_TIME;

    %check if the file exists
    if ~isfile(strcat(DATA_DIR,"/",filename))
        error('File "%s/%s" not found in the current directory.', DATA_DIR, filename);
    end

    %read the file into a table
    data = readtable(strcat(DATA_DIR,"/",filename), 'NumHeaderLines', 1);

    %check for the time column (case-insensitive)
    varNames = data.Properties.VariableNames;
    timeIdx = find(strcmpi(varNames, C_TIME), 1);
    if isempty(timeIdx)
        error('No "time" column found in %s.', filename);
    end

    %crop data
    if nargin >= 4 %if the number of input arguments are at least 4
        %extract time column for comparison
        timeValues = data{:, timeIdx};
        
        %create a logical mask: true for rows within the range
        %formula: $tStart \le t \le tEnd$
        keepRows = (timeValues>=t_start)&(timeValues<=t_end);
        
        %apply the mask to the table
        data = data(keepRows, :);
        
        if isempty(data)
            warning('No data points found in the range %g to %g.', t_start, t_end);
            return;
        end
    end

    %output
    dependent_var;
    time = data{:, timeIdx};
end

% Generates and saves a plot for the given variable versus time
function plot_raw_data(filename, dependent_var, dependent_label, t_start, t_end)
    
    
    %check if the requested dependent variable exists
    if ismember(dependent_var, varNames)
        %plot the data
        % figure('Name', ['File: ' filename]);
        figure; %//
        plot(data{:, timeIdx}, data.(dependent_var), 'LineWidth', 1.5, 'Color', [0 0.447 0.741]);
        
        %labeling and formatting
        grid on;
        xlabel("Time (s)");
        ylabel(dependent_label);
        title(sprintf('%s vs %s', dependent_label, "Time"));
    else
        error('Column "%s" not found in %s.', dependent_var, filename);
    end 
end

function

plot_raw_data(D_STEP, C_VELOCITY, "Velocity", 24, 40);