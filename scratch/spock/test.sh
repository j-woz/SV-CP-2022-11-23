#!/bin/bash -l
set -eu

if (( ${#} != 1 ))
then
  echo "Provide the workflow!"
  exit 1
fi

WORKFLOW=$1

MED106=/gpfs/alpine/world-shared/med106
ROOT=$MED106/sw/spock/gcc-10.3.0
SWIFT=$ROOT/swift-t/2021-10-05

PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

PY=/gpfs/alpine/med106/world-shared/hsyoo/spock_tf2_py37_rocm42

which swift-t

export PROJECT=MED106
export QUEUE=ecp
export WALLTIME=00:05:00
export PROCS=2
export PPN=2

export TURBINE_LAUNCHER=srun

set -x
swift-t -m slurm -n $PROCS -e PYTHONHOME=$PY $WORKFLOW
