% Calls upon Particlemakerscript and LiTrack_Loader in order to upload
% beamline parameters and Particle file
%addpath('/home/physics/rjh119/ParticleMaker1')
cd '/home/physics/rjh119/ParticleMaker1'

streak = 285; % um/degS
disp = 0.75282;% m
E = 135e6;
%Charge=140; %pC -add history and date
%start_time = input('Please enter start time (mm/dd/yyyy hh:mm:ss): ', 's');
start_time = '03/01/2016 11:55:28'; 
timeRange = {start_time;start_time};
charge = 'SIOC:SYS0:ML00:AO470';
Q = {charge};
[time, value, sync_time, sync_value] = history(Q, timeRange);
Q_col1 = sync_value(:,1)
p = makeParticles(disp,streak,Q_col1,100e3,'/u1/lcls/matlab/data/2016/2016-03/2016-03-01/ProfMon-YAGS_IN20_841-2016-03-01-115528.mat');


cd '/home/physics/rjh119/LiTrack_greg'
LiTrack_GUI('dir','/home/physics/rjh119/LiTrack_greg/Wakefiles','/home/physics/rjh119/LiTrack_greg/ParticleFiles','/home/physics/rjh119/LiTrack_greg/SaveFiles')
addpath('ParticleFiles/')
%cd '/home/physics/rjh119/LiTrack_greg/ParticleFiles'
%load X03_01_2016_115528.zd


% figure; 
% imagesc(X,Y,Zs)
%%%%%%%%%% SAB files %%%%%%%%%%%%%%%%%%%%%%%
%!find . -name "*TREX-Sample-*"
%!find . -name "*ProfMon-YAGS_IN20*"
%'/u1/lcls/matlab/data/2015/2015-11/2015-11-30/ProfMon-YAGS_IN20_241-2015-11-30-194928.mat'
%'/u1/lcls/matlab/data/2016/2016-03/2016-03-01/ProfMon-YAGS_IN20_841-2016-03-01-115528.mat'
%
%