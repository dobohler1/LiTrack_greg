README OF LITRACK 

LiTrack is a Longitudinal Phase Space tracking and simulation code. See references.

Authors: Karl Bane (orig), Paul Emma (orig). Tim Maxwell, Greg White, Dorian Bohler.
Editor: Greg White



Running LiTrack
==============
Running On Personal Computer "Extremum Seeking Mode":
1. start Matlab
2. execute run_LiTrack_GUI.m which add folders to the path
3. double click "PV_history.mat" in Save/Restore Files drop down
4. double click "testData2.zd" in Particles from File








Running On Production:

1. Start the GUI.
Either from Matlab_GUI panel, hit "LiTrack," or, 
to use your own LiTrack, run the GUI giving file locations. Examples;
  >> cd lclscvs/matlab/LiTrack
  >> LiTrack_GUI('dir','Wakefiles/','ParticleFiles/','SaveFiles/')
or
  >> LiTrack_GUI('dir','/home/physics/dbohler/LiTrack/LiTrack_greg/Wakefiles',...
  '/home/physics/dbohler/LiTrack/LiTrack_greg/ParticleFiles',...
  '/home/physics/dbohler/LiTrack/LiTrack_greg/SaveFiles')
[NOTE: To work properly, the supplemental file directories Wakefiles, ParticleFiles etc, must
be in immediate child driectories of LiTrack_GUI! Sees like a bug.]

2. Select source particles. In Input Particles From dialog box, either:
    Select "internal source" or
    Select "External file"
       From the particles file list (file names ending .zd) you must select a Particle File,
       eg LCLS_no_spikes.zd. Your selection will be echoed in the status box at the
       bottom of the GUI.

3. Hit "Track".

On dev/laptop etc:

Assuming you're in /Users/greg/Development/litrack/lclscvs/matlab/LiTrack/
i. >> LiTrack_GUI('dir','/Users/greg/Development/litrack/lclscvs/matlab/LiTrack/Wakefiles',...
'/Users/greg/Development/litrack/lclscvs/matlab/LiTrack/ParticleFiles',...
'/Users/greg/Development/litrack/lclscvs/matlab/LiTrack/SaveFiles')


Project to enhance LiTrack (longitudinal phase space tracking)
==============================================================

Prepare and use LCLS input file
-------------------------------
There is a utility function to hep prepare a "SaveFile" (*.mat); LiTrack_prepData_LCLS.m
can be run to create an input file reflecting the design (from simply hard coded 
constants), or "extant" machine (from PVs and LCLS model).

1. In your own physics "profile", or profile 0:
  $ matlab

2. Then execute LiTrack_prepData_LCLS using one the variants below. Suggest c) for 
   input from PVs:
     a. LiTrack_prepData_LCLS(0) - creates SaveFiles/template_LCLS.mat from contant params
     b. LiTrack_prepData_LCLS(1) - creates SaveFiles/template_LCLS.mat from PVs
     c. LiTrack_prepData_LCLS(1,'lcls_20160224T2136.mat')  
	      - creates lcls_20160224T2136.mat rather than template_LCLS.mat
     d. LiTrack_prepData_LCLS(1,'lcls_20160224T2136.mat','lcls_200pC_6MeV_560um.zd')
	      - sets inp_struc in lcls_20160224T2136.mat to reference 'lcls_200pC_6MeV_560um.zd
		as the particle file, rather than default PulseStacker_150pC_1p7psDelay.zd.

   The above will create a mat file containing a matlab structure named "inp_struc" as
   understood by LiTrack. 

3. Launch LiTrack (or relaunch if necessary - see NOTE below), and look for your .mat file
in /usr/local/lcls/tools/matlab/LiTrack/SaveFiles/.
 
**NOTE** The mat file will be created automatically in the subdirectory
named "SaveFiles/" of the dierctory where matlab found LiTrack_prepData_LCLS. So
if you're using the production LiTrack_prepData_LCLS in /usr/local/lcls/tools/matlab/LiTrack/
then your file will be created in  /usr/local/lcls/tools/matlab/LiTrack/SaveFiles/,
ready for use by the production LiTrack GUI. However, a running LiTrack GUI doesn't magically
update its listbox of SaveFiles to include the new file, so you'll have to relaunch the 
GUI to use the new file. See TODOs.
 
Nominal Plan
------------
X - put Tim's LiTrack in CVS (not LiT_ES_Scan from github -
  Tim say's too much unvetted stuff)
x - I add code for getting energy and voltage from the control system
- Dorian adds code to use measured profile from TCAV0 to source initial phase space conditions 
- Long Term. we attempt to merge in relevant code from LiT_ES_Scan, to fix the phase simulation.

TODO: 
====
* UI enhancement
  + Add "LCLS" button to Beamline Parameters panel.
* Add reload dir list in Save/Restore files, ParticleFiles, Wakefiles etc. 
* (Environment) Remove . and lcaLib insertions into MATLABPATH in matlabSetup.bash and move to startup.m 
* Add help (link to LiTack app doc on mcc wiki)

