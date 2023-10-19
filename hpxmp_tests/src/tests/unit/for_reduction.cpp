//  Copyright (c) 2018 Tianyi Zhang
//  Adapted from kempj omp-reduction.c
//
//  Distributed under the Boost Software License, Version 1.0. (See accompanying
//  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <omp.h>
#include <stdio.h>

#ifdef HPXC
#include <hpx/hpx_main.hpp>
#include <math.h>
// #include <hpxc/util/wrap_main.hpp>
#endif // HPXC

int main()
{
    int i, num_steps = 15000, x, sum = 0, pi;

#pragma omp parallel for reduction(+ : sum)
    for (i = 1; i <= num_steps; i++)
    {
        sum += i;
        printf("i = %d, sum = %d, thread = %d\n", i, sum, omp_get_thread_num());
    }

    double sum2 = 1;

    for (int i = 1; i < num_steps; i++) {
        sum2 = sin(2*sum2 + 3) + 123;
        printf("i = %d, sum = %d, thread = %d\n", i, sum2, omp_get_thread_num());
    }

    sum2 = 1;

#pragma omp parallel for
    for (int i = 1; i < num_steps; i++) {
        sum2 = sin(2*sum2 + 3) + 123;
        printf("i = %d, sum = %d, thread = %d\n", i, sum2, omp_get_thread_num());
    }

    return 0;
}
