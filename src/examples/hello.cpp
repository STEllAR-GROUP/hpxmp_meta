// Copyright (c) 2024 Panos Syskakis
// Copyright (c) 2023 R. Tohid (@rtohid)
//
// SPDX-License-Identifier: BSL-1.0
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <iostream>
#include <omp.h>

int main(int argc, char *argv[])
{

  std::cout << "Starting ..." << std::endl;

#pragma omp parallel
  {
    std::cout << "Hello World, from thread: " << omp_get_thread_num()
              << std::endl;
  }

  return 0;
}
