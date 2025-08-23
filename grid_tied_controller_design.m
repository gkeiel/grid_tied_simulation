% controller design


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plant model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% grid-tied inverter parameters
Rlf    = 0.015;
Lf     = 0.001;
Cf     = 0.0003;
Lg_max = 0.001;
Lg_min = 0.001;
Rg     = 0.02;
Kpwm   = 1;

% uncertain model
A_max = [-Rlf/Lf  -1/Lf       0;
         1/Cf      0         -1/Cf;
         0         1/Lg_max  -Rg/Lg_max];
A_min = [-Rlf/Lf  -1/Lf       0;
         1/Cf      0         -1/Cf;
         0         1/Lg_min  -Rg/Lg_min];
B    = [1/Lf; 0; 0];
B_d  = [0; 0; -1/Lg_max];
C    = [0  0  1];
D    = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMP controller model %%%%%%%%%%%%%%%%%%%%%%%%% 
A_r = [];
B_r = [];
B_R = [0; 1];
for k = 1:n_h
    
    wr = 2*pi*f*(2*k -1);
    wr = (2/T)*tan(wr*T/2);     % prewarping   
    if (k == 1)
        A_R = [0 wr; -wr 0];
    else
        A_R = [0 wr; -wr -2*xi*wr];
    end
    A_r = blkdiag(A_r,A_R);
    B_r = [B_r; B_R];
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% augmented model %%%%%%%%%%%%%%%%%%%%%%%%%%% 
Aa_max = [A_max  zeros(3,2*n_h);
         -B_r*C  A_r];
Aa_min = [A_min  zeros(3,2*n_h);
         -B_r*C  A_r];
Ba   = [B; zeros(2*n_h, 1)];
Ca   = [C  zeros(1, 2*n_h)]; 
Da   = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%% LMI-based design %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% regional pole placement and guaranteed-cost
[n,m]  = size(Ba);
Q      = sdpvar(n,n, 'symmetric');   % variável n x n simétrica
W      = sdpvar(m,n);                % variável m x n
lambda = sdpvar(1,1);                % variável escalar

% region 1 parameters
L1 = 2*alpha;
M1 = 1;   

% region 2 parameters
r  = 3500;
L2 = -r*eye(2);
M2 = [0 1; 0 0];

% guaranteed-cost parameters
Cz = [pnlt*ones(1,3) pnlt*ones(1,n-3)];
Dz = 1;

% short form
Sigma_min = Aa_min*Q+Ba*W;
Sigma_max = Aa_max*Q+Ba*W;

% LMIs and solution
LMIS = Q>0;

LMIS = [LMIS, ...
                ([(Aa_max*Q+Ba*W)+(Aa_max*Q+Ba*W)',  (Cz*Q+Dz*W)';...
                (Cz*Q+Dz*W),                         -lambda])<0]; 
            
LMIS = [LMIS, ...
                ([(Aa_min*Q+Ba*W)+(Aa_min*Q+Ba*W)',  (Cz*Q+Dz*W)';...
                (Cz*Q+Dz*W),                         -lambda])<0];

LMIS = [LMIS, ...
            (kron(L1,Q)+kron(M1,Sigma_min)+kron(M1.',Sigma_min'))<0];
        
LMIS = [LMIS, ...
            (kron(L1,Q)+kron(M1,Sigma_max)+kron(M1.',Sigma_max'))<0];
        
LMIS = [LMIS, ...
             (kron(L2,Q)+kron(M2,Sigma_min)+kron(M2.',Sigma_min'))<0];
 
LMIS = [LMIS, ...
             (kron(L2,Q)+kron(M2,Sigma_max)+kron(M2.',Sigma_max'))<0];
          
options                   = sdpsettings('solver','lmilab','verbose',2);
options.lmilab.maxiter    = 1000;
options.lmilab.feasradius = 1e20;
solution                  = solvesdp(LMIS,lambda,options);

Q      = value(Q);
W      = value(W);
K      = W/Q;
lambda = value(lambda);


%%%%%%%%%%%%%%%%%%%%%%%%%%% controller discretization %%%%%%%%%%%%%%%%%%%%%     
Cr  = K(4:end);
Dr  = 0;
sys         = ss(A_r,B_r,Cr,Dr);
[NUMc,DENc] = ss2tf(A_r,B_r,Cr,Dr);
pmr_tf      = tf(NUMc,DENc);
bode(pmr_tf);

opts = c2dOptions('Method', 'tustin');
sysd = c2d(sys,T,opts);
A_r  = sysd.a;
B_r  = sysd.b;
C_r  = sysd.c;
D_r  = sysd.d;   
[NUM,DEN] = ss2tf(A_r,B_r,C_r,D_r);
pmr_dtf = tf(NUM,DEN,T);