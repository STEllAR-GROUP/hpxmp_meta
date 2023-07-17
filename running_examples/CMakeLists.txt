# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.18)

project(hpxMP C CXX)
option(WITH_HPXC "Use HPX threading system." OFF)
if (WITH_HPXC)
  find_package(HPX REQUIRED)
  add_definitions(-DHPXC)
endif()

set(CMAKE_CXX_FLAGS "-fopenmp")

add_executable(hello_world hello.cpp)
if (WITH_HPXC)
  target_link_libraries(hello_world ${OMP_LIB_PATH} pthread HPX::hpx HPX::wrap_main)
else()
  target_link_libraries(hello_world ${OMP_LIB_PATH} pthread)
endif()

add_executable(barrier barrier.cpp)
if (WITH_HPXC)
  target_link_libraries(barrier ${OMP_LIB_PATH} pthread HPX::hpx HPX::wrap_main)
else()
  target_link_libraries(barrier ${OMP_LIB_PATH} pthread)
endif()

add_executable(for for.cpp)
if (WITH_HPXC)
  target_link_libraries(for ${OMP_LIB_PATH} pthread HPX::hpx HPX::wrap_main)
else()
  target_link_libraries(for ${OMP_LIB_PATH} pthread)
endif()

add_executable(atomic atomic.cpp)
if (WITH_HPXC)
  target_link_libraries(atomic ${OMP_LIB_PATH} pthread HPX::hpx HPX::wrap_main)
else()
  target_link_libraries(atomic ${OMP_LIB_PATH} pthread)
endif()


