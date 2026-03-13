% Generates and saves a plot for the given variable versus time
function plot_raw_data(dependent_var, filename)
    %check if the file exists
    if ~isfile(strcat("raw_data/",filename))
        error('File "raw_data/%s" not found in the current directory.', filename);
    end
    
    %read the file into a table
    try
        disp("start");
        data = readtable(filename);
        disp("end");
        
        %check for the time column (case-insensitive)
        varNames = data.Properties.VariableNames;
        timeIdx = find(strcmpi(varNames, 'TIME(s)'), 1);
        if isempty(timeIdx)
            error('No "time" column found in %s.', filename);
        end
        
        %check if the requested dependent variable exists
        if ismember(dependent_var, varNames)
            %plot the data
            figure('Name', ['File: ' filename]);
            plot(data{:, timeIdx}, data.(dependent_var), 'LineWidth', 1.5, 'Color', [0 0.447 0.741]);
            
            %labeling and Formatting
            grid on;
            xlabel(varNames{timeIdx});
            ylabel(dependent_var);
            title(sprintf('%s vs %s\n(Source: %s)', dependent_var, varNames{timeIdx}, filename));
        else
            error('Column "%s" not found in %s.', dependent_var, filename);
        end
        
    catch ME
        fprintf('An error occurred: %s\n', ME.message);
    end
end

plot_raw_data("y(t)_Output","heavy_brake.CSV");