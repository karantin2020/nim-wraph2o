import os
const memory_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/memory.h"

const ArrayDummySize = when defined(cpu16): 10_000 else: 100_000_000

type H2O_VECTOR*[T] = object
  entries*: array [0..ArrayDummySize, T]
  size*: csize
  capacity*: csize

type h2o_vector_t* = H2O_VECTOR[void]


type
  h2o_buffer_prototype_t* = st_h2o_buffer_prototype_t

#*
#  buffer structure compatible with iovec
# 

  h2o_iovec_t* {.pure, final, importc: "h2o_iovec_t", header: memory_header_file.} = object
    base* {.importc: "base".}: cstring
    inner_len* {.importc: "len".}: csize

  st_h2o_mem_recycle_chunk_t* {.pure, final, importc: "st_h2o_mem_recycle_chunk_t",
                               nodecl.} = object
    next* {.importc: "next".}: ptr st_h2o_mem_recycle_chunk_t

  st_h2o_mem_pool_chunk_t* {.pure, final, importc: "st_h2o_mem_pool_chunk_t", nodecl.} = object
    next* {.importc: "next".}: ptr st_h2o_mem_pool_chunk_t
    inner_dummy* {.importc: "_dummy".}: csize # align to 2*sizeof(void*) 
    bytes* {.importc: "bytes".}: array[4096 - sizeof(pointer)*2, char]

  st_h2o_mem_pool_direct_t* {.pure, final, importc: "st_h2o_mem_pool_direct_t", nodecl.} = object
    next* {.importc: "next".}: ptr st_h2o_mem_pool_direct_t
    inner_dummy* {.importc: "_dummy".}: csize # align to 2*sizeof(void*) 
    bytes* {.importc: "bytes".}: array[1, char]

  st_h2o_mem_pool_shared_ref_t* {.pure, final, importc: "st_h2o_mem_pool_shared_ref_t", nodecl.} = object
    next* {.importc: "next".}: ptr st_h2o_mem_pool_shared_ref_t
    entry* {.importc: "entry".}: ptr st_h2o_mem_pool_shared_entry_t

  h2o_mem_recycle_t* {.pure, final, importc: "h2o_mem_recycle_t", header: memory_header_file.} = object
    max* {.importc: "max".}: csize
    cnt* {.importc: "cnt".}: csize
    inner_link* {.importc: "_link".}: ptr st_h2o_mem_recycle_chunk_t

  st_h2o_mem_pool_shared_entry_t* {.pure, final, importc: "st_h2o_mem_pool_shared_entry_t",
                                   header: memory_header_file.} = object
    refcnt* {.importc: "refcnt".}: csize
    dispose* {.importc: "dispose".}: proc (a2: pointer) {.cdecl.}
    bytes* {.importc: "bytes".}: array[1, char]


#*
#  the memory pool
#

  h2o_mem_pool_t* {.pure, final, importc: "h2o_mem_pool_t", header: memory_header_file.} = object
    chunks* {.importc: "chunks".}: ptr st_h2o_mem_pool_chunk_t
    chunk_offset* {.importc: "chunk_offset".}: csize
    shared_refs* {.importc: "shared_refs".}: ptr st_h2o_mem_pool_shared_ref_t
    directs* {.importc: "directs".}: ptr st_h2o_mem_pool_direct_t


#*
#  buffer used to store incoming / outgoing octets
# 

  h2o_buffer_t* {.pure, final, importc: "h2o_buffer_t", header: memory_header_file.} = object
#*
#      capacity of the buffer (or minimum initial capacity in case of a prototype (i.e. bytes == NULL))
#     
    capacity* {.importc: "capacity".}: csize 
#*
#      amount of the data available
#     
    size* {.importc: "size".}: csize 
#*
#      pointer to the start of the data (or NULL if is pointing to a prototype)
#     
    bytes* {.importc: "bytes".}: cstring 
#*
#      prototype (or NULL if the instance is part of the prototype (i.e. bytes == NULL))
#     
    inner_prototype* {.importc: "_prototype".}: ptr h2o_buffer_prototype_t 
#*
#      file descriptor (if not -1, used to store the buffer)
#     
    inner_fd* {.importc: "_fd".}: cint
    inner_buf* {.importc: "_buf".}: array[1, char]

  h2o_buffer_mmap_settings_t* {.pure, final, importc: "h2o_buffer_mmap_settings_t",
                               header: memory_header_file.} = object
    threshold* {.importc: "threshold".}: csize
    fn_template* {.importc: "fn_template".}: array[4096, char]

  st_h2o_buffer_prototype_t* {.pure, final, importc: "st_h2o_buffer_prototype_t",
                              header: memory_header_file.} = object
    allocator* {.importc: "allocator".}: h2o_mem_recycle_t
    inner_initial_buf* {.importc: "_initial_buf".}: h2o_buffer_t
    mmap_settings* {.importc: "mmap_settings".}: ptr h2o_buffer_mmap_settings_t

#*
# tests if target chunk (target_len bytes long) is equal to test chunk (test_len bytes long)
#
proc h2o_memis*(target: pointer; target_len: csize; test: pointer; test_len: csize): cint {.
    cdecl, importc: "h2o_memis", header: memory_header_file.}
#*
#  constructor for h2o_iovec_t
# 

proc h2o_iovec_init*(base: cstring; inner_len: csize): h2o_iovec_t {.cdecl,
    importc: "h2o_iovec_init", header: memory_header_file.}


when isMainModule:
  type
    Foo = object
      a: string
      b: int

  var foo: H2O_VECTOR[Foo]

  echo foo.size