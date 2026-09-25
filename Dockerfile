ARG BUILD_OS
ARG BUILD_PFX
ARG BUILD_IMAGE=docker.io/amigadev/${BUILD_PFX}:latest

FROM ${BUILD_IMAGE} AS build-env
ARG TARGETPLATFORM

FROM docker.io/amigadev/docker-base:latest

ARG BUILD_OS
ARG BUILD_PFX
ARG PREFIX

ENV CROSS_PFX=$PREFIX
ENV OS_NAME=$BUILD_OS

# START COMMON
MAINTAINER Marlon Beijer "marlon@amigadev.com"

RUN apt update && \
    apt install -y \
        libtool \
        automake \
        autoconf && \
    apt -y full-upgrade && \
    apt purge -y \
        build-essential \
        g++ \
        g++-16 \
        gcc \
        gcc-16 \
        cpp \
        gdb \
        flex \
        bison \
        libx11-dev \
        libsdl1.2-dev \
        libasound2-dev \
        libswitch-perl \
        libncurses-dev \
        libegl-dev \
        zlib1g-dev \
        libpng-dev \
        libmpfr-dev \
        libmpc-dev \
        libtool \
        libfl-dev && \
    apt autoremove -y

RUN echo ${CROSS_PFX}

RUN echo "root:root" | chpasswd

RUN ln -s /opt/${CROSS_PFX} /tools

ENV CROSS_ROOT=/opt/${CROSS_PFX}

COPY --from=build-env /opt/${CROSS_PFX} /opt/${CROSS_PFX}

WORKDIR /work

ENTRYPOINT ["/entry/entrypoint.sh"]

COPY imagefiles/cmake.sh /usr/local/bin/cmake
COPY imagefiles/ccmake.sh /usr/local/bin/ccmake
COPY imagefiles/entrypoint.sh /entry/
COPY imagefiles/patches/ /patches/

ENV AS=${CROSS_ROOT}/bin/${CROSS_PFX}-as \
    LD=${CROSS_ROOT}/bin/${CROSS_PFX}-ld \
    AR=${CROSS_ROOT}/bin/${CROSS_PFX}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_PFX}-gcc \
    CXX=${CROSS_ROOT}/bin/${CROSS_PFX}-g++ \
    RANLIB=${CROSS_ROOT}/bin/${CROSS_PFX}-ranlib

RUN ln -sf ${CROSS_ROOT}/bin/${CROSS_PFX}-as /usr/bin/as && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_PFX}-ar /usr/bin/ar && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_PFX}-ld /usr/bin/ld && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_PFX}-gcc /usr/bin/gcc && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_PFX}-g++ /usr/bin/g++ && \
    ln -sf ${CROSS_ROOT}/bin/${CROSS_PFX}-ranlib /usr/bin/ranlib

COPY dependencies/toolchains/${CROSS_PFX}.cmake ${CROSS_ROOT}/lib/
COPY dependencies/toolchains/Modules/${CROSS_PFX} /CMakeModules

RUN cmake --version

RUN cp -afv /CMakeModules/. \
        /usr/share/cmake-`cmake --version | awk '{ print $3;exit }' | awk -F. '{print $1"."$2}'`/Modules/ && \
    rm -rf /CMakeModules

RUN ln -s \
        /usr/share/cmake-`cmake --version | awk '{ print $3;exit }' | awk -F. '{print $1"."$2}'`/Modules/Platform/Generic.cmake \
        /usr/share/cmake-`cmake --version | awk '{ print $3;exit }' | awk -F. '{print $1"."$2}'`/Modules/Platform/${OS_NAME}.cmake

ENV CMAKE_TOOLCHAIN_FILE=${CROSS_ROOT}/lib/${CROSS_PFX}.cmake
ENV CMAKE_PREFIX_PATH=/opt/${CROSS_PFX}:/opt/${CROSS_PFX}/usr
ENV PATH=${PATH}:${CROSS_ROOT}/bin

COPY platforms/${CROSS_PFX}/prep.sh prep.sh

RUN ./prep.sh && rm -rf prep.sh

RUN chmod 777 -R /opt/${CROSS_PFX}

#
# Remove build-host tooling that is not needed by the final
# cross-compilation environment.
#
# These are deliberately removed only after prep.sh has completed,
# because prep.sh may depend on native GCC, Go, Rust, etc.
#
RUN rm -rf \
        /root/.rustup \
        /root/.cargo \
        /root/.cache \
        /usr/lib/go-* \
        /usr/share/go-* \
        /usr/libexec/gcc \
        /usr/lib/gcc/x86_64-linux-gnu \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /var/cache/debconf/* \
        /usr/share/doc/* \
        /usr/share/man/* \
		/usr/libexec/gcc \
		/usr/lib/gcc \
        /tmp/* \
        /var/tmp/* && \
    rm -f \
        /usr/bin/go \
        /usr/bin/gofmt && \
    find /work -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +

# END COMMON