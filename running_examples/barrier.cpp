#include <omp.h>
#include <stdio.h>

#ifdef HPXC
#include <hpx/hpx_main.hpp>
#endif // HPXC

int main () {

  int th_id, nthreads;
  
    #pragma omp parallel private(th_id)
    {
    th_id = omp_get_thread_num();
    printf("Hello World from thread %d\n", th_id);

	#pragma omp barrier
    	if ( th_id == 0 ) {
      		nthreads = omp_get_num_threads();
      		printf("There are %d threads\n",nthreads);
    	}
    }

    return 0;
}
