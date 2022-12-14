
# ENV Summit Interactive
# Environment settings for Summit (Swift, Python, R, Tcl, etc.)
# GCC 6.4.0, TensorFlow 1, condaenv-200408, R 3.6.1

# SWIFT_IMPL=echo
SWIFT_IMPL=py

# Let modules initialize LD_LIBRARY_PATH before changing it:
set +eu # modules create errors outside our control
module load spectrum-mpi/10.3.1.2-20200121
module unload darshan-runtime
# module load ibm-wml-ce/1.6.2-3
module list
set -eu

# From Wozniak
MED106=/gpfs/alpine/world-shared/med106
# SWIFT=$MED106/sw/gcc-7.4.0/swift-t/2019-10-18  # Python (ibm-wml), no R
# SWIFT=$MED106/sw/gcc-7.4.0/swift-t/2019-11-06  # Python (ibm-wml) and R
# Python (ibm-wml-ce/1.7.0-1) and R:
# SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-03-31-c
# Python (ibm-wml-ce/1.6.2-3) and R:
# SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-04-02
# Python (med106/sw/condaenv-200408) and R:
# SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-04-08
# SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-04-11
# SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-08-19
SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-09-02

export TURBINE_HOME=$SWIFT/turbine
PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

# log_path PATH

# IBM_WML_CE=/autofs/nccs-svm1_sw/summit/ibm-wml-ce/anaconda-base/envs/ibm-wml-ce-1.6.2-3

# export LD_LIBRARY_PATH
# LD_LIBRARY_PATH=$IBM_WML_CE/lib:$LD_LIBRARY_PATH

# Inject Python to PATH using PRELAUNCH:
# This would be better, but is broken for ZSH users:
# module load ibm-wml-ce/1.6.2-3
# Must use PATH directly:
# export TURBINE_PRELAUNCH="PATH=$IBM_WML_CE/bin:\$PATH"

R=/gpfs/alpine/world-shared/med106/wozniak/sw/gcc-6.4.0/R-3.6.1/lib64/R
LD_LIBRARY_PATH+=:$R/lib

PY=/gpfs/alpine/world-shared/med106/sw/condaenv-200408
# LD_LIBRARY_PATH+=:$PY/lib
export PYTHONHOME=$PY

PATH=$PY/bin:$PATH

export LD_LIBRARY_PATH=$PY/lib:$LD_LIBRARY_PATH

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

