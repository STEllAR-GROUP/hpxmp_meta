#Load new environment
CURRENT_DIR="${1:-$(realpath "$(dirname "$0")")}"

module load llvm boost cmake
export LD_LIBRARY_PATH=$(CURRENT_DIR)/../../llvm-project/openmp/cmake-install-hpxmp/${BUILD_TYPE}/lib/:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=8