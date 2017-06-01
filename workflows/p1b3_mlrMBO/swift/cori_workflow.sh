#! /usr/bin/env bash

set -eu

if [ "$#" -ne 1 ]; then
  script_name=$(basename $0)
  echo "Usage: ${script_name} EXPERIMENT_ID (e.g. ${script_name} experiment_1)"
  exit 1
fi

# uncomment to turn on swift/t logging. Can also set TURBINE_LOG,
# TURBINE_DEBUG, and ADLB_DEBUG to 0 to turn off logging
#export TURBINE_LOG=1 TURBINE_DEBUG=1 ADLB_DEBUG=1
export EMEWS_PROJECT_ROOT=$( cd $( dirname $0 )/.. ; /bin/pwd )
# source some utility functions used by EMEWS in this script
source "${EMEWS_PROJECT_ROOT}/etc/emews_utils.sh"

export EXPID=$1
export TURBINE_OUTPUT=$EMEWS_PROJECT_ROOT/experiments/$EXPID
check_directory_exists

# TODO edit the number of processes as required.
# Cori: 32 cores per node, 128GB per node
export PROCS=4

# TODO edit QUEUE, WALLTIME, PPN, AND TURNBINE_JOBNAME
# as required. Note that QUEUE, WALLTIME, PPN, AND TURNBINE_JOBNAME will
# be ignored if MACHINE flag (see below) is not set
# see http://www.nersc.gov/users/computational-systems/cori/running-jobs/queues-and-policies/
export QUEUE=debug
export WALLTIME=00:30:00
export PPN=4
export TURBINE_JOBNAME="${EXPID}_job"

# if R cannot be found, then these will need to be
# uncommented and set correctly.
# export R_HOME=/path/to/R
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$R_HOME/lib
# export PYTHONHOME=

P1B3_DIR=$EMEWS_PROJECT_ROOT/../../../Benchmarks/Pilot1/P1B3
export R_HOME=/global/u1/w/wozniak/Public/sfw/R-3.4.0/lib64/R/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/global/u1/w/wozniak/Public/sfw/R-3.4.0/lib64/R/lib
export PYTHONPATH=$EMEWS_PROJECT_ROOT/python:$P1B3_DIR
export PYTHONHOME=/global/common/cori/software/python/2.7-anaconda/envs/deeplearning/

export TURBINE_DIRECTIVE="#SBATCH --constraint=haswell\n#SBATCH --license=SCRATCH"

# Resident task workers and ranks
export TURBINE_RESIDENT_WORK_WORKERS=1
export RESIDENT_WORK_RANKS=$(( PROCS - 2 ))

# EQ/R location
EQR=$EMEWS_PROJECT_ROOT/ext/EQ-R

# how many to evaluate concurrently
MAX_CONCURRENT_EVALUATIONS=2
MAX_ITERATIONS=3
PARAM_SET_FILE="$EMEWS_PROJECT_ROOT/data/parameter_set.R"

# TODO edit command line arguments, e.g. -nv etc., as appropriate
# for your EQ/R based run. $* will pass all of this script's
# command line arguments to the swift script
CMD_LINE_ARGS="$* -pp=$MAX_CONCURRENT_EVALUATIONS -it=$MAX_ITERATIONS "
CMD_LINE_ARGS+="-param_set_file=$PARAM_SET_FILE "

# Uncomment this for the BG/Q:
#export MODE=BGQ QUEUE=default

# set machine to your schedule type (e.g. pbs, slurm, cobalt etc.),
# or empty for an immediate non-queued unscheduled run
MACHINE="slurm"

if [ -n "$MACHINE" ]; then
  MACHINE="-m $MACHINE"
fi

# Add any script variables that you want to log as
# part of the experiment meta data to the USER_VARS array,
# for example, USER_VARS=("VAR_1" "VAR_2")
USER_VARS=($CMD_LINE_ARGS)
# log variables and script to to TURBINE_OUTPUT directory
log_script

# echo's anything following this to standard out
set -x
SWIFT_FILE=workflow.swift
swift-t -n $PROCS $MACHINE -p -I $EQR -r $EQR $EMEWS_PROJECT_ROOT/swift/$SWIFT_FILE $CMD_LINE_ARGS