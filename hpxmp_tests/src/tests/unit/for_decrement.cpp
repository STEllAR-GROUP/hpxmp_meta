// Copyright (c) 2018 Tianyi Zhang
// Adapted from kempj omp-for-decrement.c
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <iostream>
#include <vector>
#include <omp.h>

#ifdef HPXMP
#include <hpxc/util/wrap_main.h>
#endif // HPXMP


int main()
{
    int i, j;
    int result[10];
    int result_2[5];
    int result_3[5][5];

    printf("loop 1:\n");
#pragma omp parallel
    {
#pragma omp for
        for (i = 9; i >= 0; i--)
        {
            result[i] = i;
            printf("%d ", result[i]);
        }
    }

    printf("\nloop 2:\n");
#pragma omp parallel for
    for (i = 8; i >= 0; i -= 2)
    {
        result_2[i / 2] = i;
        printf("%d ", result[i / 2]);
    }

    printf("\nloop 7: nested par for loops\n");
#pragma omp parallel for
    for (i = 4; i >= 0; i--)
    {
#pragma omp parallel for firstprivate(i)
        for (j = 4; j >= 0; j--)
        {
            result_3[i][j] = i * 10 + j;
            printf("%d, %d\n", i, j);
        }
    }

    for (int i = 0; i < 10; i++)
    {
        if (result[i] != i)
            return 1;
    }

    for (int i = 0; i < 9; i += 2)
    {
        if (result_2[i / 2] != i)
            return 1;
    }

    for (i = 0; i < 5; i++)
    {
        for (j = 0; j < 5; j++)
        {
            if (result_3[i][j] != i * 10 + j)
                return 1;
        }
    }
    return 0;
}
