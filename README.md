# Grid-tied inverter simulation and analysis

A program for simulation and analysis of uninterruptible power supply (UPS) systems. Considering an output stage consisting of a half-bridge voltage source inverter (VSI) and output LC filter, it allows evaluating the operation of such electronic device for high-frequency switching and under different load conditions.

<div align="center">
<img width="620" height="248" alt="output_stage_ups" src="https://github.com/user-attachments/assets/a1fe8c03-079d-476c-b0bf-8c1114b15f5c"/>
</div>

The program contains the following file types:
- **MATLAB** scripts for general settings and controller design
- **Simulink** implementation for digital-control simulation
- **PSIM** implementation for power-electronics simulation

Main file named as 'run_ups.m'.