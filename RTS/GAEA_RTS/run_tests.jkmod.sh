#!/bin/sh


#All tests in GAEA_RTS assume that you have cloned SHiELD_build at this location:
#BUILD_AREA = "/ncrc/home1/${USER}/SHiELD_dev/SHiELD_build/"
#The run directories will be at (as defined by the test scripts):
#/gpfs/f5/${YourGroup}/scratch/${USER}/SHiELD_${RELEASE}
#where YourGroup is defined in the runscripts and
#RELEASE is defined in CHECKOUT_code when the code was compiled

# NOTE: Trying to see which ones work with the C48_res script...
#   32bit intel ok
#   32bit gnu segfault
#   64bit intel ok
#   64bit gnu segfault
export COMPILER="intel"
export MODE="64bit"
export COMP="repro"
ACCOUNT="gfdl_f"

# Adding for serialbox
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/ncrc/home1/${USER}/work/20260129_translate_tests/serialbox2/install/lib
echo $LD_LIBRARY_PATH

mkdir -p stdout

sbatch C48_res.jkmod.csh --mail-user=${USER}@noaa.gov --mail-type=fail --account=${ACCOUNT}




################# Oliver's scripts use:
#export COMPILER="gnu"
#export MODE="64bit"
#export COMP="debug"
