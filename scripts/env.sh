# Usage: source env.sh <BUILD_TYPE> <CURRENT_DIR>

# In function so that local variables don't pollute the environment
__set_hpxmp_env_(){

    # validate parameters
    if [ "$1" != "Debug" ] && [ "$1" != "RelWithDebInfo" ] && [ "$1" != "Release" ]; then
        echo "Error: Invalid argument. Please use 'Debug', 'RelWithDebInfo', or 'Release'."
        return 1
    fi

    local BUILD_TYPE="$1"
    local CURRENT_DIR="${2:-$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)}"
    module load llvm boost cmake
    export LD_LIBRARY_PATH="${CURRENT_DIR}/dependencies/llvm-project/openmp/cmake-install-hpxmp/${BUILD_TYPE}/lib/:$LD_LIBRARY_PATH"
    export OMP_NUM_THREADS=8
}

__set_hpxmp_env_ "$@"

unset __set_hpxmp_env_
