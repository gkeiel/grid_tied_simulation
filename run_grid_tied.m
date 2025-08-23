clc; clear; close all;

% controller specifications
n_h   = 3;         % number of resonant modes
xi    = 0;         % damping factor of resonant modes
alpha = 100;       % smallest real part of closed-loop poles 
pnlt  = 3;         % state penalty on guaranteed-cost

% general specifications
load  = 2;         % select load [1 linear, 2 nonlinear]
f     = 60;        % voltage reference frequency [Hz]
fa    = 20040;     % sampling frequency [Hz]
fs    = fa;        % switching frequency [Hz]
Ts    = 1/(20*fa);% fundamental sampling period [s] (simulation step-size)
T     = 1/fa;      % sampling period [s]
t_end = 2;         % simulation time [s]
t_ini = 50/f +1/(4*f); 
t_fin = 70/f +1/(4*f);       

% settings
grid_tied_settings

% controller design and discretization
grid_tied_controller_design

% run simulation
open_system('grid_tied_control')
sim grid_tied_control

% results: figures and tables
grid_tied_results