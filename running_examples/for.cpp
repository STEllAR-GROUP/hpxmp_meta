#include <omp.h>
#include <stdio.h>

#ifdef HPXC
#include <hpx/hpx_main.hpp>
#endif // HPXC

int main () {
  int a[1000];
  #pragma omp parallel for
  for(int i = 1; i < 1000; ++i)
  {
     a[i] = i;
  }

  return 0;
}
