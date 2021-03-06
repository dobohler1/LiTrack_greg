function [inp_struc] = LiTrack_loader(type, time, varargin)

% LiTrack_prepData_LCLS prepares an input file for LiTrack 
% that describes the longitudinal parameters of the LCLS
% accelerator.
%
% INPUTS
%    type: 0 = design machine. Parameters from constants
%          1 = extant machine. Parameters from control system.
%
%    The following arguments are given as name value pairs: 
%
%    ParamFileOutFn / desired file name of parameter output file 
%          (OPTIONAL, default = None)
%          If you give a name-value argument where the name is 'ParamFileOutFn', 
%          the corresponding value is interpretted as the name of the file to which you 
%          want the control system process variables of the accelerator saved. This
%          file would then be loaded in LiTrack. If no ParamFileOutFn is
%          given, no file will be written. See examples.
%
%    ParamFileInFn / The name of a template parameter input file. 
%          (OPTIONAL, default = template_LCLS.mat.  If no ParamFileInFn
%          is supplied, then the file template_LCLS.mat must be available
%          in the LiTrack directory).
%
%    ParticleFn / Particle file name (OPTIONAL, 
%                                   default = PulseStacker_150pC_1p7psDelay.zd')
%          If you give a name-value argument where the name is 'ParticleFn', 
%          the value is interpretted as the name of the particle 
%          distribution file (*.zd) you
%          want to be named in the returned inp_struc and saved in
%          the parameter file named in the argument described above. 
%
% OUTPUT
%    inp_struc
%          A structure describing the longitudinal parameters of LCLS. 
%          This structure is suitable for being passed directly to LiTrack.
%
% EXAMPLES
%    a) Prepare design inp_struc, don't write an ouptut file:
%    lclsparams = LiTrack_prepData_LCLS(0) 
%    
%    b) Prepare extant machine inp_struc, naming PulseStacker.zd as partcile file:
%    lclsparams = LiTrack_prepData_LCLS(1, 'ParticleFn','PulseStacker.zd')
%
%    c) Save the extant machine in test.mat
%    LiTrack_prepData_LCLS(1, 'ParamFileOutFn','test.mat')
%
%    d) Override the default template input parameter file (advanced usage)
%    LiTrack_prepData_LCLS(1, 'ParamFileInFn','myTemplate.mat')

% * TODO make run successfully when no template_LCLS.mat is in directory
% * TODO Verify proper behavior when ParamIn and ParamOut files are given..

% Constants
LiTrack_globals;


% Init
LiTrack_messages; % Include LiTrack message codes and text.
dirname = fileparts(which('LiTrack_prepData_LCLS.m'));
paramfp = [dirname filesep 'SaveFiles/'];

% Argument Processing
p = inputParser;
p.addRequired('type', @(x) ismember(x,[DESIGN,EXTANT]));
p.addParamValue('paramFileInFn',PARAMINFILENAME_DEF, @(x) validParamInFile(x)); 
p.addParamValue('paramFileOutFn',PARAMOUTFILENAME_DEF, @(x) validParamOutFile(x));  
p.addParamValue('particleFn', PARTICLEFILE_DEF, @(x) validParticleFile(x));
p.addParamValue('partstart', 4, @(x) isnumeric(x));
p.parse( type, varargin{:});
inputargs = p.Results;
type = inputargs.type;
savename = inputargs.paramFileOutFn;
partfile = inputargs.particleFn;

% Base output on given mat file, defaulted to PARAMINFILENAME_DEF by
% argument processing if not given.
load([inputargs.paramFileInFn],'inp_struc'); 

STAT = [...
1,  1;...    %  1 = free (1)
0,  10;...   %  2 = L0A (10)
0,  10;...   %  3 = L0B (10)
1,  22;...   %  4 = LH (22)
0,  6;...    %  5 = DL1 (6)
0,  10;...   %  6 = L1S (10)
0,  10;...   %  7 = L1X (10)
1,  7;...    %  8 = BC1 (7)
0,  1;...   %  9 = CSR (17)
0,  1;...    % 10 = free (1)
0,  10;...   % 11 = L2 (10)
1,  7;...    % 12 = BC2 (7)
0,  17;...   % 13 = CSR (17)
0,  10;...   % 14 = L3 (10)
0,  15;...   % 15 = BSY RW (15)
0,  6;...    % 16 = DL2 (6)
0,  1;...   % 17 = CSR (17)
0,  15;...   % 18 = LTU RW (15)
0,  1;...   % 19 = SE growth (22)
0,  15];     % 20 = UND RW (15)


