# CFG PRM 1

# mlrMBO settings

# Total iterations
PROPOSE_POINTS=${PROPOSE_POINTS:-302}
MAX_CONCURRENT_EVALUATIONS=${MAX_CONCURRENT_EVALUATIONS:-300}
MAX_ITERATIONS=${MAX_ITERATIONS:-3}
MAX_BUDGET=${MAX_BUDGET:-900}
DESIGN_SIZE=${DESIGN_SIZE:-300}
PARAM_SET_FILE=${PARAM_SET_FILE:-$EMEWS_PROJECT_ROOT/data/hps_space.R}
MODEL_NAME="combo"



