#!/bin/bash
# This script will run all CI tests on c5
# Modify ACCOUNT to be your group
# Modify BUILDDIR to be where you have cloned the SHiELD_build repository

export COMPILER="intel"
export COMP="repro"
ACCOUNT="gfdl_f"
export BUILDDIR="/home/${USER}/SHiELD_dev/SHiELD_build"
RELEASE="`cat ${BUILDDIR}/../SHiELD_SRC/release`"
export SCRATCHDIR="/home/${USER}/SHiELD_dev/SCRATCH/soloCI_amdbox_${RELEASE}/"

mkdir -p ${BUILDDIR}/RTS/CI/stdout

timestamp=$(date "+%Y%m%d_%H%M%S")
echo "Script started at: $timestamp"

SBATCHARGS="--account=${ACCOUNT} --time=00:60:00 --clusters=c5 --output=./stdout/%x.o%j --mail-user=${USER}@noaa.gov --mail-type=fail"
# Test Case 13
./C96.solo.BCmoist.pace_64 2>&1 | tee log.C96.solo.BCmoist.pace_64.${timestamp}.txt
./C96.solo.BCmoist.pace_32 2>&1 | tee log.C96.solo.BCmoist.pace_32.${timestamp}.txt

# Test Case 12
./C96.solo.BCmoist.pace_12_64 2>&1 | tee log.C96.solo.BCmoist.pace_12_64.${timestamp}.txt
./C96.solo.BCmoist.pace_12_32 2>&1 | tee log.C96.solo.BCmoist.pace_12_32.${timestamp}.txt


# Existing BC moist, non-hydrostatic, sanity check
./C96.solo.BCmoist 2>&1 | tee log.C96.solo.BCmoist.${timestamp}.txt
