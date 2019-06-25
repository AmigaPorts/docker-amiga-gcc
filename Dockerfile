FROM sebastianbergmann/amiga-gcc
MAINTAINER Marlon Beijer "marlon@amigadev.com"

RUN apt-get update && apt-get install -y apt-utils cmake wget git make

RUN echo "root:root" | chpasswd

WORKDIR /work
#ENTRYPOINT ["/dockcross/entrypoint.sh"]
