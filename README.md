# AmigaDev Docker Crosstools

Currently AmigaOS 3.x, AmigaOS 4.x and MorphOS 3.9+ are supported.
WarpOS and AROS will get supported in the forseeable future

## Supported toolchains
Platform | Toolchain | Supported
------------ | ------------ | -------------
AmigaOS 3.x | @bebbo toolchain - gcc 6 | **Yes**
AmigaOS 4.x | @sba1 adtools - gcc 8 | **Yes**
MorphOS 3.9+ | MorphOS Team SDK 3.14 - gcc 9 | **Yes**
~WarpOS~ | ~gcc 6~ | Not yet
~AROS ABIv1 x86_64~ | ~AROS Team Official - gcc 9~ | Not yet
~AROS ABIv1 x86~ | ~AROS Team Official - gcc 9~ | Not yet
~AROS ABIv0 x86~ | ~AROS Team Official - gcc 9~ | Not yet
~AROS ABIv1 ARM BE (RasPi)~ | ~AROS Team Official - gcc 9~ | Not yet

## Build the Docker container

Example for AmigaOS 4.x toolchain:
```
docker build -t "amigadev/crosstools:ppc-amigaos" --build-arg BUILD_OS=AmigaOS --build-arg BUILD_PFX=ppc-amigaos -f Dockerfile .
```
For other toolchains, use the appropriate parameters:

- AmigaOS 3.x (M680x0): `--build-arg BUILD_OS=AmigaOS --build-arg BUILD_PFX=m68k-amigaos`

- AmigaOS 4.x (PPC): `--build-arg BUILD_OS=AmigaOS --build-arg BUILD_PFX=ppc-amigaos`

- MorphOS (PPC): `--build-arg BUILD_OS=MorphOS --build-arg BUILD_PFX=ppc-morphos`

## Run the Docker container for compiling a third party application

### AmigaOS4.x example:
```bash
docker run

    # Destroy the container, once exited.
    # Comment this line out if you want to keep container after execution
    # for debugging
    --rm \

    # expose to the container the following local directories
    # format is:
    # <local_dir>:<container_dir>
    -v ${PWD}:/work \
    -v /path/to/extra/ppc-amigaos/lib:/tools/usr/lib \
    -v /path/to/extra/ppc-amigaos/include:/tools/usr/include \

    # Pass current UID and GID to container, so that it can change the
    # ownership of output files which are otherwise writen to outdir as
    # root
    -e USER=$( id -u ) -e GROUP=$( id -g ) \

    # Use this Docker image and then enter into it using the shell
    -it amigadev/crosstools:ppc-amigaos /bin/bash
```

### AmigaOS3.x example
```bash
docker run --rm \
    -v ${PWD}:/work \
    -v /path/to/extra/m68k-amigaos/lib:/tools/usr/lib \
    -v /path/to/extra/m68k-amigaos/include:/tools/usr/include \
    -e USER=$( id -u ) -e GROUP=$( id -g ) \
    -it amigadev/crosstools:m68k-amigaos bash
```

### MorphOS example
```bashS
docker run --rm \
    -v ${PWD}:/work \
    -v /path/to/extra/ppc-morphos/lib:/tools/usr/lib \
    -v /path/to/extra/ppc-morphos/include:/tools/usr/include \
    -e USER=$( id -u ) -e GROUP=$( id -g ) \
    -it amigadev/crosstools:ppc-morphos bash
```

### AROS (v1) x86_64 example
```bashS
docker run --rm \
    -v ${PWD}:/work \
    -v /tmp/aros:/tmp/aros \
    -e USER=$( id -u ) -e GROUP=$( id -g ) \
    -it amigadev/crosstools:x86_64-aros bash
```

* *${PWD}* is the current dir
* */path/to/extra* are if you want to add any extra libraries

## Bugs / Support / Issues
Please inquire about any support, bugs or issues in the Github issue tracker on this repository and I'll try to help as best I can.

// Marlon Beijer @ AmigaDev Team
