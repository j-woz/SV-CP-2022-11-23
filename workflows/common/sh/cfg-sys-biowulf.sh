#!/bin/bash

# UPF CFG SYS 1

# The number of MPI processes
# Note that 1 processes is reserved for Swift/T
# For example, if PROCS=4 that gives you 3 workers,
# i.e., 3 concurrent Keras runs.
export PROCS=${PROCS:-4}

# MPI processes per node.  This should not exceed PROCS.
# Cori has 32 cores per node, 128GB per node
export PPN=${PPN:-1}

#export QUEUE=${QUEUE:-batch}

# Cori: (cf. sched-cori)
# export QUEUE=${QUEUE:-debug}
# Cori queues: debug, regular
# export QUEUE=regular
#export QUEUE=debug
export QUEUE=${QUEUE:-gpu}
# CANDLE on Cori:
# export PROJECT=m2924

# Theta: (cf. sched-theta)
# export QUEUE=${QUEUE:-debug-cache-quad}
# export PROJECT=${PROJECT:-ecp-testbed-01}
# export PROJECT=Candle_ECP
# export PROJECT=CSC249ADOA01

export WALLTIME=${WALLTIME:-00:10:00}

#export TURBINE_SBATCH_ARGS=${TURBINE_SBATCH_ARGS:-}

#export TURBINE_SBATCH_ARGS="--gres=gpu:${GPU_TYPE:-k20x}:1 --mem=${MEM_PER_NODE:-20G} --cpus-per-task=${CPUS_PER_TASK:-1}"
#export TURBINE_SBATCH_ARGS=${TURBINE_SBATCH_ARGS}${TURBINE_SBATCH_ARGS:+ }"--gres=gpu:${GPU_TYPE:-k20x}:1 --mem=${MEM_PER_NODE:-20G} --cpus-per-task=${CPUS_PER_TASK:-1}"

# export MAIL_ENABLED=1
# export MAIL_ADDRESS=wozniak@mcs.anl.gov

# Benchmark run timeout: benchmark run will timeouT
# after the specified number of seconds. -1 is no timeout.
BENCHMARK_TIMEOUT=${BENCHMARK_TIMEOUT:-3600} # probably not needed but this variable is baked into rest of code, e.g., workflow.sh

# Uncomment below to use custom python script to run
# Use file name without .py (e.g, my_script.py)
# BENCHMARK_DIR=/path/to/
# MODEL_PYTHON_SCRIPT=my_script
#BENCHMARK_DIR=/data/BIDS-HPC/public/candle/Benchmarks/Pilot1/P1B3/
#MODEL_PYTHON_DIR=/data/BIDS-HPC/public/candle/Benchmarks/Pilot1/P1B3/
#MODEL_PYTHON_SCRIPT=p1b3_baseline_keras2
