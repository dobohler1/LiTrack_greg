function [output] = convert_Spect(type, time)

%formerly "string_bean"
%script to convert spectrometer data


% time = '10/14/2015 16:38:56'; 
year = time(7:10);
month = time(1:2);
day = time(4:5);
hh = time(12:13);
mm = time(15:16);
ss = time(18:19);

SAB_string = strcat('/u1/lcls/matlab/data/',year,'/',year,'-',month,'/',year,'-',month,'-',day,'/ProfMon-YAGS_IN20_995-',year,'-',month,'-',day,'-',hh,mm,ss,'.mat');

% cd '/home/physics/rjh119/ParticleMaker1'
addpath('/home/physics/rjh119/LiTrack_greg/ParticleMaker1')
addpath('/home/physics/rjh119/LiTrack_greg')
addpath('/home/physics/rjh119/LiTrack_greg/ParticleFiles')

%streak = 285; % um/degS
streak = -527.7; % um/degS
disp = 0.75282;% m
E = 135e6;
timeRange = {time;time};
charge = 'SIOC:SYS0:ML00:AO470';
Q = {charge};
% [time, value, sync_time, sync_value] = history(Q, timeRange);
% Q_col1 = sync_value(:,1)
p = makeParticles(disp,streak,280,100e3,SAB_string);
% p = makeParticles(disp,streak,Q_col1,100e3,SAB_string);
addpath('/home/physics/rjh119/LiTrack_greg/ParticleFiles')
%cd '/home/physics/rjh119/LiTrack_greg'
%LiTrack_GUI('dir','/home/physics/rjh119/LiTrack_greg/Wakefiles','/home/physics/rjh119/LiTrack_greg/ParticleFiles','/home/physics/rjh119/LiTrack_greg/SaveFiles');

%!find . -name "*TREX-Sample-*"
%!find . -name "*ProfMon-YAGS_IN20_995*"
%!find . -name "*YAGS_LTU1_743*"

% cd /u1/lcls/matlab/data/
%'/2015-04/2015-04-01/ProfMon-YAGS_IN20_995-2015-04-01-130948.mat'
%'/2015-04/2015-04-01/ProfMon-YAGS_IN20_995-2015-04-01-171300.mat'
%'./ProfMon-YAGS_IN20_995-2015-02-25-124653.mat'
%'./ProfMon-YAGS_IN20_995-2015-10-14-163856.mat'
%'./ProfMon-YAGS_IN20_995-2016-04-11-110954.mat'
%./2014-11-27/ProfMon-YAGS_IN20_995-2014-11-27-143404.mat
%./2015-10-21/ProfMon-YAGS_IN20_995-2015-10-21-153842.mat
%./2016-04-26/ProfMon-YAGS_IN20_995-2016-04-26-192825.mat
