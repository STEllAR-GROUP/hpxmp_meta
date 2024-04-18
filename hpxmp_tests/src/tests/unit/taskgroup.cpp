//  Copyright (c) 2018 Tianyi Zhang
//
//  Distributed under the Boost Software License, Version 1.0. (See accompanying
//  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <omp.h>
#include <iostream>
#include <vector>
#include <atomic>

#ifdef HPXMP
#include <hpxc/util/wrap_main.h>
#endif // HPXMP

//this code is not working with release under both openmp and hpxmp
int main(int argc, char *argv[]) {
    std::vector<int> result(5,0);
    std::atomic<int> position(-1);
#pragma omp parallel
    {
#pragma omp single
        {
            printf("A ");
            position++;
            result[position] = 1;
#pragma omp taskgroup
            {
#pragma omp task
                {
                    printf("race ");
                    position++;
                    result[position] = 2;
                }
#pragma omp task
                {
                    printf("car ");
                    position++;
                    result[position] = 2;
#pragma omp task
                    {
                        printf("is");
                        position++;
                        result[position] = 2;
                    }
                }
            }
            printf(" fun to watch ");
            position++;
            result[position] = 3;
        }
    } // End of parallel region

    for(int i = 0; i < 3; i++){
        if(result[i] > result[i+1])
            return 1;
    }
    return 0;
}
