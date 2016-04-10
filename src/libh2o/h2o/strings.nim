import os, memory
const string_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/string_.h"

proc h2o_strdup* (pool: ptr h2o_mem_pool_t; s: cstring; inner_len: csize): h2o_iovec_t {.cdecl,
    importc: "h2o_strdup", header: string_header_file.}

# template H2O_STRLIT*(s: expr): expr =
#   (cstring(s), len(s))