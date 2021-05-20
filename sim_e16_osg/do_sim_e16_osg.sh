#!/bin/bash
export CLAS_PARMS=/data/parms
export ROOTSYS=/usr/local/root
export MYSQLINC=/usr/include/mysql
export MYSQLLIB=/usr/lib64/mysql
export CLAS6=/usr/local/clas-software/build
export PATH=$CLAS6/bin:$PATH
export CERN=/usr/local/cernlib/x86_64_rhel6
export CERN_LEVEL=2005
export CERN_ROOT=$CERN/$CERN_LEVEL
export CVSCOSRC=$CERN/$CERN_LEVEL/src
export PATH=$CERN/$CERN_LEVEL/src:$PATH
export CERN_LIB=$CERN_ROOT/lib
export CERNLIB=$CERN_ROOT/lib
export CERN_BIN=$CERN_ROOT/bin
export CLAS_TOOL=/usr/local/clas-software/analysis/ClasTool
export PATH=$PATH:$CLAS_TOOL/bin/Linux
export LD_LIBRARY_PATH=$ROOTSYS/lib:$CLAS_TOOL/slib/Linux:$CLAS6/lib

source $ROOTSYS/bin/thisroot.sh

# export TMPDIR=$(mktemp -d -p ${PWD})
# echo $TMPDIR
echo "check directory"
pwd
ls

export CLAS_CALDB_PASS=""
#export CLAS_CALDB_RUNINDEX="RunIndex"

export RECSIS_RUNTIME="${PWD}/recsis"
mkdir -p ${RECSIS_RUNTIME}

tar -xvf parms.tar.gz
export CLAS_PARMS=${PWD}/parms

export data_dir_2pi=/usr/local/2pi_event_generator/
export CLAS_CALDB_RUNINDEX="calib_user.RunIndexe1_6"


#Define filenames
export bosthrown=out.bos
export gsimout=gsim.out
export gppout=gpp.out
export tclfile=user_ana_e16.tcl
export ffread=gsim_e16.inp
export anaout=ana.out
export a1cout=a1c.out
export anarootout=cooked_ana.root
export anamergeout=cooked_ana_merged.root
export sigmafile=tree_sigma.root

# export CLAS_CALDB_HOST=pi0.duckdns.org
# export CLAS_CALDB_USER=root

# export CLAS_CALDB_HOST=clasdb.nickt.codes
# export CLAS_CALDB_USER=clasuser

export CLAS_CALDB_HOST="clasdb.jlab.org"
export CLAS_CALDB_USER=clasreader

which twopeg_bos.exe

export DATE=`date +%m-%d-%Y`
echo $DATE

echoerr() { printf "%s\n" "$*" >&1; printf "%s\n" "$*" >&2; }

echoerr "====== cpu info ======"
lscpu
echoerr "====== cpu info ======"

#set -e
STARTTIME=$(date +%s)

echoerr "============ TWOPEG ============"
#env 
twopeg_bos.exe < twopi_e16.inp
echoerr "============ end TWOPEG ============"
du -sh *
if [ -f $bosthrown ]; then
	echoerr "Event Generated File Exists: $bosthrown"
	echoerr "============ start gsim_bat ============"
	gsim_bat -ffread $ffread -mcin $bosthrown -kine 1 -bosout $gsimout
	echoerr "============ end gsim_bat ============"
	du -sh *
	if [ -f $gsimout ]; then
		echoerr "$gsimout Generated"
		echoerr "============ start gpp ============"
		gpp -R1 -T0x1 -P0x1f -f1.3 -a2.25 -b2.25 -c2.25 -o$gppout $gsimout
		#gpp -ouncooked.bos -R23500 gsim.bos
		echoerr "============ end gpp ============"
		du -sh *
		if [ -f $gppout ]; then
			echoerr "$gppout Generated"
			echoerr "============ splitbos start =========="
			splitbos $gppout -runnum 10 -o $gppout.tmp
			echoerr "============ splitbos end =========="
			du -sh *
			if [ -f $gppout.tmp ]; then
				echoerr "$gppout.tmp Generated"
				echoerr "============ start user_ana ============"
				user_ana -t $tclfile | grep -v HFITGA | grep -v HFITH | grep -v HFNT
				echoerr "============ end user_ana ============"
				du -sh *
if [ -f $anaout ]; then
	echoerr "============ start h10maker ============"
	h10maker -rpm $anaout $anarootout
	echoerr "============ end h10maker ============"
#ls -latr
echoerr "============ cleanup ============"
du -sh *
echoerr "============ cleanup ============"
rm -rf ana.hbook $anaout gpp.hbook $gppout $gppout.tmp $gsimout $ffread $bosthrown out_hist_test.root parms parms.tar.gz twopi_e16.inp $tclfile
echoerr "============ cleanup ============"
du -sh *
echoerr "============ cleanup ============"
df -h .
echoerr "============ cleanup ============"

ENDTIME=$(date +%s)
echo "Hostname: $HOSTNAME"
echo "Total runtime: $(($ENDTIME-$STARTTIME))"
