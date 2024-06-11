# Copyright (c) 2024 Panos Syskakis
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

if(NOT TARGET OpenMP::OpenMP_CXX)
    # Try to find user-provided OpenMP installation
    find_path(OpenMP_INCLUDE_DIR
        NAMES omp.h
        PATH_SUFFIXES include
        HINTS ${OpenMP_ROOT} ${OPENMP_ROOT} ENV OpenMP_ROOT ENV OPENMP_ROOT
        NO_CMAKE_SYSTEM_PATH
    )

    find_library(OpenMP_LIBRARY
        NAMES omp
        PATH_SUFFIXES lib lib64
        HINTS ${OpenMP_ROOT} ${OPENMP_ROOT} ENV OpenMP_ROOT ENV OPENMP_ROOT
        NO_CMAKE_SYSTEM_PATH
    )

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(OpenMPCustom DEFAULT_MSG OpenMP_LIBRARY OpenMP_INCLUDE_DIR)
    mark_as_advanced(OpenMP_INCLUDE_DIR OpenMP_LIBRARY)

    if(NOT OpenMPCustom_FOUND)
        return()
    endif()

    set(OpenMP_LIBRARIES ${OpenMP_LIBRARY})
    set(OpenMP_INCLUDES ${OpenMP_INCLUDE_DIR})
    add_library(OpenMP::OpenMP_CXX INTERFACE IMPORTED)
    target_include_directories(OpenMP::OpenMP_CXX INTERFACE ${OpenMP_INCLUDES})
    target_link_libraries(OpenMP::OpenMP_CXX INTERFACE ${OpenMP_LIBRARIES})
    target_compile_options(OpenMP::OpenMP_CXX INTERFACE -fopenmp)
endif()
