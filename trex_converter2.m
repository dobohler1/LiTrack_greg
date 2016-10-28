function [res_I, res_E] = trex_converter2(handles, hplot)
[I_tc, E_tc]=LiTrack_prepXtcavData('TREX-Sample-2015-04-01-144547.mat');

Extcav=E_tc(2,:);
Ex_tc=E_tc(1,:);
Ixtcav=I_tc(2,:);
Ix_tc=I_tc(1,:);

[I_lt,E_lt]=LiTrack_prepData(handles);
Elitrack=E_lt(2,:);
Ex_lt=E_lt(1,:);
Ilitrack=I_lt(2,:);
Ix_lt=I_lt(1,:);


lenI_tcav=length(Ixtcav);
lenI_lit=length(Ilitrack);

if lenI_lit > lenI_tcav
    lenI=lenI_lit -lenI_tcav;
    zerosI=zeros(1, lenI);
    I_tcav_pad=cat(2,zerosI, Ixtcav);
    res_I = sum((I_tcav_pad - Ilitrack).^2);
else
    lenI=lenI_tcav - lenI_lit;
    zerosI=zeros(1, lenI);
    I_pad=cat(2,zerosI, I);
    res_I = sum((Ixtcav - I_pad).^2);
end

lenE_tcav=length(Extcav);
lenE_lit=length(Elitrack);

if lenE_lit > lenE_tcav
    lenE=lenE_lit - lenE_tcav;
    zerosE=zeros(1,lenE);
    Extcav_pad=cat(2,zerosE,Extcav);
    res_E = sum((Extcav_pad - Elitrack).^2);
else
    lenE = lenE_tcav - lenE_lit;
    zerosE=zeros(1,lenE);
    Elitrack_pad=cat(2,zerosE,Elitrack);
    res_E = sum((Extcav - Elitrack_pad).^2);
end

if hplot
    figure(99); plot(Ex_tc,Extcav,'b')
    hold on 
    plot(Ex_lt, Elitrack,'r')
    ylabel('dE/E %')
    xlabel('n/10^3')
    legend({'XTCAV','LiTrack'})
    
    figure(98); plot(Ix_tc,Ixtcav,'b')
    xlabel('z (mm)');
    ylabel('Current (A)');
    title('')
    hold on
    plot(Ix_lt,Ilitrack,'r')
    legend({'XTCAV','LiTrack'})
end


