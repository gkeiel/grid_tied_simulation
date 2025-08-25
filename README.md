# Grid-tied inverter simulation and analysis

A program for simulation and analysis of the output stage in grid-connected systems. Considering an grid-tied system consisting of a half-bridge voltage source inverter (VSI) and an output LCL filter, it allows evaluating the operation of such electronic device for high-frequency switching and under different load conditions.

<img width="1593" height="621" alt="grid_tied" src="https://github.com/user-attachments/assets/1dcca810-eb65-4bb0-ab22-f472c2f2aaa3" />

The program contains the following file types:
- **MATLAB** scripts for general settings and controller design
- **Simulink** implementation for digital-control simulation
- **PSIM** implementation for power-electronics simulation

Main file named as 'run_grid_tied.m'.

## Current regulation

The current regulator in grid-connected inverters aims to maintain the current injected to grid at quality levels accepted by standards such as IEEE 1547. One solution for designing such output-current regulators are controllers based on the internal model principle (IMP), which in case of grid-tied inverters yield to the multi-resonant and repetitive controllers.

Consider a proportional-multiple-resonant (PMR) controller with transfer function

$$C(s) = k_{e} +\sum_{i=1,3,\dots}^{h}\frac{k_{{2i-1}} +k_{{2i}}s}{s^{2} +2\xi_{i}\omega_{r_i} s +\omega_{r_i}^{2}}$$

where $k_{e}$, $k_{{2i-1}}$, and $k_{{2i}}$ are gains to be determined, $\xi_{i}$ is the damping factor of the $i$-th resonant mode and $\omega_{r_i}$ the $i$-th multiple of the fundamental frequency $\omega_0$.

An appropriate design of $C(s)$, considering a sufficient number of resonant modes, results in grid-tied controllers allowing to perfectly follow a sinusoidal voltage reference and harmonic frequencies caused by the connection of non-linear loads.