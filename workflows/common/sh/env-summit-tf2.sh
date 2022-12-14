
# DEPRECATED 2021-10-01: Use env-summit
# ENV Summit TF2
# Environment settings for Summit (Swift, Python, R, Tcl, etc.)
# GCC 8.3.1, TensorFlow 2.4.1, opence 1.2.0-py38-0, R 3.6.1

SWIFT_IMPL=py

# Let modules initialize LD_LIBRARY_PATH before changing it:
set +eu # modules create errors outside our control
module load spectrum-mpi/10.4.0.3-20210112
module unload darshan-runtime
module load open-ce/1.2.0-py38-0
module list
set -eu

# From Wozniak
MED106=/gpfs/alpine/world-shared/med106
ROOT=$MED106/sw/gcc-8.3.1
SWIFT=$ROOT/swift-t/2021-08-27

PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

R=/gpfs/alpine/world-shared/med106/wozniak/sw/gcc-6.4.0/R-3.6.1/lib64/R
LD_LIBRARY_PATH+=:$R/lib

PYTHON=$( which python3 )
export PYTHONHOME=$( dirname $( dirname $PYTHON ) )

# EMEWS Queues for R
EQR=$MED106/wozniak/sw/gcc-6.4.0/EQ-R
EQPy=$WORKFLOWS_ROOT/common/ext/EQ-Py

# For test output processing:
LOCAL=0
CRAY=1

# Resident task worker count and rank list
# If this is already set, we respect the user settings
# If this is unset, we set it to 1
#    and run the algorithm on the 2nd highest rank
# This value is only read in HPO workflows
if [[ ${TURBINE_RESIDENT_WORK_WORKERS:-} == "" ]]
then
    export TURBINE_RESIDENT_WORK_WORKERS=1
    export RESIDENT_WORK_RANKS=$(( PROCS - 2 ))
fi
