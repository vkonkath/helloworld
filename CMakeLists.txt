cmake_minimum_required(VERSION 3.20)
project(helloworld)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Set C/C++ flags
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

# Include directories
include_directories(include)

# Source files
file(GLOB SOURCES "src/*.cpp")

# Executable
add_executable(HelloWorld ${SOURCES})

# Google Test
include(FetchContent)
FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz
)
FetchContent_MakeAvailable(googletest)
enable_testing()

# Tests
add_executable(HelloWorldTest test/test.cpp)
target_link_libraries(HelloWorldTest gtest_main)
add_test(NAME HelloWorldTest COMMAND HelloWorldTest)

# Code coverage setup
include("CodeCoverage.cmake")

# Add coverage flags
append_coverage_compiler_flags()

# Set the output directory for coverage files
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
        COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_BINARY_DIR} genhtml ${CMAKE_CURRENT_BINARY_DIR}/coverage.info.cleaned -o ${CMAKE_CURRENT_BINARY_DIR}/coverage-html
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating code coverage report"
)


