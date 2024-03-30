# Embers, Wind and Fire
by Jasmine Tai and Ananthajit ("Ananth") Srikanth

Report and code for a joint project in Applied Mathematics. You can find the report in this repository, or [here](https://drive.google.com/file/d/13_ZaqgONs5WBLl_1vnZ-ieGU_eXFDKRk/view?usp=drive_link).

# Sections

## Embers

The main ember code results can be obtained by running `python3 ember_analysis.py` and then running `surfplot.m` in MATLAB.
Additional qualitative code is in the `extras` subfolder. Unzip `embers/extras/data/data.zip` into the `data` folder before running `plotter.m`.
Parameters can be tweaked in `setup_module.init`.

## Wind 
Run `fire_driver.m` for basic examples of fire propagation for different `w` and `theta`. Run `fire_driver_comp.m` for a qualitative comparison between different pairs of `p_0` and `w`, as well as a quantitative result depicting counts of cells with over 0.9+ value over time for different `w`.

`fire_driver_validate.m` houses the two validation tests for wind.

## Combined Model

Run `python3 ember_wind_analysis.py` and `surfplot.m` for the quantitative analysis, and `python3 gridplot.py` for the qualitative analysis.