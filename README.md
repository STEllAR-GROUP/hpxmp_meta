# HPXMP Meta

This project contains tests, examples and useful scripts for compiling and using [HPXMP](https://github.com/STEllAR-GROUP/llvm-project/), the HPX-enabled OpenMP implementation.

## Building HPXMP

[HPXMP](https://github.com/STEllAR-GROUP/llvm-project/) is a modified version of llvm-project/openmp, which utilizes the [HPXC](https://github.com/STEllAR-GROUP/hpxc/) interface to run on top of the [HPX](https://github.com/STEllAR-GROUP/hpx) runtime.

Thus `HPX`, `HPXC` and `llvm-project/openmp` must be built using CMake (in that order, as each depends on the previous one).

The `scripts/` directory contains scripts which can be used directly (or referenced for the appropriate CMake configuration commands) for building all above libraries.

## Using HPXMP

As HPXMP is a modification of the llvm-project/openmp library, HPXMP builds a library named `libomp.so`, which is a drop-in replacement for any typical `libomp.so`/`libgomp.so` OpenMP library provided by your system.


>**Important:** Since pretty much all systems provide a `libomp.so`, it is easy to accidentally link to some other one. The only ways to make sure that the correct library is linked are 1) **Prepending(!)** HPXMP's libomp.so path to LD_LIBRARY_PATH, or 2) Adding HPXMP's libomp.so to LD_PRELOAD. 
>
>Please always check that the correct OpenMP shared library is linked to your program by using the **ldd** utility (or some equivalent).

There are two ways to link your program to the HPXMP library:

1. For programs built with CMake:

    1. Include the CMake Find Module for HPXMP (located in `cmake/FindHPXMP.cmake`) in your CMake project, and use `find_package(HPXMP)` to introduce the `HPXMP::hpxmp` target to your project. Then, link your program to the `HPXMP::hpxmp` target using `target_add_libraries(<my_program> HPX::hpxmp)`.

2. Manually:

    1. Link the HPXMP shared library (`libomp.so`) to your program.

    2. Link to HPXC's `libhpx_hpxc_wrap.a` and add the `-Wl,-wrap=main` linker flag when compiling your program. This will initialize HPXC/HPX before entering your program's `main` function. This is crucial as HPXMP functionality only works inside the context of the HPX runtime. Failing to do this properly will lead to exceptions/segfaults.
    