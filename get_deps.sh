#!/usr/bin/env sh

DEPOT_TOOLS_SHA=1cf1fb5d214aab7afec77d2fd646addea34e52ff
SKIA_BRANCH=chrome/m109

BUILD_DIR=${PWD}/skia/build
SKIA_DIR=${BUILD_DIR}/skia
DEPOT_TOOLS_DIR=${BUILD_DIR}/depot_tools
DIST=${PWD}/dist

# Setup the Skia tree, pulling sources, if needed.
mkdir -p skia
cd skia

if [ ! -e depot_tools ]; then
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
  cd depot_tools
  #git reset --hard "${DEPOT_TOOLS_COMMIT}"
  cd ..
fi
export PATH="${PWD}/depot_tools:${PATH}"

if [ ! -e skia ]; then
  git clone https://github.com/google/skia.git
  cd skia
  git checkout "${SKIA_BRANCH}"
  python3 tools/git-sync-deps
  cd ..
fi
