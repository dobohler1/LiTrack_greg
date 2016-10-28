

L0A_MV_actPv = 'ACCL:IN20:300:L0A_S_AV';
L0A_DEG_actPv = 'ACCL:IN20:300:L0A_S_PV';

L0B_MV_actPv = 'ACCL:IN20:400:L0B_S_AV';
L0B_DEG_actPv = 'ACCL:IN20:400:L0B_S_PV';

%3-1 (Additional Energy Spread going into DL1..Can we get this from DL1 BPM
%dispersion measurement)

%4-1 R56 (DL1) ...use Aida to get all the model parameters - confirm same
% R56 and others ...use the BC_chicane_control look at Des/act to determine
% to how calc...
DL1_M_act = 'BPMS:IN20:425';   % BPMS:425 is the 1st device in DL1

%4-2 T566 Pull out of the model..lookup details

%4-3
DL1_MeV_actPV = 'SIOC:SYS0:ML00:AO513';

%4-4 %U5666 Pull out of the model..lookup details

L1S_MV_actPv = 'ACCL:LI21:1:L1S_S_AV';
L1S_DEG_actPv = 'ACCL:LI21:1:L1S_S_PV';

L1X_MV_actPv = 'ACCL:LI21:180:L1X_S_AV';
L1X_DEG_actPv = 'ACCL:LI21:180:L1X_S_PV';

BC1_mm_actPv = 'SIOC:SYS0:ML00:AO484'; %R56
BC1_MeV_actPv = 'SIOC:SYS0:ML00:AO483'; %Energy
%BC1_R56_actPv = ' '; % dR56
       
L2_GeV_actPv = 'SIOC:SYS0:ML00:AO489';
L2_DEG_actPv = 'SIOC:SYS0:ML00:CALC204';
%LambdaS

BC2_mm_actPv ='SIOC:SYS0:ML00:AO490'; %R56
BC2_GeV_actPv ='SIOC:SYS0:ML00:AO489';
%BC2_R56_actPV = '';

%10-1 Energy Spread before L3 Additional Energy Spread...(Can we get this 
%from DL1 BPM dispersion measurement

L3_GeV_actPv = 'SIOC:SYS0:ML00:AO500';
L3_DEG_actPv = 'SIOC:SYS0:ML00:AO499';
%LambdaS

% Wakefield Terms (end of L3 to BSY) use the model to figure out 
% Wakefield Term (BSY to use the model to figure out 

DL2_GeV_actPV = 'SIOC:SYS0:ML00:AO500'; % 
% (use Aida to get all the model parameters - confirm same R56 and others)
% (use the BC_chicane_control look at Des/act to determine how calc..)
% T566/U5666 Pull out of the model
DL2_M_act = 'WIRE:LTU1:246';      % This WIRE is 1st device in DL2

%Energy spread after dl2 Additional Energy Spread ...(Can we get this from DL2 BPM
%dispersion measurement?

%LTU Und/Wakefields use the model to figure out 


%--
L0A_gev = lcaGet(L0A_MV_actPv)*1e-3;
L0A_deg = lcaGet(L0A_DEG_actPv);
lambdaS_m = 0.104969; %m 
L0A_wake = 0;
L0A_m = 3.05;

L0B_gev = lcaGet(L0B_MV_actPv)*1e-3;
L0B_deg = lcaGet(L0B_DEG_actPv);
L0B_wake = 5;
L0B_m = 3.05;

sigE_beforeDL1 = 0.001; %E Energy Spread before DL1

%DL1_R56 
DL1_R = model_rMatGet(DL1_M_act); 
DL1_R56 = DL1_R(5,6);

%DL1_T566 
DL1_E = lcaGet(DL1_MeV_actPV);
%DL1_U5666

L1S_gev = lcaGet(L1S_MV_actPv)*1e-3;
L1S_deg = lcaGet(L1S_DEG_actPv);
% lambdaS_m = 0.104969; %m
L1S_wake = 5;
L1S_m = 8.78;

L1X_gev = lcaGet(L1X_MV_actPv)*1e-3;
L1X_deg = lcaGet(L1X_DEG_actPv);
lambdaX_m = 0.026242; %m 
L1X_wake = 6;
L1X_m = 0.6;

BC1_mm = lcaGet(BC1_mm_actPv)*1e-3;
BC1_MeV = lcaGet(BC1_MeV_actPv)*1e-3;
%BC1_R56

L2_gev = lcaGet(L2_GeV_actPv);
L2_deg = lcaGet(L2_DEG_actPv);
% lambdaS_m = 0.104969; %m
L2_wake = 5;
L2_m = 329.1;

BC2_mm = lcaGet(BC2_mm_actPv)*1e-3;
BC2_geV = lcaGet(BC2_GeV_actPv);
%BC2_R56

sigE_beforeL3 = 8e-6; %E Energy Spread before L3

L3_gev = lcaGet(L3_GeV_actPv);
L3_deg = lcaGet(L3_DEG_actPv);
%LambdaS
L3_wake = 5;
L3_m = 552.9;


rwWake1_radius_m = 0.0125;
rwWake1_L_m = 76;
rwWake1_cond_ohmM = 1.4e6;
rwWake1_tau_s = 5e-15;

rwWake2_radius_m = 0.0125;
rwWake2_L_m = 275;
rwWake2_cond_ohmM = 5.8e7;
rwWake2_tau_s = 8e-15;

%DL2_R56 
DL2_R = model_rMatGet(DL2_M_act); 
DL2_R56 = DL2_R(5,6);
%DL2_T566 
DL2_E = lcaGet(DL2_GeV_actPV);
%DL2_U5666

sigE_afterDL2 = 2e-6; %E Energy Spread before DL1

ltuUndWake_radius_m = 0.0025;
ltuUndWake1_L_m = 130;
ltuUndWake1_cond_ohmM = 5.8e7;
ltuUndWake1_tau_s = 2.7e-14;

terminateTracking=0.01;





[ho,h]=util_appFind('LiTrack_GUI');
set(h.popupmenu3,'Value', 1) 
LiTrack_GUI('popupmenu3_Callback', ho,[],h)
disp('end')