Dev dir: ~/Development/litrack/litrack - Tim's Lirack being readied for CVS

Resources
---------
See reference papers emailed by Alex received on Feb/16/2016. 
lclshome RF screens, eg Global/RF.
Operator Klystron Management Panel. edm/display/misc/opsKlys_disp_li20.edl

Plan.
Put Tim's LiTrackl on top of existing LiTrack - since there are name conflicts.
So, first tag existing LiTrack.

Table of Accel Components
1 Mark - generate Plot
2 Dump
6 Compressor
7 Chicane
10 Linac if giving end Energy
11 Linac if giving on-crest Voltage
13 Energy Feedback (E_goal [GW])
15 Resitive Wake (RW)
16 Dechirper
17 CSR
22 ISR
25 Auto-Energy cut (dE energy width)
26 E-cuts (collimator)
27 con-N-Ecut
28 ntch-col [Notched Collimator?]
29 Absolute E-cut
36 Z-cuts
37 Con-N-zcuts
44 T-module
45 E-module
99 Stop - terminate tracking

E_photon ~= 44.5xE_beam^2


Test new login environment:
--------------------------
ssh -t -Y physics@lcls-srv01 env -i /bin/bash --norc --noprofile
cd greg
source ENVS.bash
matlab

==========
Mon Feb 22 2016
Decided to use Tim's LiTrack. Putting it in matlab/toolbox/litrack, not matlab/litrack.
That means cooccrubg release of new matlab env setup, so toolbox/litrack is added to path
and matlab/litrack is removed.

==========
Tue Feb 23 10:32:23 PST 2016
Looked at issue that ParticeFiles, SaveFiles and wakefiles are all dirs that should not
be in teh path, but if they're under simply toolbox/litrack they would be included by
an automatic method. Tried to move them to under etc/, so then etc/ could be put inthe
stoplist for MATLABPATH construction (with CVS/), but ran into bugs in litrack -
inconsistently handling files not in old expected place. Some code sets a principle for
how to be passed files dirs, other code doesn't obey the principle!


Log of putting TJM LiTrack into CVS.
Summary:
 1 Didn't put any *.old in CVS
 2. Comparing files and directories, it seems only files in the parent LiTrack/ dir
    of TJM's zip had material changes from what was in CVS. Beamlines/, support/, and
    accessories/ had no changes w.r.t. CVS.
 3. A number of files that were in TJM's zip have not been (re)added to CVS since they
 were deliberately removed from CVS in 2007.
 
vpn-clients-gw2-113-119:LiTrack greg$ cvs status -l | awk '/Status/'
cvs status: Examining .
File: LiTrack.m         Status: Locally Modified
File: LiTrack_GUI.fig   Status: Locally Modified
File: LiTrack_GUI.m     Status: Locally Modified
File: LiTrack_struc2params.m    Status: Up-to-date
File: dump_LiTrack_output.m     Status: Up-to-date
File: fdbk_fun.m        Status: Up-to-date
File: long_wake.m       Status: Locally Modified
File: readme_to_install.txt     Status: Locally Modified
File: run_LiTrack_GUI.m Status: Locally Modified
File: update_web.txt    Status: Locally Modified

accessories/  - all up to date w.r.t. cvs
Beamlines/    - all up to date w.r.t. cvs
support/      - added: 
./gauss_fun_dd.m
./dechirper_wakefield.m
./integrate.m
./gauss_fun_dc.m
./gauss_fun_db.m
./csr_wakefield.m
ParticleFiles/
  Yuri_conventional_250MeV.zd Looks like was deliberately removed from cvs
SaveFiles/
 Add the following:
  ? ILCpinj2c.mat    Looks like was deliberately removed from cvs 2007/12/05 be emma
  ? Long_SDM.mat     Looks like was deliberately removed from cvs
  ? Medium1.mat      Looks like was deliberately removed from cvs
  ? bline_bypass.mat Looks like was deliberately removed from cvs
  ? bline_new.mat    Looks like was deliberately removed from cvs
  ? fermi0.mat       Looks like was deliberately removed from cvs
  ? lcls_forward.mat Looks like was deliberately removed from cvs
  ? lcls_uniform.mat Looks like was deliberately removed from cvs
  ? mit.mat          Looks like was deliberately removed from cvs
  ? srcfel.mat       Looks like was deliberately removed from cvs
Wakefiles/
  trieste.dat was deliberately removed from cvs
  

ISSUES:
======
BUG 1 (active). Discovered 14-Feb-16. Using new (TJM) LiTrack as chcked into CVS, but using
it from my Greg's account *in the ACR* gets Java AWT error on plotting. 
LiTrack results. Other things being equal, there is no AWT error when I run the
same code from my laptop, so seems associated with 2-head OPIs.
Seems to be avoided by runing the LiTrack GUI on teh same head as teh plot appears.
May be mitigated by using a single figure for GUI. 