%partstart = 4; %first included, now an optional parameter up top.
partend = 18; %last included
Qstart = 150;
Estart = 0.135;

%lclsparams = LiTrack_Loader(1,'04/01/2015 13:09:48','paramFileOutFn','Something_else(1).mat')
%lclsparams = LiTrack_Loader(1,time,'paramFileOutFn','Something_else(1).mat')
%lclsparams = LiTrack_Loader(1,time,'paramFileOutFn','PV_history.mat')
%time = input('Please enter time: ', 's');
% LiTrack_GUI('dir','/home/physics/rjh119/LiTrack_greg/Wakefiles','/home/physics/rjh119/LiTrack_greg/ParticleFiles','/home/physics/rjh119/LiTrack_greg/SaveFiles')

%Proper directory from which to call LiTrack
if ( type == DESIGN )
    disp('Preparing parameter data from constants');
    GunE = .006;
    L0Aamp = 0.0575;
    L0Aphi = 0;
    %L0Bphi = -2.5;
    DL1E = 0.135;
    L1Sphi = -25.5;
    L1Xphi = -160;
    L1Xamp = 0.017;
    BC1E = 0.22;
    BC1R56 = -0.0463;
    L2phi = -33.7;
    BC2E = 5;
    BC2R56 = -0.028;
    L3phi = 0;
    DL2E = sqrt(9800/45);
elseif ( type == EXTANT )
   % time = input('Please enter time: ', 's');
    timeRange = {time;time};
        
    disp('Preparing parameter data from control system and model');
%    GunE = lcaGetSmart('SIOC:SYS0:ML00:AO471')*MEV2GEV;
    GunE = 'SIOC:SYS0:ML00:AO471';
    gunE = {GunE};
    [time, value, sync_time, sync_value] = history(gunE, timeRange);
    gunE_col1 = sync_value(:,1);
    GunE = gunE_col1;
    
    %L0Aamp = lcaGetSmart('ACCL:IN20:300:L0A_S_AV')*MEV2GEV;
    L0Aamp = 'ACCL:IN20:300:L0A_S_AV'
    L0m = {L0Aamp};
    [time, value, sync_time, sync_value] = history(L0m, timeRange);
    L0m_col1 = sync_value(:,1)*0.001;
    L0Aamp = L0m_col1;
    
    
%    L0Aphi = lcaGetSmart('ACCL:IN20:300:L0A_S_PV');
    L0Aphi = 'SIOC:SYS0:ML00:AO475';         %pv for phase of L0b
    L0A_energy = 'SIOC:SYS0:ML00:AO474';
    L0A = {L0A_energy; L0Aphi};  
    [time, value, sync_time, sync_value] = history(L0A, timeRange);
    L0A_col2 = sync_value(:,2);     %refers to L0b_phase
    L0Aphi = L0A_col2;
    
%    L0Bphi = lcaGetSmart('ACCL:IN20:400:L0B_S_PV');
    L0Bphi = 'SIOC:SYS0:ML00:AO477';         %pv for phase of L0b
    L0b_energy = 'SIOC:SYS0:ML00:AO476';
    L0b = {L0b_energy; L0Bphi};  
    [time, value, sync_time, sync_value] = history(L0b, timeRange);
    L0b_col2 = sync_value(:,2);     %refers to L0b_phase
    L0Bphi = L0b_col2;

%    DL1E = lcaGetSmart('SIOC:SYS0:ML00:AO513')*MEV2GEV;
    DL1E = 'SIOC:SYS0:ML00:AO513';        % pv for energy of DL1
    DL1 = {DL1E};
    [time, value, sync_time, sync_value] = history(DL1, timeRange);
    DL1_col1 = sync_value(:,1)*0.001;     %refers to DL1_energy
    DL1E = DL1_col1;
    
