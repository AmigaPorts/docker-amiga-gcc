#!/bin/bash

# exit when any command fails
set -e

#set compiler params
export TARGET='ppc-morphos'
export SYSROOT=/opt/$TARGET
export PPC_CPU="-mhard-float"
export PPC_COMMON="-s -ffast-math -fomit-frame-pointer -noixemul"
export PPC_CFLAGS="${CFLAGS} ${PPC_CPU} ${PPC_COMMON}"
export PPC_CXXFLAGS="${CXXFLAGS} ${PPC_CPU} ${PPC_COMMON}"
export CURPATH="${PWD}"
export SUBMODULES="${CURPATH}/dependencies"

# ZLIB
git clone https://github.com/madler/zlib.git "${SUBMODULES}"/zlib
rm -rf "${SUBMODULES}"/zlib/build
mkdir -p "${SUBMODULES}"/zlib/build
cd "${SUBMODULES}"/zlib/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DZLIB_BUILD_TESTING=OFF -DZLIB_BUILD_SHARED=OFF -DPPC_COMMON="${PPC_COMMON} -O3 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++14"
cmake --build . --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
cd "${SUBMODULES}"

# codesets SDK 6.22
mkdir -p "${SUBMODULES}"/codesets
cd "${SUBMODULES}"/codesets
wget https://github.com/jens-maus/libcodesets/releases/download/6.22/codesets-6.22.lha -O codesets.lha
echo "029d3bf9dd8b85bef6f0ccb58c0b4123d16cc5042a1c13519698016f6966750c  codesets.lha" | sha256sum -c -
lha -x codesets.lha
mkdir -p "${SYSROOT}"/usr/include "${SYSROOT}"/usr/share/doc/codesets
cp -fvr codesets/Developer/include/* "${SYSROOT}"/usr/include/
cp -fv codesets/COPYING codesets/ReadMe "${SYSROOT}"/usr/share/doc/codesets/
cd "${SUBMODULES}"
rm -rf codesets

# SDL1.2
rm -rf powersdl_sdk*
wget http://aminet.net/dev/misc/powersdl_sdk.lha -O powersdl_sdk.lha
lha -x powersdl_sdk.lha
mkdir -p ${SYSROOT}/usr
cp -fvr powersdl_sdk/Developer/usr/local/* ${SYSROOT}/usr/
cd "${SUBMODULES}"

# lhasa
#cd "${SUBMODULES}"/lhasa
#./autogen.sh --host=${TARGET}
#CFLAGS="${PPC_CFLAGS}" CXXFLAGS="${PPC_CXXFLAGS}" ./configure --disable-sdltest --disable-shared --enable-static --host=${TARGET} --prefix=${SYSROOT}
#make -j$(getconf _NPROCESSORS_ONLN)
#make install
#cd "${SUBMODULES}"

cd "${CURPATH}"
