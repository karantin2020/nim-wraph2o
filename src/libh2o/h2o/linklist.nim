import os
const linklist_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/linklist.h"

type
  st_h2o_linklist_t* {.pure, final, importc: "struct st_h2o_linklist_t",
      header: linklist_header_file.} = object
    next*: ptr st_h2o_linklist_t
    prev*: ptr st_h2o_linklist_t

  h2o_linklist_t* {.importc: "h2o_linklist_t", 
      header: linklist_header_file.} = st_h2o_linklist_t
