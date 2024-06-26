# Copyright (c) 2024 Panos Syskakis
# Copyright (c) 2023 R. Tohid (@rtohid)
#
# SPDX-License-Identifier: BSL-1.0
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

add_custom_target(examples)

function(add_hpxmp_example name)
  set(sources ${name}.cpp)
  set(target examples.${name})

  add_executable(${target} ${sources})

  if(WITH_HPXMP)
    target_link_libraries(${target} HPXMP::hpxmp)
  else()
    target_link_libraries(${target} omp)
  endif()

  add_dependencies(examples ${target})
endfunction()

set(examples
  hello
)

foreach(example ${examples})
  add_hpxmp_example(${example})
endforeach()
