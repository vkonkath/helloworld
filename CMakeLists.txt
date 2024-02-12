cmake_minimum_required(VERSION 3.20)
project(helloworld)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

include_directories(include)

file(GLOB SOURCES "src/*.cpp")

add_library(HelloWorldLib ${SOURCES})

add_executable(HelloWorldApp src/main.cpp)
target_link_libraries(HelloWorldApp PRIVATE HelloWorldLib)

include(FetchContent)
FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz
)
FetchContent_MakeAvailable(googletest)
enable_testing()

# Tests
file(GLOB TEST_SOURCES "tests/*.cpp")
add_executable(HelloWorldTest ${TEST_SOURCES})
target_link_libraries(HelloWorldTest PRIVATE HelloWorldLib gtest gtest_main)

# Add a tests
add_test(NAME HelloWorldTest COMMAND HelloWorldTest)

# Code coverage setup (assuming you have separate tests coverage for unit tests)
include("CodeCoverage.cmake")

append_coverage_compiler_flags()

set(COVERAGE_GCOV_EXCLUDES '/usr/*' '*/test/*')
set(COVERAGE_EXCLUDES '.*/googletest-src/.*' '.*/test/.*')
setup_target_for_coverage_lcov(
        NAME coverage                    # New target name
        EXECUTABLE HelloWorldTest       # Executable to run to collect coverage data
        DEPENDENCIES HelloWorldTest    # Dependencies to build before testing
)
# Add code coverage target
add_custom_target(helloworld_coverage
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/coverage-data
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR} lcov --capture --directory ${CMAKE_CURRENT_BINARY_DIR} --output-file ${CMAKE_CURRENT_BINARY_DIR}/coverage.info
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR} lcov --remove ${CMAKE_CURRENT_BINARY_DIR}/coverage.info '/usr/*' '*/test/*' --output-file ${CMAKE_CURRENT_BINARY_DIR}/coverage.info.cleaned
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR} genhtml ${CMAKE_CURRENT_BINARY_DIR}/coverage.info.cleaned --output-directory ${CMAKE_CURRENT_BINARY_DIR}/coverage-html
    COMMAND cat ${CMAKE_CURRENT_BINARY_DIR}/coverage.info.cleaned
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating code coverage report"
)

