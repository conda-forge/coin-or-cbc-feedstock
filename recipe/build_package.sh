#!/usr/bin/env bash
set -e

# LIBRARY_PREFIX will only be available on Windows
if [ ! -z ${LIBRARY_PREFIX+x} ]; then
    USE_PREFIX=$LIBRARY_PREFIX
else
    USE_PREFIX=$PREFIX
fi

if [[ "${target_platform}" == win-* ]]; then
  #COINUTILS_LIB=( --with-coinutils-lib='${LIBRARY_PREFIX}/lib/mkl_intel_ilp64.lib ${LIBRARY_PREFIX}/lib/mkl_sequential.lib ${LIBRARY_PREFIX}/lib/mkl_core.lib ${LIBRARY_PREFIX}/lib/libCoinUtils.lib' )
  #COINUTILS_INC=( --with-coinutils-incdir='${LIBRARY_PREFIX_COIN}' )
  #OSI_LIB=( --with-osi-lib='${LIBRARY_PREFIX}/lib/libOsi.lib' )
  #OSI_INC=( --with-osi-incdir='${LIBRARY_PREFIX_COIN}' )
  CLP_LIB=( --with-clp-lib='${LIBRARY_PREFIX}/lib/libClp.lib' )
  CGL_INC=( --with-clp-incdir='${LIBRARY_PREFIX_COIN}' )
  #CGL_LIB=( --with-cgl-lib='${LIBRARY_PREFIX}/lib/libCgl.lib' )
  #CLP_INC=( --with-cgl-incdir='${LIBRARY_PREFIX_COIN}' )
  COINDEPEND_LIB=( --with-coindepend-lib='${LIBRARY_PREFIX}/lib/mkl_intel_ilp64.lib ${LIBRARY_PREFIX}/lib/mkl_sequential.lib ${LIBRARY_PREFIX}/lib/mkl_core.lib ${LIBRARY_PREFIX}/lib/libCoinUtils.lib ${LIBRARY_PREFIX}/lib/libOsi.lib ${LIBRARY_PREFIX}/lib/libCgl.lib' )
  COINDEPEND_INC=( --with-coindepend-incdir='${LIBRARY_PREFIX_COIN}' )
  EXTRA_FLAGS=( --enable-msvc ) 
else
  # Get an updated config.sub and config.guess (for mac arm and lnx aarch64)
  cp $BUILD_PREFIX/share/gnuconfig/config.* ./Cbc 
  cp $BUILD_PREFIX/share/gnuconfig/config.* .
  #COINUTLS_LIB=()
  #COINUTILS_INC=()
  #OSI_LIB=()
  #OSI_INC=()
  CLP_LIB=()
  CLP_INC=()
  #CGL_LIB=()
  #CGL_INC=()
  COINDEPEND_LIB=()
  COINDEPEND_INC=()
  EXTRA_FLAGS=()
fi

./configure \
  --prefix="${USE_PREFIX}" \
  --exec-prefix="${USE_PREFIX}" \
  "${CLP_LIB[@]}" \
  "${CLP_INC[@]}" \
  "${COINDEPEND_LIB[@]}" \
  "${COINDEPEND_INC[@]}" \
  "${EXTRA_FLAGS[@]}" || cat Cbc/config.log

make -j "${CPU_COUNT}"

# Tests are broken without Data folder: https://github.com/coin-or/Osi/issues/184
#if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
#  make test
#fi

make install
