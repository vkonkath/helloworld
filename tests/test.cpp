#include "hello_world.hpp"
#include <gtest/gtest.h>

TEST(HelloWorldTest, Print) {
HelloWorld hello;
testing::internal::CaptureStdout();
hello.print();
std::string output = testing::internal::GetCapturedStdout();
EXPECT_EQ(output, "Hello, World!\n");
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}