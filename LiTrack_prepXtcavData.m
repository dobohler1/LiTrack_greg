function [Ioutput, Eoutput] =   LiTrack_prepXtcavData(filename)
load(filename)
time_data = data.px2um*(-data.time_cen+(1:size(data.img,2)))/data.streak;
z_axis = (time_data)*(10^-15)*(3*10^11);
delE_tcav = (-data.px2um*(-data.erg_cen+(1:size(data.img,1)))/data.dispersion)*100;

Etcav=sum(data.img,2); %go back and confirm 
Itcav=sum(data.img,1);

%load bunchProfile.mat
L=colfilt(data.img,[10 10], 'sliding', @mean);
[LL,~]=bwlabel(L, 8);
stats=regionprops(LL, 'all');
centroid=round(stats(1).Centroid);
yCen=centroid(1);
xCen=centroid(2);

xrange = X-X(xCen);
yrange = Y-Y(yCen); 

I=sum(Zs,1);
Iscaled=I./sum(I);
E=sum(Zs,2);
Escaled=E./sum(E);

Ioutput=[xrange; Iscaled];
Eoutput=[yrange; Escaled'];