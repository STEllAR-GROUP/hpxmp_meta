#!/bin/bash

# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

module load gcc/12.3.0 boost

CURRENT_DIR=$1
PREFIX="${CURRENT_DIR:=$(pwd)}"

EXAMPLE_PATH=${PREFIX}/running_examples
BUILD_TYPE=Debug
PROJECT=examples

mkdir -p ${PREFIX}

rm -rf ${EXAMPLE_PATH}/cmake-build-omp

cmake                                                                                     \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE}                                                        \
  -DCMAKE_VERBOSE_MAKEFILE=ON                                                             \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON                                                      \
  -DCMAKE_CXX_FLAGS="-std=c++17 -fopenmp"                                                 \
  -DCMAKE_CXX_COMPILER=g++                                                            \
  -DCMAKE_C_COMPILER=gcc                                                                \
  -DHPX_DIR=${HPX_DIR}                                                                    \
  -DOMP_LIB_PATH=${PREFIX}/llvm-project/openmp/cmake-install-omp/${BUILD_TYPE}/lib/libomp.so  \
  -Wdev -S ${EXAMPLE_PATH} -B ${EXAMPLE_PATH}/cmake-build-omp/${BUILD_TYPE}

cmake --build ${EXAMPLE_PATH}/cmake-build-omp/${BUILD_TYPE}/ --parallel
cmake --install ${EXAMPLE_PATH}/cmake-build-omp/${BUILD_TYPE}/ --prefix ${EXAMPLE_PATH}/cmake-install-omp/${BUILD_TYPE}
