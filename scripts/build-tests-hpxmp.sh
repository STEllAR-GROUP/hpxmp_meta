#!/bin/bash

# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CURRENT_DIR="${2:-$(realpath "$(dirname "$0")")}"
COMPILER=${3:-llvm}
CLEAN_BUILD=${4:-no}

# Paths setup
PREFIX="$CURRENT_DIR"/../..
SOURCE_PATH="${PREFIX}/hpxmp_meta/src"
BUILD_PATH="${PREFIX}/hpxmp_meta/build_${BUILD_TYPE}"
INSTALL_PATH="${PREFIX}/hpxmp_meta/install_${BUILD_TYPE}"
HPX_DIR="${PREFIX}/hpx/cmake-install/${BUILD_TYPE}/lib64/cmake/HPX"
HPXC_INCLUDE_PATH="${PREFIX}/hpxc/cmake-install/${BUILD_TYPE}/include"
OMP_LIB_PATH="${PREFIX}/llvm-project/openmp/cmake-install-hpxmp/${BUILD_TYPE}/lib/"

# Load modules
module load $COMPILER boost cmake

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_PATH}"
  rm -rf "${INSTALL_PATH}"
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
