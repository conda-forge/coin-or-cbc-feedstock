#!/usr/bin/env bash
set -e

UNAME="$(uname)"
export CFLAGS="${CFLAGS} -O3"
# Remove the -DCBC_THREAD_SAFE as soon as that is the default
# in Cbc, which should be the case once the current `refactor`
# branch is merged. For the relevant diff of CbcSolver.cpp, see:
# https://github.com/coin-or/Cbc/compare/refactor#diff-6552379e8609a8d357908aab36202c54cb8e73e2b98729f71e4cae2df2eea491
export CXXFLAGS="${CXXFLAGS} -O3 -DCBC_THREAD_SAFE"
export CXXFLAGS="${CXXFLAGS//-std=c++17/-std=c++11}"

# Use only 1 thread with OpenBLAS to avoid timeouts on CIs.
# This should have no other affect on the build. A user
# should still be able to set this (or not) to a different
# value at run-time to get the expected amount of parallelism.
export OPENBLAS_NUM_THREADS=1

WITH_BLAS_LIB="-L${PREFIX}/lib -lblas"
WITH_LAPACK_LIB="-L${PREFIX}/lib -llapack"

./configure --prefix="${PREFIX}" --exec-prefix="${PREFIX}" \
  --with-blas-lib="${WITH_BLAS_LIB}" \
  --with-lapack-lib="${WITH_LAPACK_LIB}" \
  --enable-cbc-parallel \
  --enable-gnu-packages \
  || { echo "PRINTING CONFIG.LOG"; cat config.log; echo "PRINTING CoinUtils/CONFIG.LOG"; cat CoinUtils/config.log; exit 1; }
make -j "${CPU_COUNT}"

make install