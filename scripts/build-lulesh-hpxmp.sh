# Enable debug
set -x

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"
COMPILER=${4:-llvm}

# Paths setup
PREFIX="$CURRENT_DIR"/..
DEPENDENCIES="${PREFIX}/dependencies"

# Clone lulesh
LULESH_DIR=${PREFIX}/LULESH_HPX
git clone -b build-with-hpxmp git@github.com:Pansysk75/LULESH.git ${LULESH_DIR}

# Set the environment variables:

# The value depends on the operating system
if [ -d "${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/lib64" ]; then
  LIB64_OR_LIB="lib64"
else
  LIB64_OR_LIB="lib"
fi

export HPX_INCLUDE_PATH="${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/include"
export HPX_LIB_PATH="${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/${LIB64_OR_LIB}"

export OMP_LIB_PATH="${DEPENDENCIES}/llvm-project/openmp/cmake-install-hpxmp/${BUILD_TYPE}/lib"
export OMP_INCLUDE_PATH="${DEPENDENCIES}/llvm-project/openmp/cmake-install-hpxmp/${BUILD_TYPE}/include"

# Build lulesh
cd ${LULESH_DIR}
make clean && USE_GPU=0 USE_MPI=0 make
