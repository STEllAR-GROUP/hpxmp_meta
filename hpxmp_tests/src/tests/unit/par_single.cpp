// Copyright (c) 2018 Tianyi Zhang
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#include <iostream>
#include <vector>
#include <omp.h>

#ifdef HPXC
#include <hpx/hpx_main.hpp>
// #include <hpxc/util/wrap_main.hpp>
#endif // HPXC

int main() {
    std::vector<int> result;
#pragma omp parallel
    {
#pragma omp single
        {
            result.push_back(46);
        }
    }
    if(result.size()!=1 || result[0] != 46) return 1;
    return 0;
}
