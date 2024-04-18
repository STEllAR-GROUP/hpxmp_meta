# Copyright (c) 2024 Panos Syskakis
# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.18)

project(hpxmp_meta)

option(WITH_HPXMP "Use HPX threading system." OFF)

if(WITH_HPXMP)
  # Find HPXMP (omp impl) and HPXC, and create targets `hpxmp` and `hpxc`/`hpxc-wrap` respectively
  message(STATUS "Using HPXMP threading system.")

  if(NOT HPXMP_DIR)
    message(FATAL_ERROR "HPXMP_DIR must be set when WITH_HPXMP is ON.")
  endif()

  if(NOT HPXC_DIR)
    message(FATAL_ERROR "HPXC_DIR must be set when WITH_HPXMP is ON.")
  endif()

  # Create hpxmp target
  add_library(hpxmp INTERFACE)

  find_library(hpxmp-lib libomp.so
    PATHS ${HPXMP_DIR}
    PATH_SUFFIXES lib lib64
    REQUIRED
    NO_DEFAULT_PATH
  )

  # Store hpxmp library directory:
  # When linking with `hpxmp` target, CMake adds the directory of the corresponding libraries to RUNPATH.
  # However, LD_LIBRARY_PATH takes precedence over RUNPATH, which may cause the system OpenMP to be loaded instead of HPXMP.
  # So we manually need to either set LD_LIBRARY_PATH, use LD_PRELOAD, or use rpath.
  get_filename_component(HPXMP_LIB_DIR ${hpxmp-lib} DIRECTORY)
  set_target_properties(hpxmp PROPERTIES LIB_PATH ${HPXMP_LIB_DIR})

  target_include_directories(hpxmp INTERFACE ${HPXMP_DIR}/include)
  target_link_libraries(hpxmp INTERFACE ${hpxmp-lib})
  target_compile_definitions(hpxmp INTERFACE -DHPXMP)
  target_compile_options(hpxmp INTERFACE -fopenmp)
  # Clang supports disabling TLS, which makes omp threadprivates work on HPXMP. 
  # On other compilers, omp threadprivate will not work properly.
  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    target_compile_options(hpxmp INTERFACE -fnoopenmp-use-tls)
  endif()

  # Create hpxc target
  add_library(hpxc INTERFACE)

  find_library(hpxc-lib libhpx_hpxc.so
    PATHS ${HPXC_DIR}
    PATH_SUFFIXES lib lib64
    REQUIRED
  )

  target_include_directories(hpxc INTERFACE ${HPXC_DIR}/include())
  target_link_libraries(hpxc INTERFACE ${hpxc-lib})

  # Create hpxc-wrap target
  add_library(hpxc-wrap INTERFACE)

  find_library(hpxc-wrap-lib libhpxc_wrap.a
    PATHS ${HPXC_DIR}
    PATH_SUFFIXES lib lib64
  )

  if(hpxc-wrap-lib)
    # Use link-time wrapping for main
    target_link_libraries(hpxc-wrap INTERFACE ${hpxc-wrap-lib})
    target_link_options(hpxc-wrap INTERFACE -Wl,-wrap=main)
    target_compile_definitions(hpxc-wrap INTERFACE HPXC_HAVE_DYNAMIC_HPXC_MAIN)
  endif()

  target_include_directories(hpxc-wrap INTERFACE ${HPXC_DIR}/include)

else()
  # Try to create `omp` target from user-provided OpenMP installation
  # If not provided, use system OpenMP
  add_library(omp INTERFACE)
  target_compile_options(omp INTERFACE -fopenmp)

  if(OMP_DIR)
    message(STATUS "Using OpenMP from ${OMP_DIR}")
    find_library(omp-lib omp
      PATHS ${OMP_DIR}
      PATH_SUFFIXES lib lib64
      REQUIRED
      NO_DEFAULT_PATH
    )

    target_include_directories(omp INTERFACE ${OMP_DIR}/include)
    target_link_libraries(omp INTERFACE ${omp-lib})
  else()
    message(STATUS "Using system OpenMP")
    find_package(OpenMP REQUIRED)
    target_link_libraries(omp INTERFACE OpenMP::OpenMP_CXX)
  endif()
endif()

enable_testing()

add_subdirectory(examples)
add_subdirectory(tests)
