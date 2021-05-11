source /data/parms/recsis/recsis_proc.tcl;

#
# define packages
turnoff ALL;
global_section off;
turnon seb trk cc tof egn lac pid user;
#
# additional trigger:
# set trigger_particle_s 2212;
#
#
inputfile gpp.out.tmp;
#inputfile GSIM.OUT
setc chist_filename ana.hbook;
setc log_file_name logfile;
outputfile ana.out PROC 2047;
setc prlink_file_name  "prlink_e16_tg4.bos";
setc bfield_file_name  "bgrid_T67to33.fpk";
#
#level of analysis 0: raw  2: hbt 4: tbt
#set trk_level 4;
#set trk_maxiter 6;
#
set dc_xvst_choice     0;
set torus_current      3375;
set mini_torus_current 6000;
set poltarget_current  0;
set TargetPos(3)       -4.;
set ntswitch 1;

#
# Franz's tcl variables
set trk_maxiter       8;
set trk_minhits(1)    2;
set trk_lrambfit_chi2 50.;
set trk_tbtfit_chi2   70.;
set trk_prfit_chi2    70.;
set trk_statistics    3 ;
#

#set ltrk_do    -1;
#set legn_do    -1;
#set lcc_do     -1;
#set ltof_do    -1;
#set lst_do      0;
#set ltime_do   -1;
#set lec1_do    -1;
#set lseb_do    -1;
#set lrf_do      0;

set ltrk_h_do    0;
set legn_h_do    0;
set lcc_h_do     0;
set ltof_h_do    0;
set lst_h_do      0;
set ltime_h_do   0;
set lec1_h_do    0;
set lusr0_h_do    0;
set lusr1_h_do    0;
set lseb_h_do    0;

set lall_nt_do      -1;
set lmctk_nt_do     -1;
set lseb_nt_do      -1;
set lseb_hist       0;
set lmon_hist         0;
set lfec_hist       0;
set l_nt_do         0;
set lpart_nt_do     -1;
set lmvrt_nt_do     0;

set lpid_make_trks   0;
set ltbid_nost_do   0;

set nt_id_cut 0;

#set def_geom -1;
#set def_adc -1;
#set def_tdc -1;
#set def_atten  0;
#set whole_surf 16.;
#set inner_surf 1.;
#set outer_surf 28.;
#set m2_ecel_cut 1000.;
#set m3_ecel_cut 10000.;
#set trkec__match 50;

setc outbanknames(1) "HEADHLS DC0 CC  SC  EC1 EC  CALLPARTTBIDHEVTEVNTDCPBCCPBSCPBECPBLCPBTGBIFBPMCL01TBLATRGSTRPBTBERMCTKMCVX";

fpack "timestop -9999999999"
set lscat $false;
set ldisplay_all $false;
setc rec_prompt "[exec whoami]_recsis> ";

go 1000000;
status;
exit_pend;
