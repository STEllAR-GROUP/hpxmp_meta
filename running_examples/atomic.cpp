#include <omp.h>
#include <stdio.h>

#ifdef HPXC
#include <hpx/hpx_main.hpp>
#endif // HPXC


int main() {
    int x=0;
#pragma omp parallel for
    for (int i = 0; i<10000000; i++)
    {
        #pragma omp atomic
        x++;
    }
    printf("x = %d\n", x);
    if(x != 10000000) return 1;
    return 0;
}
