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

The typical workflow for this project involves a sequence of MATLAB script executions and Simulink model simulation. This diagram illustrates the flow of data and control.

``````mermaid
graph TD
    A[Start] --> B(Run set_fc_params.m);
    B --> C{Parameters Loaded in MATLAB Workspace};
    C --> D[Open fuel_cell_vi_model.slx];
    D --> E(Run Simulink Model);
    E --> F{Simulation Output 'out' Object in Workspace};
    F -- Contains fc_current, fc_voltage, tout --> G[Run analyze_fc_vi.m];
    G --> H{Extract Data from 'out' Object};
    H --> I(Calculate Power & MPP);
    I --> J[Generate V-I & P-I Plots];
    J --> K(Display Plots & Save to results/);
    K --> L[End];
``````


## Simulation Results

Here are the characteristic curves generated by the simulation and analysis script. These plots are saved as `.png` files in the `simulink_fuel_cell/results/` directory after a successful simulation and analysis run.

### Fuel Cell Stack V-I Characteristic Curve
![Fuel Cell Stack Voltage-Current Characteristic Curve](simulink_fuel_cell/results/fc_vi_curve.png)

### Fuel Cell Stack P-I Characteristic Curve
![Fuel Cell Stack Power-Current Characteristic Curve](simulink_fuel_cell/results/fc_pi_curve.png)

## Getting Started

To run this project, you will need MATLAB with Simulink.

1.  **Clone or Download the Repository:**
    If you're using Git, clone the repository to your local machine:
    ```bash
    git clone [https://github.com/surak-alf/simulink_fuel_cell] simulink_fuel_cell
    ```
    Alternatively, download the project ZIP file and extract it.

2.  **Open the Project in MATLAB:**
    * Launch MATLAB.
    * In the MATLAB "Current Folder" pane, navigate to the `simulink_fuel_cell` directory.

## How to Run the Simulation and Analysis

Follow these steps precisely to ensure the correct execution order and data transfer:

1.  **Clear Workspace:**
    * In the MATLAB Command Window, type `clear all` and press Enter.
    * Type `clc` and press Enter.

2.  **Load Parameters:**
    * Navigate to the `simulink_fuel_cell/scripts` folder in MATLAB's "Current Folder" pane.
    * In the MATLAB Command Window, type `set_fc_params` and press Enter.
    * **Verify:** Check your MATLAB "Workspace" pane to confirm that variables like `N_cells`, `E_ocv`, `I_limit`, etc., are loaded.

3.  **Run Simulink Model:**
    * Navigate to the `simulink_fuel_cell/models` folder in MATLAB's "Current Folder" pane.
    * Double-click `fuel_cell_vi_model.slx` to open the model.
    * In the Simulink Editor, click the **"Run"** button (green play triangle).
    * **Verify:** After the simulation completes, check your MATLAB "Workspace" pane. You should see an `out` variable (of type `Simulink.SimulationOutput`). The `fc_current` and `fc_voltage` data will be stored *inside* this `out` object.

4.  **Analyze Results:**
    * Navigate back to the `simulink_fuel_cell/scripts` folder in MATLAB's "Current Folder" pane.
    * In the MATLAB Command Window, type `analyze_fc_vi` and press Enter.
    * **Observe:**
        * Output messages will appear in the Command Window, including the Maximum Power Point.
        * Two MATLAB Figure windows will pop up, displaying the Fuel Cell Stack V-I Characteristic and P-I Characteristic curves.
        * Two `.png` image files (`fc_vi_curve.png` and `fc_pi_curve.png`) will be saved in the `simulink_fuel_cell/results/` folder.

## Troubleshooting

* **"Error: Simulation results (fc_current, fc_voltage) not found in workspace..."**: This usually means the Simulink model wasn't run, or `clear all` was executed *after* the simulation but *before* the analysis script. Ensure the execution order from "How to Run" is followed.
* **"MATLAB Error: Dot indexing is not supported for variables of this type."**: This indicates that `fc_current` and `fc_voltage` are directly saved as numeric arrays within the `out` object, rather than `timeseries` objects with a `.Data` property. The `analyze_fc_vi.m` script provided in the final successful version of this project handles this by directly accessing `out.fc_current` and `out.fc_voltage`.
* **"Error using plot Data cannot have more than 2 dimensions."**: This means the data arrays are not simple vectors. The `squeeze()` function, applied in `analyze_fc_vi.m`, handles this by removing any singleton dimensions (e.g., converting `Nx1x1` to `Nx1`).
* **"Division by zero in 'fuel_cell_vi_model/Divide'" or "Log of a negative number in 'fuel_cell_vi_model/Math Function'"**: These are numerical warnings. The `Divide` block is addressed by using the dedicated `Divide` block in Simulink, and the `Math Function (log)` is made robust by ensuring its input is always positive using a `MinMax` block with a small positive lower limit (e.g., `1e-9`).

## Next Steps

This simple model can be extended in many ways:
* Adding temperature dependence to the empirical model parameters.
* Implementing a simple load (e.g., a resistor or a constant power demand).
* Developing a dynamic model that considers gas flow and pressure changes.
* Integrating a basic battery model for a hybrid power source.