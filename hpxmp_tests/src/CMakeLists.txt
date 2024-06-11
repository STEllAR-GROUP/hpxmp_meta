# Copyright (c) 2024 Panos Syskakis
# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.18)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

project(hpxmp_meta)

option(WITH_HPXMP "Use HPXMP threading system." OFF)

if(WITH_HPXMP)
  message(STATUS "Using HPXMP threading system.")
  find_package(HPXMP REQUIRED)
  message(STATUS "Found HPXMP installation (${HPXMP_LIBRARY})")
else()
  # Try finding user-provided OpenMP installation
  find_package(OpenMPCustom)

  if(TARGET OpenMP::OpenMP_CXX)
    message(STATUS "Found custom OpenMP installation (${OpenMP_LIBRARY})")
  else()
    message(WARNING "Custom OpenMP installation not found, using system OpenMP.")
    find_package(OpenMP REQUIRED)
  endif()
endif()

enable_testing()

add_subdirectory(examples)
add_subdirectory(tests)
