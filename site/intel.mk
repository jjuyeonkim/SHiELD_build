# template for the Intel fortran compiler
# typical use with mkmf
# mkmf -t template.ifc -c"-Duse_libMPI -Duse_netCDF" path_names /usr/local/include
############
# commands #
############
#FC = ftn
#CC = cc
#CXX = CC
#LD = ftn
#########
# flags #
#########
DEBUG =
REPRO =
VERBOSE =
OPENMP =
PIC =

##############################################
# Need to use at least GNU Make version 3.81 #
##############################################
need := 3.81
ok := $(filter $(need),$(firstword $(sort $(MAKE_VERSION) $(need))))
ifneq ($(need),$(ok))
$(error Need at least make version $(need).  Load module gmake/3.81)
endif

MAKEFLAGS += --jobs=8

NETCDF_ROOT = $(NETCDF_DIR)
MPI_ROOT    = $(MPICH_DIR)
# start with blank LIB
LIBS :=

ifneq (`nc-config --libs`,)
  INCLUDE = `nf-config --fflags` `nc-config --cflags`
  LIBS += `nf-config --flibs` `nc-config --libs`
else
  INCLUDE = -I$(NETCDF_ROOT)/include
  LIBS += -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz
endif
INCLUDE += $(shell pkg-config --cflags yaml-0.1)
FPPFLAGS := -fpp -Wp,-w $(INCLUDE)
CPPFLAGS := $(shell pkg-config --cflags yaml-0.1)

FFLAGS := $(INCLUDE) -fno-alias -auto -safe-cray-ptr -ftz -assume byterecl -nowarn -sox -align array64byte -traceback

ifeq ($(32BIT),Y)
FFLAGS += -DOVERLOAD_R4 -DOVERLOAD_R8 -i4 -real-size 32
else
FFLAGS += -i4 -real-size 64 -no-prec-div -no-prec-sqrt
endif

ifeq ($(AVX),Y)
FFLAGS += $(AVX_LEVEL) -qno-opt-dynamic-align
CFLAGS += $(AVX_LEVEL) -qno-opt-dynamic-align
else
FFLAGS += -xCORE-AVX-I -qno-opt-dynamic-align
CFLAGS += -xCORE-AVX-I -qno-opt-dynamic-align
endif

# For some applications, namely wrapping SHiELD in Python, it can be required to
# compile all libraries as position independent code. Setting the PIC option to
# 'Y' with this Makefile template will enable this.
ifeq ($(PIC),Y)
FFLAGS += -fPIC
CFLAGS += -fPIC
CPPFLAGS += -fPIC
endif

FFLAGS_OPT = -O2 -debug minimal -fp-model source -qoverride-limits -qopt-prefetch=3
FFLAGS_REPRO = -O2 -debug minimal -fp-model source -qoverride-limits #-fpe0 #causes problems??
FFLAGS_DEBUG = -g -O0 -debug -check -check noarg_temp_created -check nopointer -warn -warn noerrors -fp-stack-check -fstack-protector-all -fpe0 -ftrapuv

TRANSCENDENTALS := -fast-transcendentals
FFLAGS_OPENMP = -qopenmp
FFLAGS_VERBOSE = -v -V -what

CFLAGS := -D__IFC -sox -msse2
ifeq ($(AVX2),Y)
#CFLAGS += -xHOST -xCORE-AVX2 -qno-opt-dynamic-align
endif

CFLAGS_OPT = -O2 -debug minimal
CFLAGS_REPRO = -O2 -debug minimal
CFLAGS_OPENMP = -qopenmp
CFLAGS_DEBUG = -O0 -g -ftrapuv -traceback

# Optional Testing compile flags.  Mutually exclusive from DEBUG, REPRO, and OPT
# *_TEST will match the production if no new option(s) is(are) to be tested.
FFLAGS_TEST = -O3 -debug minimal -fp-model source -qoverride-limits
CFLAGS_TEST = -O2

LDFLAGS :=
LDFLAGS_OPENMP := -qopenmp
LDFLAGS_VERBOSE := -Wl,-V,--verbose,-cref,-M

ifneq ($(REPRO),)
CFLAGS += $(CFLAGS_REPRO)
FFLAGS += $(FFLAGS_REPRO)
FAST :=
else ifneq ($(DEBUG),)
CFLAGS += $(CFLAGS_DEBUG)
FFLAGS += $(FFLAGS_DEBUG)
FAST :=
else ifneq ($(TEST),)
CFLAGS += $(CFLAGS_TEST)
FFLAGS += $(FFLAGS_TEST)
FAST :=
else
CFLAGS += $(CFLAGS_OPT)
FFLAGS += $(FFLAGS_OPT)
FAST := $(TRANSCENDENTALS)
endif

