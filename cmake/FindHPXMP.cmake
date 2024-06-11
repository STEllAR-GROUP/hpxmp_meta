# Copyright (c) 2024 Panos Syskakis
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

if(NOT TARGET HPXMP::hpxmp)
    find_path(HPXMP_INCLUDE_DIR
        NAMES omp.h
        PATH_SUFFIXES include
        NO_CMAKE_SYSTEM_PATH)

    find_library(HPXMP_LIBRARY
        NAMES omp
        PATH_SUFFIXES lib lib64
        NO_CMAKE_SYSTEM_PATH)

    find_library(HPXMP_HPXC_LIB
        NAMES hpx_hpxc
        PATH_SUFFIXES lib lib64
        HINTS ${HPXC_ROOT} ${Hpxc_ROOT} ENV HPXC_ROOT ENV Hpxc_ROOT
        NO_CMAKE_SYSTEM_PATH)

    find_library(HPXMP_HPXC_WRAP_LIB
        NAMES hpx_hpxc_wrap
        PATH_SUFFIXES lib lib64
        HINTS ${HPXC_ROOT} ${Hpxc_ROOT} ENV HPXC_ROOT ENV Hpxc_ROOT
        NO_CMAKE_SYSTEM_PATH)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(HPXMP DEFAULT_MSG HPXMP_LIBRARY HPXMP_INCLUDE_DIR HPXMP_HPXC_LIB HPXMP_HPXC_WRAP_LIB)

    mark_as_advanced(HPXMP_INCLUDE_DIR HPXMP_LIBRARY HPXMP_HPXC_LIB HPXMP_HPXC_WRAP_LIBRARY)

    if(NOT HPXMP_FOUND)
        return()
    endif()

    set(HPXMP_LIBRARIES ${HPXMP_LIBRARY} ${HPXMP_HPXC_LIB} ${HPXMP_HPXC_WRAP_LIB})
    set(HPXMP_INCLUDES ${HPXMP_INCLUDE_DIR})
    get_filename_component(HPXMP_LIB_PATH ${HPXMP_LIBRARY} DIRECTORY)

    add_library(HPXMP::hpxmp INTERFACE IMPORTED)
    target_include_directories(HPXMP::hpxmp INTERFACE ${HPXMP_INCLUDES})
    target_link_libraries(HPXMP::hpxmp INTERFACE ${HPXMP_LIBRARIES})
    target_compile_options(HPXMP::hpxmp INTERFACE -fopenmp)
    target_link_options(HPXMP::hpxmp INTERFACE -Wl,-wrap=main)
    set_target_properties(HPXMP::hpxmp PROPERTIES LIB_PATH ${HPXMP_LIB_PATH})

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        target_compile_options(HPXMP::hpxmp INTERFACE -fnoopenmp-use-tls)
    else()
        message(WARNING "Proper TLS configuration is not supported by the compiler, thus omp threadprivate \
        (and other features dependent on TLS) will not work properly. Consider using Clang for full HPXMP support.")
    endif()
endif()