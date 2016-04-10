import memory

import os
const
  url_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/url.h"

type
  uint16_t = uint16

type
  st_h2o_url_scheme_t* = h2o_url_scheme_t
  
  h2o_url_scheme_t* {.pure, final, importc: "h2o_url_scheme_t", 
      header: url_header_file.} = object
    name* {.importc: "name".}: h2o_iovec_t
    default_port* {.importc: "default_port".}: uint16_t

  h2o_url_t* {.pure, final, importc: "h2o_url_t", header: url_header_file.} = object
    scheme* {.importc: "scheme".}: ptr h2o_url_scheme_t
    authority* {.importc: "authority".}: h2o_iovec_t # i.e. host:port 
    host* {.importc: "host".}: h2o_iovec_t
    path* {.importc: "path".}: h2o_iovec_t
    inner_port* {.importc: "_port".}: uint16_t
