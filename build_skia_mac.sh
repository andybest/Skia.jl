#!/usr/bin/env bash

set -eo pipefail

export MACOSX_DEPLOYMENT_TARGET=11.0

./get_deps.sh

BUILD_DIR=${PWD}/skia/build
X64_OUT_DIR="${BUILD_DIR}/x64"
ARM_OUT_DIR="${BUILD_DIR}/arm64"
DEPOT_TOOLS_DIR=${PWD}/skia/depot_tools
export PATH="${DEPOT_TOOLS_DIR}":"${PATH}"

SKIA_ARGS=" \
    is_official_build=true \
    skia_use_metal=true \
    skia_enable_pdf=true \
    skia_use_zlib=true \
    skia_use_fonthost_mac=true \
    skia_use_system_harfbuzz=false \
    skia_use_system_libjpeg_turbo=false \
    skia_use_system_libpng=false \
    skia_use_system_libwebp=false \
    skia_use_system_zlib=false \
    skia_use_system_libwebp=false \
    skia_use_system_expat=false \
    skia_use_system_icu=false \
    extra_cflags=[ \
        \"-mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}\", \
        \"-I/usr/local/include\", \
        \"-I/usr/local/include/harfbuzz\", \
        \"-I/opt/homebrew/include\" \
    ] \
    extra_cflags_cc=[ \
        \"-DHAVE_XLOCALE_H\", \
        \"-I/usr/local/include\", \
        \"-I/usr/local/include/harfbuzz\", \
        \"-I/opt/homebrew/include\" \
    ] \
    extra_cflags_c=[ \
        \"-DHAVE_ARC4RANDOM_BUF\", \
        \"-stdlib=libc++\", \
        \"-I/usr/local/include\", \
        \"-I/usr/local/include/harfbuzz\", \
        \"-I/opt/homebrew/include\" \
    ] \
    "

cd skia/skia
gn gen ../out/x86_64 --args="${SKIA_ARGS} target_cpu=\"x86_64\""
ninja -C ../out/x86_64

gn gen ../out/arm64 --args="${SKIA_ARGS} target_cpu=\"arm64\"" 
ninja -C ../out/arm64


mkdir -p ../../lib
echo "Building Skia universal library"
lipo -create ../out/x86_64/libskia.a ../out/arm64/libskia.a -output ../../lib/libskia.a
