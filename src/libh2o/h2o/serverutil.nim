import os
const serverutil_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/serverutil.h"

proc h2o_numproc*(): csize {.cdecl,
    importc: "h2o_numproc", header: serverutil_header_file.}