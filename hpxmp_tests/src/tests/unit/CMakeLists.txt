# Copyright (c) 2018 Tianyi Zhang
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
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


add_custom_target(tests)

message("Using compiler: " ${CMAKE_CXX_COMPILER_ID})


foreach(test ${tests})

    set(sources ${test}.cpp)
    set(target tests.omp.unit.${test})

    add_executable(${target} ${sources})

    if(WITH_HPXC)
        target_link_libraries(${target} ${HPXMP} pthread HPX::hpx HPX::wrap_main m)
        target_include_directories(${target} PUBLIC ${HPXC_INCLUDE_PATH})
    elseif()
        target_link_libraries(${target} pthread m)
    endif()

    add_test(${target} ${target})
    set_tests_properties(${target} PROPERTIES
            TIMEOUT 50
            )
            
    add_dependencies(tests ${target})

    # if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    #     target_compile_options(${target} PUBLIC -fdump-tree-ompexp)
    # endif()

endforeach()

            # ENVIRONMENT "LD_PRELOAD=${PROJECT_BINARY_DIR}/libhpxmp.so;OMP_NUM_THREADS=2"


# if(HPXMP_WITH_OMP_50_ENABLED)
#     set(tests_omp50
#             task_in_reduction
#             )
# endif()


# if(HPXMP_WITH_OMP_50_ENABLED)
#     foreach(test ${tests_omp50})
#         set(sources ${test}.cpp)
#         add_executable(tests.omp.unit.${test} ${sources})
#         do_test(tests.omp.unit.${test})
#     endforeach()
# endif()
