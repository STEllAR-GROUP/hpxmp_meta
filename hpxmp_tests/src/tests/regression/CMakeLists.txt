# Copyright (c) 2024 Panos Syskakis
# Copyright (c) 2018 Tianyi Zhang
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

add_custom_target(tests.regression)
add_dependencies(tests tests.regression)

function(add_hpxmp_regression_test name)
        set(sources ${name}.cpp)
        set(target tests.regression.${name})

        add_executable(${target} ${sources})
        set(test_properties TIMEOUT 50)
        set(test_properties ${test_properties} ENVIRONMENT "OMP_NUM_THREADS=4")

        if(WITH_HPXMP)
                target_link_libraries(${target} HPXMP::hpxmp)
                # Prepend HPXMP library path to LD_LIBRARY_PATH, to ensure that the linker
                # doesn't pick up some other OpenMP library in the system.
                get_target_property(HPXMP_LIB_PATH HPXMP::hpxmp LIB_PATH)
                set(test_properties ${test_properties} ENVIRONMENT "LD_LIBRARY_PATH=${HPXMP_LIB_PATH}:$ENV{LD_LIBRARY_PATH}")
        else()
                target_link_libraries(${target} OpenMP::OpenMP_CXX)
        endif()

        add_test(${target} ${target})
        set_tests_properties(${target} PROPERTIES ${test_properties})

        add_dependencies(tests.regression ${target})
endfunction()

set(tests
        get_thread_num
        parallel_multi
        task_tree_simple
        task_untied
)

foreach(test ${tests})
        add_hpxmp_regression_test(${test})
endforeach()