%    L1Sphi = lcaGetSmart('ACCL:LI21:1:L1S_S_PV');
    L1S_energy = 'SIOC:SYS0:ML00:AO478';        %pv for energy of L1S
    L1Sphi = 'SIOC:SYS0:ML00:AO479';
    L1S = {L1S_energy; L1Sphi};
    [time, value, sync_time, sync_value] = history(L1S, timeRange);
    L1S_col1 = sync_value(:,1)*0.001;     %refers to L1S_energy
    L1S_col2 = sync_value(:,2);     %refers to L1S_phase
    L1SE = L1S_col1;
    L1Sphi = L1S_col2;

%    L1Xphi = lcaGetSmart('ACCL:LI21:180:L1X_S_PV');
    L1X_energy = 'SIOC:SYS0:ML00:AO480';        %pv for energy of L1X
    L1Xphi = 'SIOC:SYS0:ML00:AO481';
    L1X = {L1X_energy; L1Xphi};
    [time, value, sync_time, sync_value] = history(L1X, timeRange);
    L1X_col2 = sync_value(:,2);     %refers to L1X_phase
    L1Xphi = L1X_col2;

    %L1Xamp = lcaGetSmart('ACCL:LI21:180:L1X_S_AV')*MEV2GEV;
    L1Xamp = 'ACCL:LI21:180:L1X_S_AV';
    LXa = {L1Xamp};
    [time, value, sync_time, sync_value] = history(LXa, timeRange);
    LXa_col1 = sync_value(:,1)*0.001;
    L1Xamp = LXa_col1;

%    BC1E = lcaGetSmart('SIOC:SYS0:ML00:AO483')*MEV2GEV;
%    BC1R56 = lcaGetSmart('SIOC:SYS0:ML00:AO484')*MM2M; % PV from CUD
    BC1E = 'SIOC:SYS0:ML00:AO483';        %pv for energy of BC1
    BC1R56 = 'SIOC:SYS0:ML00:AO484';
    BC1 = {BC1E; BC1R56};
    [time, value, sync_time, sync_value] = history(BC1, timeRange);
    BC1_col1 = sync_value(:,1)*0.001;     %refers to BC1_energy
    BC1_col2 = sync_value(:,2)*0.001;     
    BC1E = BC1_col1;
    BC1R56 = BC1_col2;

%    L2phi = lcaGetSmart('SIOC:SYS0:ML00:CALC204');
    L2phi = 'SIOC:SYS0:ML00:CALC204';   %pv for energy of L2
    L2 = {L2phi};
    [time, value, sync_time, sync_value] = history(L2, timeRange);
    L2_col1 = sync_value(:,1);
    L2phi = L2_col1;

%    BC2E = lcaGetSmart('SIOC:SYS0:ML00:AO489'); % Already in GeV
%    BC2R56 = lcaGetSmart('SIOC:SYS0:ML00:AO490')*MM2M; % PV from CUD
    BC2E = 'SIOC:SYS0:ML00:AO489';        %pv for energy of BC1
    BC2R56 = 'SIOC:SYS0:ML00:AO490';
    BC2 = {BC2E; BC2R56};
    [time, value, sync_time, sync_value] = history(BC2, timeRange);
    BC2_col1 = sync_value(:,1);     %refers to BC2_energy
    BC2_col2 = sync_value(:,2)*0.001;    
    %BC2_col2 = sync_value(:,2)*0.001;     %refers to BC2_phase
    BC2E = BC2_col1;
    BC2R56 = BC2_col2;

%   L3phi = lcaGetSmart('SIOC:SYS0:ML00:AO499');
    L3_energy = 'SIOC:SYS0:ML00:AO500';
    L3phi = 'ACCL:LI25:1:PDES';
    L3 = {L3_energy; L3phi};
    [time, value, sync_time, sync_value] = history(L3, timeRange);
    L3_col1 = sync_value(:,1);      %refers to L3 energy
    L3_col2 = sync_value(:,2);      %refers to L3 phase
    L3phi = L3_col2;


%    DL2E = lcaGetSmart('SIOC:SYS0:ML00:AO500'); 
    DL2E = 'SIOC:SYS0:ML00:AO500';        % pv for energy of DL2
    DL2 = {DL2E};
    [time, value, sync_time, sync_value] = history(DL2, timeRange);
    DL2_col1 = sync_value(:,1);     %refers to DL2_energy
    DL2E = DL2_col1;

    
