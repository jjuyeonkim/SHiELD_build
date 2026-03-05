#!/bin/bash
# This script will run a modified versions of the CI tests to generate SerialBox data
# Modify ACCOUNT to be your group
# Modify BUILDDIR to be where you have cloned the SHiELD_build repository

export COMPILER="gnu"
export COMP="debug"
ACCOUNT="gfdl_f"
export BUILDDIR="/ncrc/home1/${USER}/work/20260129_translate_tests/cleaner/SHiELD_build"
RELEASE="`cat ${BUILDDIR}/../SHiELD_SRC/release`"
export SCRATCHDIR="/gpfs/f5/${ACCOUNT}/scratch/${USER}/soloSerialBoxCollection_C5_debug_${RELEASE}/"

# Adding for serialbox
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/ncrc/home1/Janice.Kim/work/20260129_translate_tests/serialbox2/install/lib
echo $LD_LIBRARY_PATH
ldd $executable
echo $SCRATCHDIR

mkdir -p ${BUILDDIR}/RTS/CI/stdout

SBATCHARGS="--account=${ACCOUNT} --time=00:60:00 --clusters=c5 --output=./stdout/%x.o%j --mail-user=${USER}@noaa.gov --mail-type=fail"
sbatch ${SBATCHARGS} --nodes=1 C96.solo.BCdry.1day
#sbatch ${SBATCHARGS} --nodes=1 C96.solo.BCdry
#sbatch ${SBATCHARGS} --nodes=1 C96.solo.BCmoist

# NOTE: COMP is hard-coded to "debug" in C96.solo.BCdry.1day.debug.ddt
#sbatch ${SBATCHARGS} --nodes=1 C96.solo.BCdry.1day.debug.ddt
