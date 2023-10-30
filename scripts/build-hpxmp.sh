#!/bin/bash

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"
COMPILER=${4:-llvm}

# Paths setup
PREFIX="${CURRENT_DIR}"/..
DEPENDENCIES="${PREFIX}"/dependencies

# The value depends on the operating system
if [ -d "${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/lib64" ]; then
  LIB64_OR_LIB="lib64"
else
  LIB64_OR_LIB="lib"
fi
HPX_DIR=${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/${LIB64_OR_LIB}/cmake/HPX
HPXC_DIR=${DEPENDENCIES}/hpxc

LLVM_DIR=${DEPENDENCIES}/llvm-project
LLVM_VERSION=16.0.6
OMP_DIR=${LLVM_DIR}/openmp

PROJECT=hpxmp
BUILD_DIR=${OMP_DIR}/cmake-build-${PROJECT}/${BUILD_TYPE}
INSTALL_DIR=${OMP_DIR}/cmake-install-${PROJECT}/${BUILD_TYPE}

# Load modules based on the chosen compiler
module load $COMPILER boost cmake

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_DIR}" "${INSTALL_DIR}"
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
