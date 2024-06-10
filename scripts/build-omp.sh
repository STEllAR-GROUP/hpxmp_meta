#!/bin/bash

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"

# Paths setup
PREFIX="${CURRENT_DIR}"/..
DEPENDENCIES="${PREFIX}"/dependencies

LLVM_DIR=${DEPENDENCIES}/llvm-project
LLVM_VERSION=16.0.6
OMP_DIR=${LLVM_DIR}/openmp

BUILD_DIR=${OMP_DIR}/cmake-build-omp/${BUILD_TYPE}
INSTALL_DIR=${OMP_DIR}/cmake-install-omp/${BUILD_TYPE}

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_DIR}" "${INSTALL_DIR}"
fi

# Clone if the directory doesn't exist
if [ ! -d ${LLVM_DIR} ]; then
  git clone --depth 1 https://github.com/STEllAR-GROUP/llvm-project ${LLVM_DIR}
fi

# Running CMake commands
cmake                                \
  -G Ninja                           \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}   \
  -DOPENMP_ENABLE_LIBOMPTARGET=OFF   \
  -DLIBOMP_OMPD_SUPPORT=OFF          \
  -DLIBOMP_USE_ITT_NOTIFY=OFF        \
  -Wdev -S ${OMP_DIR} -B ${BUILD_DIR}

# Build and install
cmake --build ${BUILD_DIR}
cmake --install ${BUILD_DIR} --prefix ${INSTALL_DIR}
