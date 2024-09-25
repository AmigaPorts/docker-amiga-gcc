#!/bin/bash

# exit when any command fails
set -e

#set compiler params
export TARGET='ppc-amigaos'
export SYSROOT=/opt/${TARGET}/usr
export M68K_CPU=""
export M68K_COMMON="-s -athread=single -ffast-math -fomit-frame-pointer -I${SYSROOT}/include -L${SYSROOT}/lib"
export M68K_CFLAGS="${CFLAGS} ${M68K_CPU} ${M68K_COMMON}"
export M68K_CXXFLAGS="${CXXFLAGS} ${M68K_CPU} ${M68K_COMMON}"
export CURPATH="${PWD}"
export SUBMODULES="${CURPATH}/dependencies"

# ZLIB
git clone https://github.com/madler/zlib.git "${SUBMODULES}"/zlib
rm -rf "${SUBMODULES}"/zlib/build
mkdir -p "${SUBMODULES}"/zlib/build
cd "${SUBMODULES}"/zlib/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DTOOLCHAIN_COMMON="${M68K_COMMON} -O3 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++14"
cmake --build . --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
cd "${SUBMODULES}"

#MiniGL
rm -rf MiniGL
mkdir -p "${SUBMODULES}"/MiniGL
cd "${SUBMODULES}"/MiniGL
wget http://os4depot.net/share/driver/graphics/minigl.lha -O minigl.lha
lha -x minigl.lha
mkdir -p ${SYSROOT}/include
mkdir -p ${SYSROOT}/lib
cp -fvr MiniGL/SDK/local/common/include/* ${SYSROOT}/include/
cp -fvr MiniGL/SDK/local/newlib/lib/* ${SYSROOT}/lib/
cd "${SUBMODULES}"

# SDL1.2
mkdir -p "${SUBMODULES}"/SDL
cd "${SUBMODULES}"/SDL
wget https://github.com/AmigaPorts/SDL-1.2/releases/download/v1.2.16-release-amigaos4/SDL.lha -O SDL.lha
lha -x SDL.lha
mkdir -p ${SYSROOT}/include
mkdir -p ${SYSROOT}/lib
cp -fvr SDL/SDK/local/newlib/include/* ${SYSROOT}/include/
cp -fvr SDL/SDK/local/newlib/lib/* ${SYSROOT}/lib/

# SDL2
#if [ ! -d "${SUBMODULES}/SDL" ]; then
#	git clone https://github.com/AmigaPorts/SDL.git "${SUBMODULES}"/SDL
#fi
mkdir -p "${SUBMODULES}"/SDL2
cd "${SUBMODULES}"/SDL2
wget https://github.com/AmigaPorts/SDL/releases/download/v2.30.5-amigaos4/SDL2.lha -O SDL2.lha
lha -x SDL2.lha
mkdir -p ${SYSROOT}/include
mkdir -p ${SYSROOT}/lib
cp -fvr SDL2/SDK/local/newlib/include/* ${SYSROOT}/include/
cp -fvr SDL2/SDK/local/newlib/lib/* ${SYSROOT}/lib/
#git pull
#make -f Makefile.amigaos4
##rm -rf "${SUBMODULES}"/SDL-build
##cmake -S"${SUBMODULES}"/SDL -B"${SUBMODULES}"/SDL-build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DHAVE_SDL_TIMERS=TRUE -DHAVE_SDL_THREADS=TRUE -DTOOLCHAIN_COMMON="${M68K_COMMON} -O3 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++17"
##cmake --build "${SUBMODULES}"/SDL-build --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
cd "${SUBMODULES}"

# Zziplib
#rm -rf "${SUBMODULES}"/zziplib/build
#mkdir -p "${SUBMODULES}"/zziplib/build
#cd "${SUBMODULES}"/zziplib/build
#cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${SYSROOT} -DM68K_CPU=68040 -DM68K_FPU=hard -DM68K_COMMON="${M68K_COMMON} -O2 -fno-exceptions -w -DBIG_ENDIAN -DAMIGA -fpermissive -std=c++14"
#cmake --build . --config Release --target install -- -j$(getconf _NPROCESSORS_ONLN)
#cd "${SUBMODULES}"

# lhasa
#cd ${SUBMODULES}/lhasa
#./autogen.sh --host=${TARGET}
#CFLAGS="${M68K_CFLAGS}" CXXFLAGS="${M68K_CXXFLAGS}" ./configure --disable-sdltest --disable-shared --enable-static --host=${TARGET} --prefix=${SYSROOT}
#make -j$(getconf _NPROCESSORS_ONLN)
#make install
#cd ${SUBMODULES}

cd "${CURPATH}"
