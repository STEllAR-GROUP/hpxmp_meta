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

        if(WITH_HPXMP)
                target_link_libraries(${target} hpxc-wrap hpxc hpxmp)
                get_target_property(HPXMP_LIB_PATH hpxmp LIB_PATH)
                set(test_properties ${test_properties} ENVIRONMENT "LD_LIBRARY_PATH=${HPXMP_LIB_PATH}:$ENV{LD_LIBRARY_PATH} OMP_NUM_THREADS=4")
        else()
                target_link_libraries(${target} omp)
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
