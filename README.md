# AmigDev Docker Crosstools

Currently AmigaOS 3.x, AmigaOS 4.x and MorphOS 3.9+ are supported. 
WarpOS and AROS will get supported in the forseeable future

## Supported toolchains
Platform | Toolchain | Supported 
------------ | ------------ | -------------
AmigaOS 3.x | @bebbo toolchain - gcc 6 | **Yes**
AmigaOS 4.x | @sba1 adtools - gcc 8 | **Yes**
MorphOS 3.9+ | MorphOS Team (un)official tools - gcc 6 | **Yes**
~WarpOS~ | ~gcc 6~ | Not yet
~AROS ABIv1 x86_64~ | ~AROS Team Official - gcc 9~ | Not yet
~AROS ABIv1 x86~ | ~AROS Team Official - gcc 9~ | Not yet
~AROS ABIv1 ARM BE (RasPi)~ | ~AROS Team Official - gcc 9~ | Not yet


### AmigaOS4.x example:
```bash
docker run --rm \
	-v ${PWD}:/work \
	-v /path/to/extra/ppc-amigaos/lib:/tools/usr/lib \
	-v /path/to/extra/ppc-amigaos/include:/tools/usr/include \
	-it amigadev/crosstools:ppc-amigaos bash
```

### AmigaOS3.x example
```bash
docker run --rm \
	-v ${PWD}:/work \
	-v /path/to/extra/m68k-amigaos/lib:/tools/usr/lib \
	-v /path/to/extra/m68k-amigaos/include:/tools/usr/include \
	-it amigadev/crosstools:m68k-amigaos bash
```

### MorphOS example
```bashS
docker run --rm \
	-v ${PWD}:/work \
	-v /path/to/extra/ppc-morphos/lib:/tools/usr/lib \
	-v /path/to/extra/ppc-morphos/include:/tools/usr/include \
	-it amigadev/crosstools:ppc-morphos bash
```

* *${PWD}* is the current dir
* */path/to/extra* are if you want to add any extra libraries

## Bugs / Support / Issues
Please inquire about any support, bugs or issues in the Github issue tracker on this repository and I'll try to help as best I can.

// Marlon Beijer @ AmigaDev Team
