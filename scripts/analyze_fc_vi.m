% analyze_fc_vi.m
% This script analyzes the simulation results from fuel_cell_vi_model.slx
% and generates Fuel Cell Voltage-Current (VI) and Power-Current (PI) curves.
% It is now adapted to retrieve data from the 'out' Simulink.SimulationOutput object.

% Clear specific variables from previous runs of THIS script, but keep 'out'
% from the Simulink simulation, as well as parameter variables if they are used.
clearvars -except out; % We only need 'out' here as the source of data

%% 1. Check for Simulation Output
% Check if simulation output 'out' exists in workspace and is the correct type
if ~exist('out', 'var') || ~isa(out, 'Simulink.SimulationOutput')
    disp('Error: Simulink simulation output ''out'' not found in workspace, or is not a Simulink.SimulationOutput object.');
    disp('Please ensure the Simulink model (fuel_cell_vi_model.slx) was run successfully before running this script.');
    return;
end

% --- CORRECTED DATA EXTRACTION START ---
% Access the logged signals from the 'out' object directly by their 'To Workspace' block names.
% Based on your workspace inspection, these are direct properties of the 'out' object.
% The 'To Workspace' blocks typically log data as 'timeseries' objects when part of the
% 'out' structure, even if 'Array' format was selected in the block.
% We need to extract their 'Data' property.
try
    fc_current = squeeze(out.fc_current);
    fc_voltage = squeeze(out.fc_voltage);
catch ME
    disp('Error: Could not find fc_current or fc_voltage data within the ''out'' object.');
    disp('Please ensure:');
    disp('  1. The "To Workspace" blocks in your Simulink model have Variable names set to ''fc_current'' and ''fc_voltage''.');
    disp('  2. The Simulink model was saved and re-run after making any changes to these blocks.');
    disp(['MATLAB Error: ', ME.message]);
    return;
end

% Verify if data was actually extracted (check for empty arrays after extraction)
if isempty(fc_current) || isempty(fc_voltage)
    disp('Error: fc_current or fc_voltage data extracted from ''out'' is empty.');
    disp('This could happen if the simulation ran for 0 time, or the To Workspace blocks did not capture data.');
    return;
end
% --- CORRECTED DATA EXTRACTION END ---

disp('--- Fuel Cell VI/PI Curve Analysis ---');

%% 2. Calculate Power
% Power (P) = Voltage (V) * Current (I)
fc_power = fc_voltage .* fc_current; % Element-wise multiplication

%% 3. Plotting the VI Characteristic Curve
figure; % Create a new figure window for VI curve
plot(fc_current, fc_voltage, 'LineWidth', 1.5, 'Color', 'b'); % Blue line
grid on;
xlabel('Stack Current (A)', 'FontSize', 12);
ylabel('Stack Voltage (V)', 'FontSize', 12);
title('Fuel Cell Stack V-I Characteristic Curve', 'FontSize', 14);
set(gca, 'FontSize', 10);
set(gcf, 'Color', 'w'); % Set figure background to white

%% 4. Plotting the PI Characteristic Curve
figure; % Create a new figure window for PI curve
plot(fc_current, fc_power, 'LineWidth', 1.5, 'Color', 'r'); % Red line
grid on;
xlabel('Stack Current (A)', 'FontSize', 12);
ylabel('Stack Power (W)', 'FontSize', 12);
title('Fuel Cell Stack P-I Characteristic Curve', 'FontSize', 14);
set(gca, 'FontSize', 10);
set(gcf, 'Color', 'w'); % Set figure background to white

%% 5. Find Maximum Power Point (MPP)
[max_power, idx_max_power] = max(fc_power);
current_at_mpp = fc_current(idx_max_power);
voltage_at_mpp = fc_voltage(idx_max_power);

disp(['Maximum Stack Power: ', num2str(max_power), ' W']);
disp(['  at Current: ', num2str(current_at_mpp), ' A']);
disp(['  at Voltage: ', num2str(voltage_at_mpp), ' V']);

% Optionally, mark MPP on the PI curve plot
figure(2); % Activate the PI curve figure
hold on;
plot(current_at_mpp, max_power, 'go', 'MarkerSize', 8, 'LineWidth', 2); % Green circle marker
text(current_at_mpp + 5, max_power, ['  MPP: ', num2str(max_power, '%.1f'), ' W'], ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 10, 'Color', 'k');
hold off;

%% 6. Save Plots to Results Folder
% Get the path to the results folder
currentScriptPath = fileparts(mfilename('fullpath'));
resultsPath = fullfile(currentScriptPath, '..', 'results');

% Check if results folder exists, create if not
if ~isfolder(resultsPath)
    mkdir(resultsPath);
    disp(['Created results folder: ', resultsPath]);
end

% Save VI curve plot
plotFilename_VI = fullfile(resultsPath, 'fc_vi_curve.png');
try
    saveas(figure(1), plotFilename_VI); % Save the first figure (VI curve)
    disp(['VI curve plot saved to: ', plotFilename_VI]);
catch ME
    disp(['Error saving VI plot: ', ME.message]);
end

% Save PI curve plot
plotFilename_PI = fullfile(resultsPath, 'fc_pi_curve.png');
try
    saveas(figure(2), plotFilename_PI); % Save the second figure (PI curve)
    disp(['PI curve plot saved to: ', plotFilename_PI]);
catch ME
    disp(['Error saving PI plot: ', ME.message]);
end

disp('Analysis complete.');