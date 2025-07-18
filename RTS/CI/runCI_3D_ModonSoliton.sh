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

# SBATCHARGS="--account=${ACCOUNT} --time=00:60:00 --clusters=c5 --output=./stdout/%x.o%j --mail-user=${USER}@noaa.gov --mail-type=fail"

# NOTE: These tests don't really work.... I'll keep it just to have it in case I ever try to debug in the future.
#test_list=(C128.solo.3dmodon_64_debug, C128.solo.3dmodon_test45_64_1_day_debug)
#test_list=(C128.solo.3dmodon_test45_64_1_day_debug)

#for test_name in "${test_list[@]}"; do
#  echo "Processing: ${test_name}"
#  ./${test_name} | tee log.${test_name}.${timestamp}.txt
#done





# Test modified directly from Joseph's test with Rusty (run with prod)
#./C128.solo.modon
./C128.solo.modon_zeroday
