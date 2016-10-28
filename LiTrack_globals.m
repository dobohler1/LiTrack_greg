%% LiTrack constants

global MEV2GEV MM2M;
MEV2GEV=0.001;
MM2M=0.001; 

global DESIGN EXTANT;
DESIGN=0;
EXTANT=1;

% File handline
global PARTICLEFILEEXT PARAMFILEEXT FILEEXISTS;
FILEEXISTS=2; % exist function return code for regular file that exists
PARTICLEFILEEXT='.zd'; % File extention of LiTrck particle file
PARAMFILEEXT='.mat'; % File extention of LiTrck parameter file

global NOPARAMFILE PARAMOUTFILENAME_DEF PARAMINFILENAME_DEF PARTICLEFILE_DEF
NOPARAMFILE='None';
PARAMOUTFILENAME_DEF=NOPARAMFILE;
PARAMINFILENAME_DEF='template_LCLS.mat';
PARTICLEFILE_DEF='PulseStacker_150pC_1p7psDelay.zd';