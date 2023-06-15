cmake_minimum_required(VERSION 3.18)

project(hpxMP C CXX)
option(WITH_HPXC "Use HPX threading system." OFF)
if (WITH_HPXC)
  find_package(HPX REQUIRED)
  add_definitions(-DHPXC)
endif()

set(CMAKE_CXX_FLAGS "-fopenmp")

add_executable(hello_world hello.cpp)
if (WITH_HPXC)
  target_link_libraries(hello_world ${OMP_LIB_PATH} pthread HPX::hpx HPX::wrap_main)
else()
  target_link_libraries(hello_world ${OMP_LIB_PATH} pthread)
endif()
