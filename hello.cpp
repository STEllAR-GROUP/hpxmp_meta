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

  return 0;
}