else
    error('Unrecognized type argument value: %d',type);
end

% Format inputs:
STAT(1:(inputargs.partstart-1),2) = 1; %turn off upstream stuff
STAT(2:(inputargs.partstart-1),1) = 0; %and don't plot
STAT((partend+1):end,2) = 99; %turn off downstream stuff
STAT((partend+1):end,1) = 0; %and don't plot
inp_struc.p(1:size(STAT,1)) = STAT(:,1).';
inp_struc.save_fn = savename;
inp_struc.inp = partfile;
inp_struc.zd_file = partfile;
inp_struc.comment = 'Generated by script...';
inp_struc.Ne = Qstart*1e-12/1.602e-19;
inp_struc.E0 = Estart;
% setup linac
inp_struc.beamline(2,2) = L0Aamp; %L0A amp
inp_struc.beamline(2,3) = L0Aphi; %L0A phase
inp_struc.beamline(3,2) = DL1E; %L0B amp
inp_struc.beamline(3,3) = L0Bphi; %L0B amp
inp_struc.beamline(5,4) = DL1E; %DL1 E
inp_struc.beamline(6,2) = BC1E - L1Xamp*cosd(L1Xphi);
%inp_struc.beamline(6,2) = L1SE;
inp_struc.beamline(6,3) = L1Sphi;
inp_struc.beamline(7,2) = BC1E;
inp_struc.beamline(7,3) = L1Xphi;
inp_struc.beamline(8,2) = BC1R56;
inp_struc.beamline(8,3) = BC1E;
inp_struc.beamline(11,2) = BC2E+2e-3;
inp_struc.beamline(11,3) = L2phi;
inp_struc.beamline(12,2) = BC2R56;
inp_struc.beamline(12,3) = BC2E;
inp_struc.beamline(14,2) = DL2E + 2e-3;
inp_struc.beamline(14,3) = L3phi;
inp_struc.beamline(16,4) = DL2E;
inp_struc.beamline(1:size(STAT,1),1) = STAT(:,2);

if ( ~strcmp(savename, NOPARAMFILE ))
    save([paramfp,savename],'inp_struc');
end

function [isvalid] = validParticleFile( particleFn )
% validParticleFile checks whether the given string names an existing
% LiTrack particle file. Particle files must have extension .zd.

LiTrack_messages;
LiTrack_globals;

isvalid=false;
if (exist(particleFn,'file') == FILEEXISTS)
    [ ~, ~, ext ] = fileparts( particleFn );
    if strcmp(ext,PARTICLEFILEEXT)
        isvalid=true;
    end
end
if ~isvalid
     error(LIT_PARTICLEFILENOTFOUND, LIT_PARTICLEFILENOTFOUNDMSG, particleFn);
end

function [isvalid] = validParamInFile( paramFn )
% validParamInFile checks the validity of any input parameter file. By
% default this is the template_LCLS input file.

LiTrack_messages;
LiTrack_globals;
                 
isvalid=false;
if (exist(paramFn,'file') == FILEEXISTS)
    [ ~, ~, ext ] = fileparts( paramFn );
    if strcmp(ext,PARAMFILEEXT)
        isvalid=true;
    end
end
if ~isvalid
     error(LIT_PARAMFILENOTFOUND, LIT_PARAMFILENOTFOUNDMSG, paramFn);
end

function [isvalid] = validParamOutFile( paramFn )
% validParamOutFile checks the validity of any output parameter file. 
% In particular, it checks taht someone doesn't accidentaly try to write
% the default template LCLS input file.

LiTrack_messages;
LiTrack_globals;

isvalid=false;
[ ~, ~, extpart ] = fileparts( paramFn );
if ( ~strcmp(extpart,PARAMFILEEXT))
    error(LIT_FILENAMEINVALID, [ LIT_FILENAMEINVALIDMSG, ...
        paramFn ' must have extention ' PARAMFILEEXT ]);
end
if strcmp( paramFn, PARAMINFILENAME_DEF )
    error(LIT_FILENAMEINVALID, [ LIT_FILENAMEINVALIDMSG, ...
        paramFn ' must NOT be the template file name ' ...
        PARAMINFILENAME_DEF ]);
end
isvalid=true;
