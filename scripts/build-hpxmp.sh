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
HPXC_ROOT=${DEPENDENCIES}/hpxc/cmake-install/${BUILD_TYPE}

LLVM_DIR=${DEPENDENCIES}/llvm-project
LLVM_VERSION=16.0.6
OMP_DIR=${LLVM_DIR}/openmp

BUILD_DIR=${OMP_DIR}/cmake-build-hpxmp/${BUILD_TYPE}
INSTALL_DIR=${OMP_DIR}/cmake-install-hpxmp/${BUILD_TYPE}

# Clean build and install directories if CLEAN_BUILD == 'yes'
if [ "$CLEAN_BUILD" = "yes" ]; then
  echo "Cleaning build and install directories..."
  rm -rf "${BUILD_DIR}" "${INSTALL_DIR}"
fi

# Clone if the directory doesn't exist
if [ ! -d ${LLVM_DIR} ]; then
  git clone -b hpxmp_testing --depth 1 https://github.com/STEllAR-GROUP/llvm-project ${LLVM_DIR}
fi

# Running CMake commands
cmake \
  -G Ninja \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DOPENMP_ENABLE_LIBOMPTARGET=OFF \
  -DLIBOMP_OMPD_SUPPORT=OFF \
  -DLIBOMP_USE_ITT_NOTIFY=OFF \
  -DWITH_HPXC=ON \
  -DHPXC_ROOT=${HPXC_ROOT} \
  -DHPX_ROOT=${HPX_ROOT} \
  -Wdev -S ${OMP_DIR} -B ${BUILD_DIR}

# -DWITH_FETCH_HPXC=ON               \
# -DHPXC_WITH_FETCH_HPX=ON           \

# Build and install
cmake --build ${BUILD_DIR}
cmake --install ${BUILD_DIR}
