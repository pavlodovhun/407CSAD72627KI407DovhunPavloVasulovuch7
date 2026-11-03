cmake_minimum_required(VERSION 3.14)

project(hello LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(FetchContent)

FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)
include(GoogleTest)

add_library(add_lib src/add.cpp)
target_include_directories(add_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_executable(hello src/hello.cpp)
target_link_libraries(hello PRIVATE add_lib)

enable_testing()

add_executable(test_basic tests/test_basic.cpp)
target_link_libraries(test_basic PRIVATE add_lib GTest::gtest_main)
gtest_discover_tests(test_basic)
