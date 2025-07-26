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