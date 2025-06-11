#!/bin/bash
# This script will run all CI tests on c5
# Modify ACCOUNT to be your group
# Modify BUILDDIR to be where you have cloned the SHiELD_build repository

export COMPILER="intel"
#export COMP="repro"
ACCOUNT="gfdl_f"
export BUILDDIR="/home/${USER}/SHiELD_dev/SHiELD_build"
RELEASE="`cat ${BUILDDIR}/../SHiELD_SRC/release`"
export SCRATCHDIR="/home/${USER}/SHiELD_dev/SCRATCH/soloCI_amdbox_${RELEASE}/"

mkdir -p ${BUILDDIR}/RTS/CI/stdout

timestamp=$(date "+%Y%m%d_%H%M%S")
echo "Script started at: $timestamp"

SBATCHARGS="--account=${ACCOUNT} --time=00:60:00 --clusters=c5 --output=./stdout/%x.o%j --mail-user=${USER}@noaa.gov --mail-type=fail"

# Cleanup
#rm -rf ${SCRATCHDIR}/CI/BATCH-CI/C96.solo.BCmoist*

# Test Case 13
#./C96.solo.BCmoist.pace_64 2>&1 | tee log.C96.solo.BCmoist.pace_64.${timestamp}.txt
#./C96.solo.BCmoist.pace_32 2>&1 | tee log.C96.solo.BCmoist.pace_32.${timestamp}.txt

#./C96.solo.BCmoist.pace_32_ok 2>&1 | tee log.C96.solo.BCmoist.pace_32_ok.${timestamp}.txt
#./C96.solo.BCmoist.pace_32_ng 2>&1 | tee log.C96.solo.BCmoist.pace_32_ng.${timestamp}.txt

# Test Case 12
#./C96.solo.BCmoist.pace_12_64 2>&1 | tee log.C96.solo.BCmoist.pace_12_64.${timestamp}.txt
#./C96.solo.BCmoist.pace_12_32 2>&1 | tee log.C96.solo.BCmoist.pace_12_32.${timestamp}.txt


# Existing BC moist, non-hydrostatic, sanity check
#./C96.solo.BCmoist 2>&1 | tee log.C96.solo.BCmoist.${timestamp}.txt
#./C96.solo.BCmoist_32 2>&1 | tee log.C96.solo.BCmoist_32.${timestamp}.txt


# Debug
rm -rf ${SCRATCHDIR}/CI/BATCH-CI/C96.solo.BCmoist.pace_test1*_debug

./C48.solo.BCmoist.pace_test13_64_debug | tee log.C48.solo.BCmoist..pace_test13_64_debug.${timestamp}.txt
./C48.solo.BCmoist.pace_test13_32_debug | tee log.C48.solo.BCmoist..pace_test13_32_debug.${timestamp}.txt
./C48.solo.BCmoist.pace_test12_64_debug | tee log.C48.solo.BCmoist..pace_test12_64_debug.${timestamp}.txt
./C48.solo.BCmoist.pace_test12_32_debug | tee log.C48.solo.BCmoist..pace_test12_32_debug.${timestamp}.txt
