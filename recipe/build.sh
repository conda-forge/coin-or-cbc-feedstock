#!/usr/bin/env bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./Cbc
cp $BUILD_PREFIX/share/gnuconfig/config.* .
set -e

UNAME="$(uname)"
export CFLAGS="${CFLAGS} -O3"
export CXXFLAGS="${CXXFLAGS} -O3"
export CXXFLAGS="${CXXFLAGS//-std=c++17/-std=c++11}"

# Use only 1 thread with OpenBLAS to avoid timeouts on CIs.
# This should have no other affect on the build. A user
# should still be able to set this (or not) to a different
# value at run-time to get the expected amount of parallelism.
export OPENBLAS_NUM_THREADS=1

./configure --prefix="${PREFIX}" --exec-prefix="${PREFIX}" \
  --enable-cbc-parallel \
  --enable-gnu-packages \
  || { echo "PRINTING CONFIG.LOG"; cat config.log; echo "PRINTING CoinUtils/CONFIG.LOG"; cat CoinUtils/config.log; exit 1; }
make -j "${CPU_COUNT}"

make install
