function [Ioutput, Eoutput] =   LiTrack_prepData(handles)
%load bunchProfile.mat
[X,Y,Z,~,~] = contour_plot(handles.bunchDist.zmm,handles.bunchDist.dpct,...
    handles.bunchDist.Nbin,handles.bunchDist.Nbin,0);		% plot color image, rather than scatter plot
Zs = fast_smooth2(Z);

%L=nlfilter(Zs,[10 10], fun); %[10 10]
L=colfilt(Zs,[10 10], 'sliding', @mean);
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
