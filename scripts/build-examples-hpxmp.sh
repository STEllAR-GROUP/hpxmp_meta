#!/bin/bash

# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"
COMPILER=${4:-llvm}

# Paths setup
PREFIX="$CURRENT_DIR"/..
DEPENDENCIES="${PREFIX}/dependencies"

# The value depends on the operating system
if [ -d "${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/lib64" ]; then
  LIB64_OR_LIB="lib64"
else
  LIB64_OR_LIB="lib"
fi
HPX_DIR=${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}/${LIB64_OR_LIB}/cmake/HPX
HPXC_INCLUDE_PATH="${DEPENDENCIES}/hpxc/cmake-install/${BUILD_TYPE}/include"
OMP_LIB_PATH="${DEPENDENCIES}/llvm-project/openmp/cmake-install-hpxmp/${BUILD_TYPE}/lib"

SOURCE_PATH="${PREFIX}/hpxmp_tests/src"
BUILD_PATH="${PREFIX}/hpxmp_tests/build_${BUILD_TYPE}_hpxmp"
INSTALL_PATH="${PREFIX}/hpxmp_tests/install_${BUILD_TYPE}_hpxmp"

# Load modules
module load $COMPILER boost cmake

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_PATH}" "${INSTALL_PATH}"
fi

# Create necessary directories (if they don't exist)
mkdir -p "${PREFIX}"

# Run CMake configuration
cmake \
  -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PATH}" \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DHPX_DIR="${HPX_DIR}" \
  -DCMAKE_CXX_STANDARD=17 \
  -DWITH_HPXC=ON \
  -DHPXC_INCLUDE_PATH="${HPXC_INCLUDE_PATH}" \
  -DOMP_LIB_PATH="${OMP_LIB_PATH}" \
  -Wdev -S "${SOURCE_PATH}" -B "${BUILD_PATH}"

# Build and install
cmake --build "${BUILD_PATH}" --target tests
cmake --install "${BUILD_PATH}"
