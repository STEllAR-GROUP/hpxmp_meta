# Copyright (c) 2024 Panos Syskakis
# Copyright (c) 2018 Tianyi Zhang
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

add_custom_target(tests.unit)
add_dependencies(tests tests.unit)

function(add_hpxmp_test name)
    set(sources ${name}.cpp)
    set(target tests.unit.${name})

    add_executable(${target} ${sources})

    set(test_env_vars "OMP_NUM_THREADS=4")
    if(WITH_HPXMP)
        target_link_libraries(${target} HPXMP::hpxmp)
        # Prepend HPXMP library path to LD_LIBRARY_PATH, to ensure that the linker
        # doesn't pick up some other OpenMP library in the system.
        get_target_property(HPXMP_LIB_PATH HPXMP::hpxmp LIB_PATH)
        set(test_env_vars ${test_env_vars} "LD_LIBRARY_PATH=${HPXMP_LIB_PATH}:$ENV{LD_LIBRARY_PATH}")
    else()
        target_link_libraries(${target} OpenMP::OpenMP_CXX)
    endif()

    # Custom command to also print the result of ldd
    # add_test(${target} ${target})
    add_test(NAME ${target} COMMAND objdump -p ${target})

    set_tests_properties(${target} PROPERTIES TIMEOUT 50 ENVIRONMENT "${test_env_vars}")

    add_dependencies(tests.unit ${target})
endfunction()

    

set(tests
        app_lu
        app_old_fib
        app_vla
        atomic
        barrier
        critical
        critical_2
        firstprivate
        for_decrement
        for_dynamic
        for_increment
        for_nowait
        for_reduction
        for_shared
        for_static
        master
        max_threads
        omp_set_get_nested
        par_for
        par_nested
        par_single
        sections
        sections_2
        single_copyprivate
        single_copyprivate_2
        single_copyprivate_1var
        single_nowait
        taskgroup
        task_fp
        task_tree
        taskwait
        taskwait_2
        threadprivate
        )


foreach(test ${tests})
    add_hpxmp_test(${test})
endforeach()
