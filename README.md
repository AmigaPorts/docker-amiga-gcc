# AmigDev Docker Crosstools

## AmigaOS4.x example:
```
docker run --rm -v ${PWD}:/work -v /path/to/extra/ppc-amigaos/lib:/tools/usr/lib -v /path/to/extra/ppc-amigaos/include:/tools/usr/include -it amigadev/crosstools:ppc-amigaos bash
```

## AmigaOS3.x example
```
docker run --rm -v ${PWD}:/work -v /path/to/extra/m68k-amigaos/lib:/tools/usr/lib -v /path/to/extra/m68k-amigaos/include:/tools/usr/include -it amigadev/crosstools:m68k-amigaos bash

```

* *${PWD}* is the current dir
* */path/to/extra* are if you want to add any extra libraries
