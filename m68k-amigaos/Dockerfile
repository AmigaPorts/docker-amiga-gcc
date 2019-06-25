FROM sebastianbergmann/amiga-gcc:latest

ENV CROSS_PFX m68k-amigaos

# Temporary fix
RUN ln -s /opt/amiga /opt/${CROSS_PFX}

#include "../common.docker"
