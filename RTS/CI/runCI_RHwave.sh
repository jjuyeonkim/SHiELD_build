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

SBATCHARGS="--account=${ACCOUNT} --time=00:60:00 --clusters=c5 --output=./stdout/%x.o%j --mail-user=${USER}@noaa.gov --mail-type=fail"
./C96.sw.RHwave.init3_64
./C96.sw.RHwave.init3_32
