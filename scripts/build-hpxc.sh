#!/bin/bash

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CURRENT_DIR="${2:-$(realpath "$(dirname "$0")")}"
COMPILER=${3:-llvm}
CLEAN_BUILD=${4:-no}

# Paths setup
PREFIX="${CURRENT_DIR}"/../..
SRC_DIR=${PREFIX}/hpxc
BUILD_DIR=${SRC_DIR}/cmake-build/${BUILD_TYPE}
INSTALL_DIR=${SRC_DIR}/cmake-install/${BUILD_TYPE}
HPX_DIR=${PREFIX}/hpx/cmake-install/${BUILD_TYPE}/lib64/cmake/HPX

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
if [ ! -d ${SRC_DIR} ]; then
  git clone -b ref_counted_keys https://github.com/STEllAR-GROUP/hpxc ${SRC_DIR}
fi

# Running CMake commands
cmake                                   \
-G Ninja                                \
-S ${SRC_DIR}                           \
-B ${BUILD_DIR}                         \
-D "HPX_DIR=${HPX_DIR}"                 \
-D "CMAKE_BUILD_TYPE=${BUILD_TYPE}"     \
-D "CMAKE_INSTALL_PREFIX=${INSTALL_DIR}" \
-D "CMAKE_POSITION_INDEPENDENT_CODE=ON"

# Build and install
cmake --build ${BUILD_DIR}
cmake --install ${BUILD_DIR}
