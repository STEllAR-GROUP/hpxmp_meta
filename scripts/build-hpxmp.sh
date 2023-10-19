#!/bin/bash

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CURRENT_DIR="${2:-$(realpath "$(dirname "$0")")}"
COMPILER=${3:-llvm}
CLEAN_BUILD=${4:-no}

# Paths setup
PREFIX="${CURRENT_DIR}"/../..
LLVM_DIR=${PREFIX}/llvm-project
LLVM_VERSION=16.0.6
OMP_DIR=${LLVM_DIR}/openmp
HPX_DIR=${PREFIX}/hpx/cmake-install/${BUILD_TYPE}/lib64/cmake/HPX
HPXC_DIR=${PREFIX}/hpxc
PROJECT=hpxmp
BUILD_DIR=${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}
INSTALL_DIR=${OMP_DIR}/cmake-install-${PROJECT}/${BUILD_TYPE}

# Load modules based on the chosen compiler
module load $COMPILER boost cmake

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_DIR}"
  rm -rf "${INSTALL_DIR}"
fi

# Error checks
set -e

# Clone if the directory doesn't exist
if [ ! -d ${LLVM_DIR} ]; then
  git clone --depth 1 https://github.com/STEllAR-GROUP/llvm-project ${LLVM_DIR}
fi

# Running CMake commands
cmake                                \
  -G Ninja                           \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}  \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}   \
  -DCMAKE_VERBOSE_MAKEFILE=ON        \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DHPX_DIR=${HPX_DIR}               \
  -DHPXC_DIR=${HPXC_DIR}             \
  -DOPENMP_ENABLE_LIBOMPTARGET=OFF   \
  -DLIBOMP_OMPD_SUPPORT=OFF          \
  -DLIBOMP_USE_ITT_NOTIFY=OFF        \
  -DWITH_HPXC=ON                     \
  -Wdev -S ${OMP_DIR} -B ${BUILD_DIR}

# Build and install
cmake --build ${BUILD_DIR}
cmake --install ${BUILD_DIR}
