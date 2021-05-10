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

export CLAS_CALDB_PASS=""
#export CLAS_CALDB_RUNINDEX="RunIndex"

export RECSIS_RUNTIME="${PWD}/recsis"
mkdir -p ${RECSIS_RUNTIME}

tar -xvf parms.tar.gz
export CLAS_PARMS=${PWD}/parms

export data_dir_2pi=/usr/local/2pi_event_generator/
export CLAS_CALDB_RUNINDEX="calib_user.RunIndexe1_6"


# export CLAS_CALDB_HOST=pi0.duckdns.org
# export CLAS_CALDB_USER=root

# export CLAS_CALDB_HOST=clasdb.nickt.codes
# export CLAS_CALDB_USER=clasuser

export CLAS_CALDB_HOST="clasdb.jlab.org"
export CLAS_CALDB_USER=clasreader

export DATE=`date +%m-%d-%Y`

echoerr() { printf "%s\n" "$*" >&1; printf "%s\n" "$*" >&2; }

echoerr "====== cpu info ======"
lscpu
echoerr "====== cpu info ======"

#set -e
STARTTIME=$(date +%s)

echoerr "============ TWOPEG ============"
twopeg_bos.exe < twopi.inp
echoerr "============ end TWOPEG ============"

echoerr "============ start gsim_bat ============"
gsim_bat -ffread $ffread -mcin $bosthrown -kine 1 -bosout $gsimout
echoerr "============ end gsim_bat ============"

echoerr "============ start gpp ============"
gpp -R1 -T0x1 -P0x1f -f1.3 -a2.25 -b2.25 -c2.25 -o$gppout $gsimout
#gpp -ouncooked.bos -R23500 gsim.bos
echoerr "============ end gpp ============"

echoerr "============ splitbos start =========="
$SPLITBOS $gppout -runnum 10 -o $gppout.tmp
echoerr "============ splitbos end =========="

echoerr "============ start user_ana ============"
user_ana -t $tclfile | grep -v HFITGA | grep -v HFITH | grep -v HFNT
echoerr "============ end user_ana ============"

h10maker -rpm $anaout $anarootout

#ls -latr
echoerr "============ cleanup ============"
du -sh *
echoerr "============ cleanup ============"
#rm -rf aao_rad.* anamonhist cooked.bos cooked_chist.hbook gsim.bos parms parms.tar.gz uncooked.bos
echoerr "============ cleanup ============"
du -sh *
echoerr "============ cleanup ============"
df -h .
echoerr "============ cleanup ============"

ENDTIME=$(date +%s)
echo "Hostname: $HOSTNAME"
echo "Total runtime: $(($ENDTIME-$STARTTIME))"
