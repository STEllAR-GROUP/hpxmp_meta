// Copyright (c) 2018 Tianyi Zhang
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <iostream>
#include <omp.h>

#ifdef HPXMP
#include <hpxc/util/wrap_main.h>
#endif // HPXMP

#define print_line_thread std::cout << "Thread " << omp_get_thread_num() << ": "\
                                    << "Line: "  << __LINE__ << std::endl

int main()
{
    omp_set_max_active_levels(2);
    printf("Max active levels: %d\n", omp_get_max_active_levels());
    int num_threads = omp_get_max_threads();
    bool result[num_threads][num_threads];
#pragma omp parallel
    {
        int tid = omp_get_thread_num();
        printf("Outer| Thread num: %d, Thread level: %d\n", tid, omp_get_level());
#pragma omp parallel
        {
            int ntid = omp_get_thread_num();
            printf("Innter| Thread num: %d, Thread level: %d\n", tid, omp_get_level());
            printf("Got %d and %d\n", tid, ntid);
            result[tid][ntid] = true;
        }
    }

    print_line_thread;

    for (int i = 0; i < num_threads; i++)
        for (int j = 0; j < num_threads; j++)
            if (result[i][j] != true)
            {
                printf("result[%d][%d] = %d\n", i, j, result[i][j]);
                return 1;
            }
    print_line_thread;
    return 0;
}
