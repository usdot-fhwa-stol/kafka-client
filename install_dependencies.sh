#!/bin/bash

set -ex
# export BUILD_ARCHITECTURE=arm64
# Get ubuntu distribution code name. All STOL APT debian packages are pushed to S3 bucket based on distribution codename.
echo "BUILD_ARCHITECTURE=${BUILD_ARCHITECTURE}"
# Install spdlog
echo " ------> Install spdlog... "
cd /tmp
git clone https://github.com/gabime/spdlog.git -b v1.12.0
cd spdlog 
cmake -Bbuild -DCMAKE_POSITION_INDEPENDENT_CODE=ON 
cmake --build build
cmake --install build
cd .. 
rm -r spdlog

# Install librdkafka from instructions provided here https://github.com/confluentinc/librdkafka/tree/master/packaging/cmake
echo " ------> Install librdkafka..."
cd /tmp
git clone https://github.com/confluentinc/librdkafka.git -b v2.2.0
cd librdkafka/
cmake -H. -B_cmake_build
cmake --build _cmake_build
cmake --build _cmake_build --target install
cd ../
rm -r librdkafka
# Update dynamic linker
ldconfig

