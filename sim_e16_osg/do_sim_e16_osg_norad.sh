#!/bin/bash
#export CLAS_PARMS=/data/parms
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
export CLAS_CALDB_HOST="clasdb.jlab.org"
export CLAS_CALDB_USER=clasreader


#Define filenames
export bosthrown=nr_out.bos
export gsimout=nr_gsim.out
export rootout=cooked.root
export sigmafile=tree_sigma.root

# export CLAS_CALDB_HOST=pi0.duckdns.org
# export CLAS_CALDB_USER=root

# export CLAS_CALDB_HOST=clasdb.nickt.codes
# export CLAS_CALDB_USER=clasuser




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
which twopeg_bos.exe
twopeg_bos.exe < twopi_e16_norad.inp
echoerr "------------ mini cleanup -----------"
echoerr "removing twopi_e16_norad.inp"
rm twopi_e16_norad.inp
echoerr "------------ mini cleanup -----------"
echoerr "============ end TWOPEG ============"
du -sh *
#if [ -s $bosthrown ]; then
#	echoerr "Event Generated File Exists: $bosthrown"
#	echoerr "============ start gsim_bat ============"
#	which gsim_bat
#	gsim_bat -ffread $ffread -mcin $bosthrown -kine 1 -bosout $gsimout
#	echoerr "------------ mini cleanup -----------"
#	echoerr "removing $bosthrown and $ffread"
#	rm $bosthrown
#	rm $ffread
#	echoerr "------------ mini cleanup -----------"
#fi
#if [ -s $gsimout ]; then
if [ -s $bosthrown ]; then
	echoerr "============ start h10maker ============"
	which h10maker
	#h10maker -rpm $gsimout $rootout
	h10maker -rpm $bosthrown $rootout
	#rm $gsimout
	rm $bosthrown
	echoerr "============ end h10maker ============"
else
	#If there is no cooked output, don't want to include an unpaired weight file pointlessly taking up space
	echoerr "No $anaout that was not of size zero"
	if [ -s tree_sigma.root ]; then
		echoerr "removing extraneous tree_sigma.root file"
		rm tree_sigma.root
	else
		echoerr "No good tree_sigma.root file either"
	fi
fi
#ls -latr
echoerr "============ cleanup1 ============"
du -sh *
echoerr "============ cleanup2 ============"
rm -rf ana.hbook gpp.hbook out_hist_test.root parms parms.tar.gz
echoerr "============ cleanup3 ============"
du -sh *
echoerr "============ cleanup4 ============"
df -h .
echoerr "============ cleanup5 ============"

ENDTIME=$(date +%s)
echo "Hostname: $HOSTNAME"
echo "Total runtime: $(($ENDTIME-$STARTTIME))"
