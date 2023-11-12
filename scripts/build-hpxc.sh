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

SRC_DIR=${DEPENDENCIES}/hpxc
BUILD_DIR=${SRC_DIR}/cmake-build/${BUILD_TYPE}
INSTALL_DIR=${SRC_DIR}/cmake-install/${BUILD_TYPE}


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
if [ ! -d ${SRC_DIR} ]; then
  git clone https://github.com/STEllAR-GROUP/hpxc ${SRC_DIR}
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
