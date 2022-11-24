#!/usr/bin/env bash

mkdir -p deps
cd deps

JULIA_X86_64="https://julialang-s3.julialang.org/bin/mac/x64/1.8/julia-1.8.3-mac64.tar.gz"
JULIA_AARCH64="https://julialang-s3.julialang.org/bin/mac/aarch64/1.8/julia-1.8.3-macaarch64.tar.gz"

if [ ! -d "julia_x86_64" ]
then
    curl "$JULIA_X86_64" --output julia_x86_64.tar.gz
    tar -xvf julia_x86_64.tar.gz
    mv "julia-1.8.3" "julia_x86_64"
fi

if [ ! -d "julia_aarch64" ]
then
    curl "$JULIA_AARCH64" --output julia_aarch64.tar.gz
    tar -xvf julia_aarch64.tar.gz
    mv "julia-1.8.3" "julia_aarch64"
fi

mkdir -p libcxxwrap
cd libcxxwrap

git clone https://github.com/JuliaInterop/libcxxwrap-julia.git

abs_path () {    
    echo "$(cd $(dirname "$1");pwd)/$(basename "$1")"
}

JULIA_PREFIX_X86_64=abs_path

mkdir build_aarch64
pushd build_aarch64
cmake -DJulia_PREFIX="$(abs_path ../../julia_aarch64)" -DCMAKE_OSX_ARCHITECTURES="arm64" -GNinja ../libcxxwrap-julia
cmake --build . --config Release
popd

mkdir build_x86_64
pushd build_x86_64
cmake -DJulia_PREFIX="$(abs_path ../../julia_x86_64)" -DCMAKE_OSX_ARCHITECTURES="x86_64" -GNinja ../libcxxwrap-julia
cmake --build . --config Release
popd
