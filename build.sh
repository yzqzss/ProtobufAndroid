#!/usr/bin/env bash

if [[ -z "$ANDROID_NDK" ]]; then
  echo "Please specify the Android NDK environment variable \"NDK\"."
  exit 1
fi

git clone https://github.com/google/protobuf.git
cd protobuf
git submodule update --init --recursive

TARGET_ABI="$1"
TARGET_API="27"
PWD="$(pwd)"
generationDir="$PWD/build"
mkdir -p "${generationDir}"
cd "${generationDir}"

cmake -GNinja \
  -DANDROID_NDK="$ANDROID_NDK" \
  -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI="$TARGET_ABI" \
  -DANDROID_NATIVE_API_LEVEL="$TARGET_API" \
  -DCMAKE_SYSTEM_NAME="Android" \
  -DCMAKE_BUILD_TYPE="Release" \
  -DCFLAGS="-fPIE -fPIC" \
  -DLDFLAGS="-llog -lz -lc++_static" \
  -DANDROID_STL="c++_static" \ 
  ../.. || exit 1

cmake  --build .
cd "${generationDir}"
cmake  -DCMAKE_INSTALL_PREFIX="$PWD/protobuff_install" -P cmake_install.cmake
