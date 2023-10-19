# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.18)

project(hpxmp_meta C CXX)

option(WITH_HPXC "Use HPX threading system." OFF)
if (WITH_HPXC)
  find_package(HPX REQUIRED)
  add_definitions(-DHPXC)
  find_library(HPXMP libomp.so
    PATHS ${OMP_LIB_PATH}
    NO_DEFAULT_PATH
  )
endif()

enable_testing()

add_subdirectory(running_examples)
add_subdirectory(tests)

