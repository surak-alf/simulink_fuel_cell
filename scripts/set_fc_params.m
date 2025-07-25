% set_fc_params.m
% Defines parameters for the fuel_cell_vi_model.slx Simulink model.
% Running this script will make these variables available in the MATLAB workspace.

%% Fuel Cell Stack Parameters
N_cells = 50;     % Number of individual cells in the stack

%% Single Cell Parameters (Empirical Model Coefficients)
E_ocv = 0.9;      % Open Circuit Voltage per cell (V) - Ideal voltage
V_act = 0.05;     % Activation Voltage Loss per cell (V) - Constant for simplicity
R_ohmic = 0.005;  % Ohmic Resistance per cell (Ohms)
A_conc = 0.03;    % Concentration Loss Coefficient (V)
I_limit = 100;    % Limiting Current Density (A) - Where concentration loss becomes dominant

%% Simulation Parameters
% We will sweep current from 0 to I_limit (or slightly below)
I_start_sim = 0;   % Starting current for simulation (A)
I_end_sim = 95;    % Ending current for simulation (A) - Keep slightly below I_limit to avoid ln(0) or ln(negative)
sim_time_duration = 1; % Total simulation duration in seconds (can be short as we're sweeping current)

disp('Fuel Cell Stack Parameters loaded into workspace:');
disp(['  Number of cells (N_cells): ', num2str(N_cells)]);
disp(['  Open Circuit Voltage (E_ocv): ', num2str(E_ocv), ' V']);
disp(['  Activation Loss (V_act): ', num2str(V_act), ' V']);
disp(['  Ohmic Resistance (R_ohmic): ', num2str(R_ohmic), ' Ohms']);
disp(['  Concentration Coeff (A_conc): ', num2str(A_conc), ' V']);
disp(['  Limiting Current (I_limit): ', num2str(I_limit), ' A']);
disp(['  Simulation Current Range: ', num2str(I_start_sim), 'A to ', num2str(I_end_sim), 'A']);
disp(['  Simulation Duration: ', num2str(sim_time_duration), ' s']);