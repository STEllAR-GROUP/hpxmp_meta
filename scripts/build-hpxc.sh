#!/bin/bash

# Copyright (c) 2024 Panos Syskakis
# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# Input arguments with default values
BUILD_TYPE=${1:-RelWithDebInfo}
CLEAN_BUILD=${2:-no}
CURRENT_DIR="${3:-$(realpath "$(dirname "$0")")}"

# Paths setup
PREFIX="${CURRENT_DIR}"/..
DEPENDENCIES="${PREFIX}"/dependencies

HPX_ROOT=${DEPENDENCIES}/hpx/cmake-install/${BUILD_TYPE}

SRC_DIR=${DEPENDENCIES}/hpxc
BUILD_DIR=${SRC_DIR}/cmake-build/${BUILD_TYPE}
INSTALL_DIR=${SRC_DIR}/cmake-install/${BUILD_TYPE}

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_DIR}" "${INSTALL_DIR}"
fi

# Clone if the directory doesn't exist
if [ ! -d ${SRC_DIR} ]; then
  git clone https://github.com/STEllAR-GROUP/hpxc ${SRC_DIR}
fi

# Running CMake commands
cmake \
  -G Ninja \
  -D "CMAKE_INSTALL_PREFIX=${INSTALL_DIR}" \
  -S ${SRC_DIR} \
  -B ${BUILD_DIR} \
  -D "HPX_ROOT=${HPX_ROOT}" \
  -D "CMAKE_BUILD_TYPE=${BUILD_TYPE}" \
  -D "CMAKE_POSITION_INDEPENDENT_CODE=ON" \
  -D "HPXC_WITH_DYNAMIC_HPXC_MAIN=ON" \
  -D "HPXC_WITH_SHARED_LIBS=ON"

# Build and install
cmake --build ${BUILD_DIR}
cmake --install ${BUILD_DIR}
