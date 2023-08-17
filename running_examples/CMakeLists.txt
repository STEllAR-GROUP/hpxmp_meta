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

file(GLOB TEST_SOURCES *.cpp)
foreach (test_source ${TEST_SOURCES} )
	get_filename_component( testname ${test_source} NAME_WE )
	add_executable( ${testname} ${test_source} )
	if (WITH_HPXC)
	  target_link_libraries(${testname} ${OMP_LIB_PATH} pthread HPX::hpx HPX::wrap_main)
	else()
	  target_link_libraries(${testname} ${OMP_LIB_PATH} pthread)
	endif()
endforeach (test_source ${TEST_SOURCES})
