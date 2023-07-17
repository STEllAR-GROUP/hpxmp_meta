// Copyright (c) 2023 R. Tohid (@rtohid)
//
// SPDX-License-Identifier: BSL-1.0
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <iostream>
#include <omp.h>

#ifdef HPXC
#include <hpx/hpx_main.hpp>
#endif // HPXC

int main(int argc, char *argv[]) {

  std::cout << "Starting ..." << std::endl;

#pragma omp parallel
  {
    std::cout << "Hello World, from thread: " << omp_get_thread_num()
              << std::endl;
  }

  //std::cout << "Threads running " << hpx::threads::get_thread_manager().get_thread_count() << std::endl;
  return 0;
}