BUG 2 (active): Starting LiTrack giving directory names of dirs that are NOT immediate
child dirs of the LiTrack GUI, gets errors at track time. Only happens on prod, not laptop.

BUG 3 (active): After LiTrack has run and painted plot, the main GUI window sometimes reverts to 
some graphical editing mode, so you can't operate it aas a GUI any more!
Again, may be mitigated by using a single figure window GUI.

ISSUE 4 (active): If you create a new "SaveFile" (*.mat) (say with LiTrack_prepData_LCLS tool, there
is not way to make teh GUI re-read the dir. GUI erally should notice and re-load the dir.
Stutus: Wrote util_detectDirChange which demos callback when dir gets new file or deleted file. Could
also solve this by moving those panels to dialogs that prompt for file.

BUG  5 (active ao 4/mar/16) On Prod the Initialization panel interferes with legend.

BUG 6: Legend does not distribute properly above columns (on prod nor laptop)

BUG 7: tool tip for Extant is same as that for design.


 
DEBUG  LOG
==========
BUG 1 (see above): Debuigging 25-Feb-16
----------------------------------------
Java awt error on plotting. Seems NOT to happen is using production 
released LiTrack (Tim's new one), but does when I use my own.
STAT : See CONC of HYP: Java crash caused by unknown problem in my matlab preferences (ii)

INFO: Reporoducers
                        SETUP                                       EXHIBITS BUG
--
1. Prod (running LiTrack from EDM)                                  no
--
2. ACR OPI10 DevOnProd (on lcls-srv01) in ~/greg/Development/litrack      yes
  matlab started from local startup.m in 
  ~/greg/Development/litrack, running 
$ cd ~/greg/Development/litrack
$ matlab
>>  cd lclscvs/matlab/LiTrack
>>  LiTrack_GUI('dir','Wakefiles/','ParticleFiles/','SaveFiles/') 
    select lcls_20160224T2240.mat
    Hit Track
--
3. As 2, but ACR OPI14                                              yes
--
4. As 2 to but from office not ACR!                                 no (!) 
   NOTE: Plot is made in docked graphic figure. Just it tried to 
   to in ACR!

ANA: Reporoducer cond: ACR OPIs use dual head graphics AND my i) startup or ii) matlab Prefs 
or iii) locally checkout out LiTrack.. 
Either of these not so, LiTrack works fine.

HYP: Java crash caused by unknown problem in ~/greg/Development/litrack/startup.m (i)
TEST: Start matlab from my account but not from  ~/greg/Development/litrack nor ~/greg.
METH: Remove ~/greg/matlab, so that that LiTrack is not in path and no other stuff in
~/greg//matlab can be present in test.
mv matlab .matlab
cd  ~/greg/Development/litrack/lclscvs/matlab/LiTrack/
matlab
Put  ~/greg/Development/litrack/lclscvs/matlab/LiTrack/ and subditrs all in the path
RESULT: Still get java crash
CONC: HYP is false. java crash in LiTrack plotting NOT caused by my startup.m

HYP: Java crash caused by locally checked out LiTrack (iii)
TEST: Start matlab from my account but not from  ~/greg/Development/litrack nor ~/greg.
METH: Remove ~/greg/matlab, so that that LiTrack is not in path and no other stuff in
~/greg//matlab can be present in test.
mv matlab .matlab
cd  ~/greg/Development/litrack/lclscvs/
matlab
 DO NOT Put  ~/greg/Development/litrack/lclscvs/matlab/LiTrack/ and subditrs all in the path
(so using cvs co of LiTrack)
Need to work arround BUG 2. - Remove . from path, theh can cd to /greg/Development/litrack/lclscvs/matlab/LiTrack/
prior to starting LiTrack, without using teh LiTrack in that dir.
>> cd matlab/LiTrack/
>>  LiTrack_GUI('dir','Wakefiles/','ParticleFiles/','SaveFiles/')
Get untue error "PulseStacker_150pC..zd does nto exist" - again, seems fiel hadnling is broken. Seems 
finding files is related to path!

HYP: Java crash caused by unknown problem in my matlab preferences (ii)
TEST: avoid my Mat prefs by starting from physics profile
METH
[physics@opi46 ~]$ pwd
/home/physics
[physics@opi46 ~]$ cd greg/Development/litrack/
[physics@opi46 ~/greg/Development/litrack]$ ls
lclscvs  README  startup.m
[physics@opi46 ~/greg/Development/litrack]$ matlab
RES: Plotting was successfull. Minor issue - graphics window wsa configured with Plot Browser and Figure Palett.

CONC: Java AWT issue is related to my (greg) matlab / Java environment.


BUG 2 (active): Starting LiTrack giving directory names of dirs that are NOT immediate
child dirs of the LiTrack GUI, gets errors at track time.
-------------------------------------------
On Prod Hard to debug this one while BUG 1 stopping me run in my development area. Debug on laptop.
OBS: problem doesn't manifest on laptop matlab.







