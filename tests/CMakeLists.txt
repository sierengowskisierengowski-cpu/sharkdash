# SPDX-License-Identifier: Apache-2.0

include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.17.0
  FIND_PACKAGE_ARGS NAMES GTest
)
FetchContent_MakeAvailable(googletest)

add_library(libsharkdash_test)
target_include_directories(libsharkdash_test PUBLIC ${PROJECT_SOURCE_DIR}/src)
target_link_libraries(libsharkdash_test libbtop GTest::gtest_main)

add_executable(sharkdash_test cpu_names.cpp tools.cpp)
target_link_libraries(sharkdash_test libsharkdash_test)

include(GoogleTest)
gtest_discover_tests(sharkdash_test)
