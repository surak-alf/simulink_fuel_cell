# Simulink Fuel Cell Stack V-I and P-I Characteristic Model

This project contains a simple Simulink model and associated MATLAB scripts to simulate and analyze the Voltage-Current (V-I) and Power-Current (P-I) characteristics of a Proton Exchange Membrane (PEM) Fuel Cell Stack. This serves as a foundational project for understanding hydrogen-based propulsion systems.

## Project Structure

The project is organized into the following directories:
``````
simulink_fuel_cell/
├── models/
│   └── fuel_cell_vi_model.slx
├── scripts/
│   ├── analyze_fc_vi.m
│   └── set_fc_params.m
└── results/
├── fc_pi_curve.png  (Generated after running analyze_fc_vi.m)
└── fc_vi_curve.png  (Generated after running analyze_fc_vi.m)

``````
## Files Included

* `models/fuel_cell_vi_model.slx`: The Simulink model that simulates the fuel cell stack's V-I characteristics based on an empirical model.
* `scripts/set_fc_params.m`: A MATLAB script to define all the necessary parameters for the fuel cell model.
* `scripts/analyze_fc_vi.m`: A MATLAB script to load simulation results, calculate power, plot V-I and P-I curves, and identify the Maximum Power Point (MPP).

## Mathematical Model (Empirical)

The model for a single fuel cell's voltage ($V_{cell}$) is based on a common empirical formula that accounts for open-circuit voltage and three main types of voltage losses: Activation, Ohmic, and Concentration losses.

$V_{cell} = E_{ocv} - V_{act} - (I_{cell} \cdot R_{ohmic}) - A \cdot \ln(1 - \frac{I_{cell}}{I_{limit}})$

Where:
* $V_{cell}$: Output voltage of a single fuel cell (Volts)
* $E_{ocv}$: Open Circuit Voltage (Ideal cell voltage, V)
* $V_{act}$: Activation Voltage Loss (V) - Treated as a constant.
* $I_{cell}$: Cell Current (Amperes) - Input to the model.
* $R_{ohmic}$: Ohmic Resistance (Ohms) - Per cell.
* $A$: Concentration Loss Coefficient (V) - Empirical constant.
* $I_{limit}$: Limiting Current Density (Amperes) - Where concentration loss becomes severe.

For a stack of $N_{cells}$ cells in series, the stack voltage ($V_{stack}$) is:
$V_{stack} = N_{cells} \cdot V_{cell}$

And the stack current ($I_{stack}$) is equal to the cell current:
$I_{stack} = I_{cell}$

## Model Parameters

The following parameters are defined in `scripts/set_fc_params.m` and used by the Simulink model and analysis script:

| Parameter Name        | Description                                  | Default Value | Unit   |
| :-------------------- | :------------------------------------------- | :------------ | :----- |
| `N_cells`             | Number of individual cells in the stack      | `50`          | -      |
| `E_ocv`               | Open Circuit Voltage per cell                | `0.9`         | V      |
| `V_act`               | Activation Voltage Loss per cell             | `0.05`        | V      |
| `R_ohmic`             | Ohmic Resistance per cell                    | `0.005`       | Ohms   |
| `A_conc`              | Concentration Loss Coefficient               | `0.03`        | V      |
| `I_limit`             | Limiting Current Density                     | `100`         | A      |
| `I_start_sim`         | Starting current for simulation ramp         | `0`           | A      |
| `I_end_sim`           | Ending current for simulation ramp           | `95`          | A      |
| `sim_time_duration`   | Total simulation duration (for current sweep)| `1`           | seconds|

## Project Workflow / Flowchart

The typical workflow for this project involves a sequence of MATLAB script executions and Simulink model simulation:

1.  **Define Parameters:**
    * **Action:** Run `scripts/set_fc_params.m`.
    * **Output:** Fuel cell model parameters (e.g., `N_cells`, `E_ocv`, `R_ohmic`) are loaded into the MATLAB workspace.

2.  **Simulate Fuel Cell Model:**
    * **Action:** Open and run `models/fuel_cell_vi_model.slx`.
    * **Input:** Current ($I_{cell}$) is swept over time using a `Ramp` block, defined by `I_start_sim` and `I_end_sim`.
    * **Process:** The Simulink model calculates $V_{cell}$ and then $V_{stack}$ based on the empirical formula and loaded parameters.
    * **Output:** Simulation results ($I_{cell}$ as `fc_current` and $V_{stack}$ as `fc_voltage`) are logged to the MATLAB workspace within the `out` object (i.e., `out.fc_current`, `out.fc_voltage`).

3.  **Analyze Results & Generate Plots:**
    * **Action:** Run `scripts/analyze_fc_vi.m`.
    * **Input:** Data from the `out` object (`out.fc_current`, `out.fc_voltage`) from the MATLAB workspace.
    * **Process:**
        * Calculates stack power ($P_{stack} = V_{stack} \times I_{stack}$).
        * Finds the Maximum Power Point (MPP).
        * Generates V-I and P-I characteristic plots.
    * **Output:**
        * Calculated MPP details displayed in the MATLAB Command Window.
        * Two interactive figure windows displaying the V-I and P-I curves.
        * `.png` image files of the plots saved in the `results/` directory (`fc_vi_curve.png`, `fc_pi_curve.png`).

Project Workflow Diagram:
``````
+--------------------------+     +--------------------------+     +--------------------------+
| 1. set_fc_params.m       |     | 2. fuel_cell_vi_model.slx|     | 3. analyze_fc_vi.m       |
| (Defines Parameters)     |---->| (Simulates V-I Curve)    |---->| (Analyzes & Plots)       |
+--------------------------+     +--------------------------+     +--------------------------+
|                           | Output to Workspace:             | Input from Workspace:
|                           |   'out' object (containing       |   'out.fc_current'
V                           |   fc_current, fc_voltage)        |   'out.fc_voltage'
MATLAB Workspace:           MATLAB Workspace:                  MATLAB Workspace:

    N_cells                   - out.fc_current                   - (Calculates fc_power)

    E_ocv                     - out.fc_voltage                   - (Finds MPP)

    ...etc.                   - out.tout                         Output:
    - V-I Plot (figure & .png)
    - P-I Plot (figure & .png)
    - MPP details (Command Window)
``````    
