% grid parameters
Vo_rms  = 127;          % RMS output voltage
Vo_pk   = 127*sqrt(2);  % peak output voltage
Vg_pk   = 127*sqrt(2);  % peak grid voltage
Io1_pk  = 10*sqrt(2);   % reference peak current 1
Io3_pk  = Io1_pk*0.86;  % reference peak current 3
Io5_pk  = Io1_pk*0.62;  % reference peak current 3
f_g     = f;            % grid frequency
theta_g = 0;            % grid initial phase

% hardware parameters (PSIM)
S_nom = 3500;           % nominal aparent power [VA]
P_nom = S_nom*0.7;      % nominal active power [W]
V_in  = 320;            % 3-ph source voltage
V_cc  = 520;            % DC link voltage
C_cc  = 6600e-6;        % DC link capacitance
V_tri = V_cc/2;         % triangular peak voltage
V_sat = V_cc/2;
u0    = V_cc/2;         % satturation limit
V_ma  = Vo_rms*1.1; 
V_mi  = Vo_rms*0.9;
K_pwm = V_cc/(2*V_sat); % PWM gain
Cf    = 3*10^(-4);
Lf    = 1*10^(-3);
Rlf   = 15*10^(-3);
Lg_max = 0.001;
Lg_min = 0.001;
Rg     = 0.02;
switch load
    case 1
        CLinear  = 1;   % 1 - linear load on         
        CNLinear = 0;   % 0 - nonlinear load off
    case 2
        CLinear  = 0;   % 0 - linear load off          
        CNLinear = 1;   % 1 - nonlinear load on
end

% linear and nonlinear load parameters
Rlin1   = Vo_rms^2/(P_nom*0.2);             % resistor 1º linear load
Rlin2   = Vo_rms^2/(P_nom*0.8);             % resistor 2º linear load
Rsnlin1 = 0.04*(Vo_rms)^2/(S_nom*1/4);
Rsnlin2 = 0.04*(Vo_rms)^2/(S_nom*3/4);
Rnlin1  = (1.22*Vo_rms)^2/(0.66*1/4*S_nom);
Rnlin2  = (1.22*Vo_rms)^2/(0.66*3/4*S_nom);
Cnlin1  = 7.5/(f*Rnlin1);
Cnlin2  = 7.5/(f*Rnlin2);
VCap    = 150;                              % capacitors initial voltage

% save parameters to grid_tied_parameters.txt
disp('import parameters to grid_tied_parameters.txt');
fid = fopen([cd '\grid_tied_parameters.txt'], 'w');
fprintf(fid,['Ts=',num2str(Ts)]);
fprintf(fid,['\nt_end=',num2str(t_end)]);
fprintf(fid,['\nfs=',num2str(fs)]);
fprintf(fid,['\nV_in=',num2str(V_in)]);
fprintf(fid,['\nV_cc=',num2str(V_cc)]);
fprintf(fid,['\nC_cc=',num2str(C_cc)]);
fprintf(fid,['\nV_tri=',num2str(V_tri)]);
fprintf(fid,['\nK_pwm=',num2str(K_pwm)]);
fprintf(fid,['\nLf=',num2str(Lf)]);
fprintf(fid,['\nRlf=',num2str(Rlf)]);
fprintf(fid,['\nCf=',num2str(Cf)]);
fprintf(fid,['\nLg=',num2str(Lg_max)]);
fprintf(fid,['\nRg=',num2str(Rg)]);
fprintf(fid,['\nf=',num2str(f)]);
fprintf(fid,['\nVg_pk=',num2str(Vg_pk)]);
fprintf(fid,['\nf_g=',num2str(f_g)]);
fprintf(fid,['\ntheta_g=',num2str(theta_g)]);
fprintf(fid,['\nRlin1=',num2str(Rlin1)]);
fprintf(fid,['\nRlin2=',num2str(Rlin2)]);
fprintf(fid,['\nRsnlin1=',num2str(Rsnlin1)]);
fprintf(fid,['\nRsnlin2=',num2str(Rsnlin2)]);
fprintf(fid,['\nRnlin1=',num2str(Rnlin1)]);
fprintf(fid,['\nRnlin2=',num2str(Rnlin2)]);
fprintf(fid,['\nCnlin1=',num2str(Cnlin1)]);
fprintf(fid,['\nCnlin2=',num2str(Cnlin2)]);
fprintf(fid,['\nVCap=',num2str(VCap)]);
fclose(fid);