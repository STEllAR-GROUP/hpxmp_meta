#!/bin/bash

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"

# Paths setup
PREFIX="${CURRENT_DIR}"/..
DEPENDENCIES="${PREFIX}"/dependencies

SRC_DIR=${DEPENDENCIES}/hpx
BUILD_DIR=${SRC_DIR}/cmake-build/${BUILD_TYPE}
INSTALL_DIR=${SRC_DIR}/cmake-install/${BUILD_TYPE}

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_DIR}" "${INSTALL_DIR}"
fi

# Clone if the directory doesn't exist
if [ ! -d ${SRC_DIR} ]; then
  git clone --depth 1 https://github.com/STEllAR-GROUP/hpx ${SRC_DIR}
fi

# Running CMake commands
cmake                                     \
-G Ninja                                  \
-S ${SRC_DIR}                             \
-B ${BUILD_DIR}                           \
-D "HPX_WITH_FETCH_ASIO=ON"               \
-D "CMAKE_BUILD_TYPE=${BUILD_TYPE}"       \
-D "HPX_WITH_DYNAMIC_HPX_MAIN=OFF"        \
-D "HPX_WITH_EXAMPLES=OFF"                \
-D "HPX_WITH_TESTS=OFF"                   \
-D "HPX_WITH_FETCH_BOOST=ON"              

# Build and install
cmake --build ${BUILD_DIR}
cmake --install ${BUILD_DIR} --prefix ${INSTALL_DIR}
