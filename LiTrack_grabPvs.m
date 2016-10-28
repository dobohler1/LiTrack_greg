
function [] = LiTrack_grabPvs(handles)

%formerly Tick_tock.m

addpath('/home/physics/rjh119/LiTrack_greg')
%function [output] = Tick_tock(handles, start_time, end_time, component)
%function [] = load_something(handles)
%change to work with multiple components
%{'L1S', 'L1X')
start_time = input('Please enter start time (mm/dd/yyyy hh:mm:ss): ', 's');
end_time = input('Please enter end time (mm/dd/yyyy hh:mm:ss): ', 's');
timeRange = {start_time;end_time};


%component = input('Please enter LCLS component: ', 's');
%if component == 'QnC'
%if strcmp(component, QnC)
%    charge = 'SIOC:SYS0:ML00:AO470';
%    Q = {charge};
%    [time, value, sync_time, sync_value] = history(Q, timeRange);
%    Q_col1 = sync_value(:,1);
%    x = sync_time;
%    if strcmp(start_time, end_time)
%        Charge = Q_col1
%    else
%    fig = figure;
%    plot(sync_time, Q_col1);   % plots Q w.r.t. time
%    dateformat = 22;
%    datetick('x', dateformat);
%    title('Initial Bunch Charge');
%    xlabel('time');
%    ylabel('Charge(nC)');
%    end
    
%if component == 'L0a'
    L0Aphi = 'SIOC:SYS0:ML00:AO475';         %pv for phase of L0b
    L0A_energy = 'SIOC:SYS0:ML00:AO474';
    L0A = {L0A_energy; L0Aphi};  
    [time, value, sync_time, sync_value] = history(L0A, timeRange);
    L0A_col1 = sync_value(:,1);     %refers to L0a energy
    L0A_col2 = sync_value(:,2);     %refers to L0b phase
    L0A_energy = L0A_col1;
    L0Aphi = L0A_col2;
    x = sync_time;
    if strcmp(start_time, end_time)  
        L0A_energy = L0A_col1
        L0Aphi = L0A_col2 
    else   
    fig = figure;
    
    [ax, h1, h2] = plotyy(x, L0A_col1, x, L0A_col2);
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    title('L0a')
    xlabel('time')
    set(get(ax(1), 'Ylabel'), 'String', 'Energy (MeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Phase (degs)');
    end
    
%elseif component == 'L0m'
    L0Aamp = 'ACCL:IN20:300:L0A_S_AV'
    L0m = {L0Aamp};
    [time, value, sync_time, sync_value] = history(L0m, timeRange);
    L0m_col1 = sync_value(:,1)*0.001;
    L0A_amp = L0m_col1;
    x = sync_time;
    if strcmp(start_time, end_time)
        L0A_amp =L0m_col1
    else
    fig = figure;
    
    plot(x, L0A_amp);
    dateformat = 22;
    datetick('x', dateformat);
    title('L0A_amp');
    xlabel('time');
    ylabel('Amplitude');
    end     
   
    

%%elseif component == 'L0b' 
    L0b_energy = 'SIOC:SYS0:ML00:AO476';        %pv for energy of L0b
    L0b_phase = 'SIOC:SYS0:ML00:AO477';         %pv for phase of L0b
    L0b = {L0b_energy; L0b_phase};  
    [time, value, sync_time, sync_value] = history(L0b, timeRange);
    L0b_col1 = sync_value(:,1);     %refers to L0b_energy
    L0b_col2 = sync_value(:,2);     %refers to L0b_phase
    x = sync_time;
    if strcmp(start_time, end_time)  
        L0b_energy = L0b_col1
        L0b_phase = L0b_col2      
    else  
    fig = figure;
    
    [ax, h1, h2] = plotyy(x, L0b_col1, x, L0b_col2);
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    title('L0b')
    xlabel('time')
    set(get(ax(1), 'Ylabel'), 'String', 'Energy (MeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Phase (degs)');
    end
    
%elseif component == 'DL1'
    DL1_energy = 'SIOC:SYS0:ML00:AO513';        % pv for energy of DL1
    DL1 = {DL1_energy};
    [time, value, sync_time, sync_value] = history(DL1, timeRange);
    DL1_col1 = sync_value(:,1)*0.001;     %refers to DL1_energy (GeV)
    if strcmp(start_time, end_time)
        DL1_energy = DL1_col1
    else
    fig = figure;
    plot(sync_time, DL1_col1);   % plots DL1_energy w.r.t. time
    dateformat = 22;
    datetick('x', dateformat);
    title('DL1');
    xlabel('time');
    ylabel('Energy(MeV)');
    end 
    
%elseif component == 'L1S'
   L1S_energy = 'SIOC:SYS0:ML00:AO478';        %pv for energy of L1S
   L1S_phase = 'SIOC:SYS0:ML00:AO479';
   L1S = {L1S_energy; L1S_phase};
   [time, value, sync_time, sync_value] = history(L1S, timeRange);
   L1S_col1 = sync_value(:,1);     %refers to L1S_energy 
   L1S_col2 = sync_value(:,2);     %refers to L1S_phase
   x = sync_time;
   %if start_time == end_time 
   if strcmp(start_time, end_time)
       L1S_energy = L1S_col1
       L1S_phase = L1S_col2
   else  
   fig = figure;

   [ax, h1, h2] = plotyy(x, L1S_col1, x, L1S_col2);
   dateformat = 22;
   datetick(ax(1), 'x', dateformat);
   datetick(ax(2), 'x', dateformat);
   title('L1S');
   xlabel('time');
   set(get(ax(1), 'Ylabel'), 'String', 'Energy (MeV)');
   set(get(ax(2), 'Ylabel'), 'String', 'Phase (degs)'); 
   end 
   
