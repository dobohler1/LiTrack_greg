%!find . -name "*TREX-Sample-*"
%!find . -name "*ProfMon-YAGS_IN20_995*"
%!find . -name "*YAGS_LTU1_743*"
% cd /u1/lcls/matlab/data/
trex_time = input('enter time of TREX file ', 's');
year = trex_time(7:10);
month = trex_time(1:2);
day = trex_time(4:5);
hh = trex_time(12:13);
mm = trex_time(15:16);
ss = trex_time(18:19);

TREX_string = strcat('/u1/lcls/matlab/data/',year,'/',year,'-',month,'/',year,'-',month,'-',day,'/TREX-Sample-',year,'-',month,'-',day,'-',hh,mm,ss,'.mat');
%TCAV3_string = strcat('/u1/lcls/matlab/data/2016/2016-01/2016-01-26/ContRecord-YAGS_LTU1_743_IMAGE-2016-01-26-195534-361.mat');


load(TREX_string)
%load(TCAV3_string)
time_data = data.px2um*(-data.time_cen+(1:size(data.img,2)))/data.streak;
z_axis = (time_data)*(10^-15)*(3*10^11);
delE_data = -data.px2um*(-data.erg_cen+(1:size(data.img,1)))/data.dispersion;
figure;
imagesc(z_axis, delE_data, data.img)
xlabel('z (mm)');
ylabel('Energy spread');
axis xy


% ./TREX-Sample-2016-04-11-132817.mat
%./TREX-Sample-2015-02-25-161140.mat
% 02/18/2014 18:26:26 tcav3
% 02/18/2014 21:30:48 sab
%./2016-01-26/ContRecord-YAGS_LTU1_743_IMAGE-2016-01-26-195534-361.mat






