ARG BUILD_OS
ARG BUILD_PFX

FROM amigadev/${BUILD_PFX}:latest as build-env

FROM amigadev/docker-base:latest

ARG BUILD_OS
ARG BUILD_PFX

ENV CROSS_PFX $BUILD_PFX
ENV OS_NAME $BUILD_OS

COPY --from=build-env /opt/${CROSS_PFX} /opt/${CROSS_PFX}

# START COMMON
MAINTAINER Marlon Beijer "marlon@amigadev.com"
RUN apt update && apt install -y libtool automake autoconf && apt autoremove -y
RUN echo ${CROSS_PFX}
RUN echo "root:root" | chpasswd
RUN chmod 777 -R /opt/${CROSS_PFX}
RUN ln -s /opt/${CROSS_PFX} /tools
ENV CROSS_ROOT /opt/${CROSS_PFX}

WORKDIR /work
ENTRYPOINT ["/entry/entrypoint.sh"]

COPY imagefiles/cmake.sh /usr/local/bin/cmake
COPY imagefiles/ccmake.sh /usr/local/bin/ccmake
COPY imagefiles/entrypoint.sh /entry/

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
RUN mv -fv /CMakeModules/* /usr/share/cmake-`cmake --version|awk '{ print $3;exit }'|awk -F. '{print $1"."$2}'`/Modules/
RUN ln -s /usr/share/cmake-`cmake --version|awk '{ print $3;exit }'|awk -F. '{print $1"."$2}'`/Modules/Platform/Generic.cmake /usr/share/cmake-`cmake --version|awk '{ print $3;exit }'|awk -F. '{print $1"."$2}'`/Modules/Platform/${OS_NAME}.cmake
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/lib/${CROSS_PFX}.cmake
ENV CMAKE_PREFIX_PATH /opt/${CROSS_PFX}:/opt/${CROSS_PFX}/usr
ENV PATH ${PATH}:${CROSS_ROOT}/bin

COPY platforms/${CROSS_PFX}/prep.sh prep.sh
RUN ./prep.sh && rm -rf prep.sh
# END COMMON
