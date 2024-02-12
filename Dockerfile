# Use an official GCC image as a base
FROM gcc:latest

# Install CMake
RUN apt-get update && apt-get install -y cmake

# Install lcov
RUN apt-get update && apt-get install -y lcov

# Set the working directory in the container
WORKDIR /app

# Copy the source code files into the container
COPY . /app

# Remove the existing build directory if it exists
RUN rm -rf build

# Create a new build directory
RUN mkdir build

# Run CMake to generate build files
RUN cmake -B /app/build /app

# Build the project
RUN cmake --build /app/build

# Run tests using CTest
RUN cd /app/build && ctest --output-on-failure

# Build the project with coverage flags
RUN cmake --build /app/build --target coverage

# Generate coverage reports using gcovr
#RUN gcovr --root /app --xml --output /app/coverage.xml

# Optionally, generate HTML reports using lcov
# Optionally, generate HTML reports using lcov
RUN lcov --capture --directory /app/build --output-file /app/coverage.info && \
    genhtml /app/coverage.info -o /app/coverage-html

# Set the command to run the executable
CMD ["/app/build/HelloWorld"]
