addpath('/home/physics/rjh119/ParticleMaker1')

streak = 285; % um/degS
disp = 0.75282;% m
E = 135e6;
%Charge=140; %pC -add history and date
%start_time = input('Please enter start time (mm/dd/yyyy hh:mm:ss): ', 's');
start_time = '10/14/2015 16:38:56'; 
timeRange = {start_time;start_time};
charge = 'SIOC:SYS0:ML00:AO470';
Q = {charge};
[time, value, sync_time, sync_value] = history(Q, timeRange);
Q_col1 = sync_value(:,1)
% p = makeParticles(disp,streak,Q_col1,100e3,'ProfMon-YAGS_IN20_995-2015-04-01-130948.mat');


%/home/physics/rjh119/ParticleMaker1
%p = makeParticles(disp,streak,Q_col1,100e3,'/u1/lcls/matlab/data/2015/2015-04/2015-04-01/ProfMon-YAGS_IN20_995-2015-04-01-130948.mat');

p = makeParticles(disp,streak,Q_col1,100e3,'/u1/lcls/matlab/data/2015/2015-10/2015-10-14/ProfMon-YAGS_IN20_995-2015-10-14-163856.mat');
