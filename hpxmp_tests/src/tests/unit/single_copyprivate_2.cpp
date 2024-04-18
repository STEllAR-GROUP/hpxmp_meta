//  Copyright (c) 2018 Tianyi Zhang
//
//  Distributed under the Boost Software License, Version 1.0. (See accompanying
//  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <stdio.h>
#include <omp.h>

#define print_line printf("Line: %d\n", __LINE__)
#define print_line_thread printf("Line: %d, Thread: %d\n", __LINE__, omp_get_thread_num())

#ifdef HPXMP
#include <hpxc/util/wrap_main.h>
#endif // HPXMP

int x = 0, y = 0, Global = 0;
#pragma omp threadprivate(x, y)
float get_int() {
    Global += 1;
    return Global;
}

void use_int(int f, int t) {
    printf("Value = %d, thread = %d\n", f, t);
}

int main() {
    print_line;
    printf("call CopyPrivate from a single thread\n");
#pragma omp single copyprivate(x, y)
    {
        print_line_thread;
        x = get_int();
        print_line_thread;
        y = get_int();
        print_line_thread;
    }
    use_int(x, omp_get_thread_num());
    print_line_thread;

    use_int(y, omp_get_thread_num());
    print_line_thread;

    printf("Line: %d, x = %d, y = %d\n",__LINE__, x, y);

    printf("call CopyPrivate from a parallel region\n");
    print_line_thread;

#pragma omp parallel
    {
        print_line_thread;
#pragma omp single copyprivate(x, y)
        {
        print_line_thread;
            x = get_int();
        print_line_thread;
            y = get_int();
        print_line_thread;
        }
        print_line_thread;
        use_int(x, omp_get_thread_num());
        print_line_thread;
        use_int(y, omp_get_thread_num());
        print_line_thread;
    }
    print_line;

    return 0;
}