%elseif component == 'L1X'
    L1X_energy = 'SIOC:SYS0:ML00:AO480';        %pv for energy of L1X
    L1X_phase = 'SIOC:SYS0:ML00:AO481';
    L1X = {L1X_energy; L1X_phase};
    [time, value, sync_time, sync_value] = history(L1X, timeRange);
    L1X_col1 = sync_value(:,1);     %refers to L1X_energy
    L1X_col2 = sync_value(:,2);     %refers to L1X_phase
    x = sync_time;
    if strcmp(start_time, end_time)
        L1X_energy = L1X_col1
        L1X_phase = L1X_col2
    else
    fig = figure;
    [ax, h1, h2] = plotyy(x, L1X_col1, x, L1X_col2);
    title('L1X')
    xlabel('time')
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    set(get(ax(1), 'Ylabel'), 'String', 'Energy (MeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Phase (degs)');
    end
    
%elseif component == 'BC1'
    BC1_energy = 'SIOC:SYS0:ML00:AO483';        %pv for energy of BC1
    R1_56 = 'SIOC:SYS0:ML00:AO484';
    BC1 = {BC1_energy; R1_56};
    [time, value, sync_time, sync_value] = history(BC1, timeRange);
    BC1_col1 = sync_value(:,1)*0.001;     %refers to BC1_energy (GeV)
    BC1_col2 = sync_value(:,2)*0.001;     %refers to BC1 linear compression coefficient (mm)
    x = sync_time;
    if strcmp(start_time, end_time)
        BC1_energy = BC1_col1
        R1_56 = BC1_col2
    else
    fig = figure;
    [ax, h1, h2] = plotyy(x, BC1_col1, x, BC1_col2);
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    title('BC1');
    xlabel('time');
    set(get(ax(1), 'Ylabel'), 'String', 'Energy(MeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Linear Compression Coefficient (mm)');
    end
    
%elseif component == 'L_2'
    L2_energy = 'SIOC:SYS0:ML00:CALC205';
    L2_phase = 'SIOC:SYS0:ML00:CALC204';
    L2 = {L2_energy; L2_phase};
    [time, value, sync_time, sync_value] = history(L2, timeRange);
    L2_col1 = sync_value(:,1);
    L2_col2 = sync_value(:,2);
    x = sync_time;
    if strcmp(start_time, end_time);
        L2_energy = L2_col1
        L2_phase = L2_col2
    else
    fig = figure;
    [ax, h1, h2] = plotyy(x, L2_col1, x, L2_col2, 'plot');
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    title('L2');
    xlabel('time');
    set(get(ax(1), 'Ylabel'), 'String', 'Energy(MeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Phase (degs)');
    end   
    
%elseif component ==  'BC2'
    BC2_energy = 'SIOC:SYS0:ML00:AO489';        %pv for energy of BC1
    R2_56 = 'SIOC:SYS0:ML00:AO490';
    BC2 = {BC2_energy; R2_56};
    [time, value, sync_time, sync_value] = history(BC2, timeRange);
    BC2_col1 = sync_value(:,1);     %refers to BC2_energy (GeV)
    BC2_col2 = sync_value(:,2)*0.001;     %refers to BC2 linear compression coefficient (mm)
    x = sync_time;
    if strcmp(start_time, end_time)
        BC2_energy = BC2_col1 
        R2_56 = BC2_col2 
    else
    fig = figure;
    [ax, h1, h2] = plotyy(x, BC2_col1, x, BC2_col2, 'plot');
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    title('BC2');
    xlabel('time');
    set(get(ax(1), 'Ylabel'), 'String', 'Energy(GeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Linear Compression Coefficient (mm)');
    end
    
%elseif component == 'L_3'
    L3_energy = 'SIOC:SYS0:ML00:AO500';
    L3_phase = 'ACCL:LI25:1:PDES';
    L3 = {L3_energy; L3_phase};
    [time, value, sync_time, sync_value] = history(L3, timeRange);
    L3_col1 = sync_value(:,1);      %refers to L3 energy
    L3_col2 = sync_value(:,2);      %refers to L3 phase
    x = sync_time;
    if strcmp(start_time, end_time)
        L3_energy = L3_col1
        L3_phase = L3_col2
    else
    fig = figure;
    [ax, h1, h2] = plotyy(x, L3_col1, x, L3_col2, 'plot');
    dateformat = 22;
    datetick(ax(1), 'x', dateformat);
    datetick(ax(2), 'x', dateformat);
    title('L3');
    xlabel('time');
    set(get(ax(1), 'Ylabel'), 'String', 'Energy(GeV)');
    set(get(ax(2), 'Ylabel'), 'String', 'Phase (degs)');
    end
    
 
%end 