ifneq ($(OPENMP),)
CFLAGS += $(CFLAGS_OPENMP)
FFLAGS += $(FFLAGS_OPENMP)
LDFLAGS += $(LDFLAGS_OPENMP)
endif

ifneq ($(VERBOSE),)
CFLAGS += $(CFLAGS_VERBOSE)
FFLAGS += $(FFLAGS_VERBOSE)
LDFLAGS += $(LDFLAGS_VERBOSE)
endif

ifeq ($(NETCDF),3)
  # add the use_LARGEFILE cppdef
  ifneq ($(findstring -Duse_netCDF,$(CPPDEFS)),)
    CPPDEFS += -Duse_LARGEFILE
  endif
endif

LIBS += $(shell pkg-config --libs yaml-0.1)
LDFLAGS += $(LIBS)

#---------------------------------------------------------------------------
# you should never need to change any lines below.

# see the MIPSPro F90 manual for more details on some of the file extensions
# discussed here.
# this makefile template recognizes fortran sourcefiles with extensions
# .f, .f90, .F, .F90. Given a sourcefile <file>.<ext>, where <ext> is one of
# the above, this provides a number of default actions:

# make <file>.opt       create an optimization report
# make <file>.o         create an object file
# make <file>.s         create an assembly listing
# make <file>.x         create an executable file, assuming standalone
#                       source
# make <file>.i         create a preprocessed file (for .F)
# make <file>.i90       create a preprocessed file (for .F90)

# The macro TMPFILES is provided to slate files like the above for removal.

RM = rm -f
ifeq (${SHELL},csh)
 SHELL = /bin/csh -f
else
 SHELL = /bin/bash -f
endif
TMPFILES = .*.m *.B *.L *.i *.i90 *.l *.s *.opt

.SUFFIXES: .F .F90 .H .L .T .f .f90 .h .i .i90 .l .o .s .opt .x

.f.L:
	$(FC) $(FFLAGS) -c -listing $*.f
.f.opt:
	$(FC) $(FFLAGS) -c -opt_report_level max -opt_report_phase all -opt_report_file $*.opt $*.f
.f.o:
	$(FC) $(FFLAGS) -c $*.f
.f.l:
	$(FC) $(FFLAGS) -c $(LIST) $*.f
.f.T:
	$(FC) $(FFLAGS) -c -cif $*.f
.f.s:
	$(FC) $(FFLAGS) -S $*.f
.f.x:
	$(FC) $(FFLAGS) -o $*.x $*.f *.o $(LDFLAGS)
.f90.L:
	$(FC) $(FFLAGS) -c -listing $*.f90
.f90.opt:
	$(FC) $(FFLAGS) -c -opt_report_level max -opt_report_phase all -opt_report_file $*.opt $*.f90
.f90.l:
	$(FC) $(FFLAGS) -c $(LIST) $*.f90
.f90.T:
	$(FC) $(FFLAGS) -c -cif $*.f90
.f90.o:
	$(FC) $(FFLAGS) -c $*.f90
.f90.s:
	$(FC) $(FFLAGS) -c -S $*.f90
.f90.x:
	$(FC) $(FFLAGS) -o $*.x $*.f90 *.o $(LDFLAGS)
.F.L:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -listing $*.F
.F.opt:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -opt_report_level max -opt_report_phase all -opt_report_file $*.opt $*.F
.F.l:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c $(LIST) $*.F
.F.T:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -cif $*.F
.F.f:
	$(FC) $(CPPDEFS) $(FPPFLAGS) -EP $*.F > $*.f
.F.i:
	$(FC) $(CPPDEFS) $(FPPFLAGS) -P $*.F
.F.o:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c $*.F
.F.s:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -S $*.F
.F.x:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -o $*.x $*.F *.o $(LDFLAGS)
.F90.L:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -listing $*.F90
.F90.opt:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -opt_report_level max -opt_report_phase all -opt_report_file $*.opt $*.F90
.F90.l:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c $(LIST) $*.F90
.F90.T:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -cif $*.F90
.F90.f90:
	$(FC) $(CPPDEFS) $(FPPFLAGS) -EP $*.F90 > $*.f90
.F90.i90:
	$(FC) $(CPPDEFS) $(FPPFLAGS) -P $*.F90
.F90.o:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c $*.F90
.F90.s:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -c -S $*.F90
.F90.x:
	$(FC) $(CPPDEFS) $(FPPFLAGS) $(FFLAGS) -o $*.x $*.F90 *.o $(LDFLAGS)
