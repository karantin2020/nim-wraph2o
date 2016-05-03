import os
const dirH2oPath = splitPath(currentSourcePath()).head


const 
  h2oPath = dirH2oPath & "/../../deps/h2o/"
  h2o_header_file          = h2oPath & "include/" & "h2o.h"
  default_header_file      = h2oPath & "include/" & "default.h"
  config_header_file       = h2oPath & "include/" & "h2o/configurator.h"
  multithread_header_file  = h2oPath & "include/" & "h2o/multithread.h"
  socket_header_file       = h2oPath & "include/" & "h2o/socket.h"
  timeout_header_file      = h2oPath & "include/" & "h2o/timeout.h"
  filecache_header_file    = h2oPath & "include/" & "h2o/filecache.h"
  socketpool_header_file   = h2oPath & "include/" & "h2o/socketpool.h"
  http1client_header_file  = h2oPath & "include/" & "h2o/http1client.h"

when defined(libuv):
  const
    uvbackend_header_file    = h2oPath & "include/" & "h2o/socket/uv-binding.h"
    uvbinding_header_file    = h2oPath & "include/" & "h2o/socket/uv-binding.h"

var
  SIZE_MAX* {.importc: "SIZE_MAX", 
      header: "<stdint.h>".}: csize

when defined(libuv):
  import libuv

import openssl

import h2o/linklist, h2o/memory, h2o/url

const
  H2O_EXPIRES_MODE_ABSOLUTE* = 0
  H2O_EXPIRES_MODE_MAX_AGE* = 1


const
  H2O_FILE_FLAG_NO_ETAG* = 0x00000001
  H2O_FILE_FLAG_DIR_LISTING* = 0x00000002
  H2O_FILE_FLAG_SEND_GZIP* = 0x00000004


const
  H2O_HEADERS_CMD_NULL* = 0
  H2O_HEADERS_CMD_ADD* = 1      # adds a new header line 
  H2O_HEADERS_CMD_APPEND* = 2   # adds a new header line or contenates to the existing header 
  H2O_HEADERS_CMD_MERGE* = 3    # merges the value into a comma-listed values of the named header 
  H2O_HEADERS_CMD_SET* = 4      # sets a header line, overwriting the existing one (if any) 
  H2O_HEADERS_CMD_SETIFEMPTY* = 5 # sets a header line if empty 
  H2O_HEADERS_CMD_UNSET* = 6    # removes the named header(s) 

const
  H2O_TIMESTR_RFC1123_LEN* = len("Sun, 06 Nov 1994 08:49:37 GMT")
  H2O_TIMESTR_LOG_LEN* = len("29/Aug/2014:15:34:38 +0900")

when not defined(H2O_SOMAXCONN):
  # simply use a large value, and let the kernel clip it to the internal max 
  const
    H2O_SOMAXCONN* = 65535

when defined(windows):
  import winlean
elif defined(posix):
  import posix
else:
  {.error: "h2o module not ported to your operating system!".}

type 
  timeval = Timeval
    

const
  H2O_DEFAULT_MAX_REQUEST_ENTITY_SIZE* = (1024 * 1024 * 1024)
  H2O_DEFAULT_MAX_DELEGATIONS* = 5
  H2O_DEFAULT_HANDSHAKE_TIMEOUT_IN_SECS* = 10
  H2O_DEFAULT_HANDSHAKE_TIMEOUT* = (H2O_DEFAULT_HANDSHAKE_TIMEOUT_IN_SECS * 1000)
  H2O_DEFAULT_HTTP1_REQ_TIMEOUT_IN_SECS* = 10
  H2O_DEFAULT_HTTP1_REQ_TIMEOUT* = (H2O_DEFAULT_HTTP1_REQ_TIMEOUT_IN_SECS * 1000)
  H2O_DEFAULT_HTTP1_UPGRADE_TO_HTTP2* = 1
  H2O_DEFAULT_HTTP2_IDLE_TIMEOUT_IN_SECS* = 10
  H2O_DEFAULT_HTTP2_IDLE_TIMEOUT* = (H2O_DEFAULT_HTTP2_IDLE_TIMEOUT_IN_SECS * 1000)
  H2O_DEFAULT_PROXY_IO_TIMEOUT_IN_SECS* = 30
  H2O_DEFAULT_PROXY_IO_TIMEOUT* = (H2O_DEFAULT_PROXY_IO_TIMEOUT_IN_SECS * 1000)
  H2O_DEFAULT_PROXY_WEBSOCKET_TIMEOUT_IN_SECS* = 300
  H2O_DEFAULT_PROXY_WEBSOCKET_TIMEOUT* = (
    H2O_DEFAULT_PROXY_WEBSOCKET_TIMEOUT_IN_SECS * 1000)


type
  uint16_t = uint16
  uint64_t = uint64
  int64_t = int64

  ptrSSL* = openssl.SslPtr

  h2o_conn_t* {.pure, 
      importc: "h2o_conn_t", 
      header: h2o_header_file.} = st_h2o_conn_t
  h2o_req_t* {.pure, 
      importc: "h2o_req_t", 
      header: h2o_header_file.} = st_h2o_req_t
  h2o_ostream_t* {.pure, 
      importc: "h2o_ostream_t", 
      header: h2o_header_file.} = st_h2o_ostream_t
  h2o_configurator_command_t* {.pure, 
      importc: "h2o_configurator_command_t", 
      header: h2o_header_file.} = st_h2o_configurator_command_t
  h2o_configurator_t* {.pure, 
      importc: "h2o_configurator_t", 
      header: h2o_header_file.} = st_h2o_configurator_t
  h2o_hostconf_t* {.pure, 
      importc: "h2o_hostconf_t", 
      header: h2o_header_file.} = st_h2o_hostconf_t
  h2o_globalconf_t* {.pure, 
      importc: "h2o_globalconf_t", 
      header: h2o_header_file.} = st_h2o_globalconf_t
  h2o_mimemap_t* {.pure, 
      importc: "h2o_mimemap_t", 
      header: h2o_header_file.} = st_h2o_mimemap_t
  h2o_handler_t* {.pure, 
      importc: "h2o_handler_t", 
      header: h2o_header_file.} = st_h2o_handler_t
  h2o_configurator_context_t* {.pure, 
      importc: "h2o_configurator_context_t", 
      header: config_header_file.} = st_h2o_configurator_context_t
  h2o_filecache_t* = st_h2o_filecache_t
  h2o_loop_t* = pointer
  
#
#  Filecache
#
  # kh_opencache_set_t* {.importc: "kh_opencache_set_t", nodecl.} = kh_type_s[cstring, cchar]

  st_h2o_filecache_t* {.pure, final, importc: "struct st_h2o_filecache_t", 
      header: filecache_header_file.} = object
    hash* {.importc: "hash".}: pointer # ptr kh_opencache_set_t
    lru* {.importc: "lru".}: h2o_linklist_t 
    capacity* {.importc: "capacity".}: csize

#
#  Http1client
#
  h2o_http1client_ctx_t* = st_h2o_http1client_ctx_t
  
  st_h2o_http1client_ctx_t* {.pure, final, 
      importc: "struct st_h2o_http1client_ctx_t", header: http1client_header_file.} = object
    loop* {.importc: "loop".}: ptr h2o_loop_t
    getaddr_receiver* {.importc: "getaddr_receiver".}: ptr h2o_multithread_receiver_t
    io_timeout* {.importc: "io_timeout".}: ptr h2o_timeout_t
    websocket_timeout* {.importc: "websocket_timeout".}: ptr h2o_timeout_t # NULL if upgrade to websocket is not allowed 


  INNER_C_STRUCT_14839894197891031362* {.pure, final, nodecl.} = object
    active* {.importc: "active".}: h2o_linklist_t
    inactive* {.importc: "inactive".}: h2o_linklist_t

  ASYNC_INNER_STRUCT* {.pure, final, nodecl.} = object
    write* {.importc: "write".}: cint
    read* {.importc: "read".}: ptr h2o_socket_t

  st_h2o_multithread_queue_t* {.pure, final, importc: "struct st_h2o_multithread_queue_t",
        header: multithread_header_file.} = object
    when defined(libuv):
      async* {.importc: "async".}: TAsync
    else:
      async* {.importc: "async".}: ASYNC_INNER_STRUCT
    mutex* {.importc: "mutex".}: Pthread_mutex
    receivers* {.importc: "receivers".}: INNER_C_STRUCT_14839894197891031362

#
#   Socketpool section
#
  en_h2o_socketpool_type_t* {.pure.} = h2o_socketpool_type_t
  h2o_socketpool_type_t* {.size: sizeof(cint).} = enum
    H2O_SOCKETPOOL_TYPE_NAMED, H2O_SOCKETPOOL_TYPE_SOCKADDR

  INNER_C_STRUCT_7529710315106130399* {.pure, final, nodecl.} = object
    host* {.importc: "host".}: h2o_iovec_t
    port* {.importc: "port".}: h2o_iovec_t

  INNER_C_STRUCT_11004473571754684104* {.pure, final, nodecl.} = object
    bytes* {.importc: "bytes".}: Sockaddr_storage
    inner_len* {.importc: "len".}: Socklen

  INNER_C_UNION_17971719856398639520* {.pure, final, nodecl.} = object {.
      union.}
    named* {.importc: "named".}: INNER_C_STRUCT_7529710315106130399
    sockaddr* {.importc: "sockaddr".}: INNER_C_STRUCT_11004473571754684104

  INNER_C_STRUCT_11846041220264245296* {.pure, final, nodecl.} = object
    loop* {.importc: "loop".}: ptr h2o_loop_t
    timeout* {.importc: "timeout".}: h2o_timeout_t
    entry* {.importc: "entry".}: h2o_timeout_entry_t

  INNER_C_STRUCT_4678378262080396629* {.pure, final, nodecl.} = object
    count* {.importc: "count".}: csize # synchronous operations should be used to access the variable 
    mutex* {.importc: "mutex".}: Pthread_mutex
    sockets* {.importc: "sockets".}: h2o_linklist_t # guarded by the mutex; list of struct pool_entry_t defined in socket/pool.c 
  
  h2o_socketpool_t* {.pure.} = st_h2o_socketpool_t
  st_h2o_socketpool_t* {.pure, final, importc: "struct st_h2o_socketpool_t", 
      header: socketpool_header_file.} = object
    inner_type* {.importc: "type".}: h2o_socketpool_type_t # read-only vars 
    peer* {.importc: "peer".}: INNER_C_UNION_17971719856398639520
    capacity* {.importc: "capacity".}: csize
    timeout* {.importc: "timeout".}: uint64_t # in milliseconds (UINT64_MAX if not set) 
    inner_interval_cb* {.importc: "_interval_cb".}: INNER_C_STRUCT_11846041220264245296 # 
    #   vars that are modified by multiple threads 
    inner_shared* {.importc: "_shared".}: INNER_C_STRUCT_4678378262080396629

#*
#  abstraction layer for sockets (SSL vs. TCP)
# 
  INNER_SOCKET_STATE_TYPE* {.size: sizeof(cint).} = enum
    ASYNC_RESUMPTION_STATE_COMPLETE = 0, # just pass thru 
    ASYNC_RESUMPTION_STATE_RECORD, # record first input and restore SSL state if state changes to REQUEST_SENT 
    ASYNC_RESUMPTION_STATE_REQUEST_SENT # async request has been sent, and is waiting for response 

  INNER_C_STRUCT_14839892780510929290* {.pure, final.} = object
    state* {.importc: "state".}: INNER_SOCKET_STATE_TYPE
    session_data* {.importc: "session_data".}: pointer

  INNER_C_STRUCT_11004446628111479868* {.pure, final.} = object
    cb* {.importc: "cb".}: h2o_socket_cb
    async_resumption* {.importc: "async_resumption".}: INNER_C_STRUCT_14839892780510929290

  INNER_C_STRUCT_11846041307076175017* {.pure, final.} = object
    encrypted* {.importc: "encrypted".}: ptr h2o_buffer_t

  INNER_C_STRUCT_9928425415115142600* {.pure, final.} = object
    bufs*: H2O_VECTOR[h2o_iovec_t]
    pool* {.importc: "pool".}: h2o_mem_pool_t   # placed at the last 
  
  st_h2o_socket_ssl_t* {.pure, final, importc: "struct st_h2o_socket_ssl_t".} = object
    ssl* {.importc: "ssl".}: ptrSSL
    did_write_in_read* {.importc: "did_write_in_read".}: ptr cint # used for detecting and closing the connection upon renegotiation (FIXME implement renegotiation) 
    handshake* {.importc: "handshake".}: INNER_C_STRUCT_11004446628111479868
    input* {.importc: "input".}: INNER_C_STRUCT_11846041307076175017
    output* {.importc: "output".}: INNER_C_STRUCT_9928425415115142600

  INNER_C_STRUCT_4925036179929631970* {.pure, final, nodecl.} = object
    cb* {.importc: "cb".}: proc (data: pointer) {.cdecl.}
    data* {.importc: "data".}: pointer

  INNER_C_STRUCT_9346675604446717832* {.pure, final, nodecl.} = object
    read* {.importc: "read".}: h2o_socket_cb
    write* {.importc: "write".}: h2o_socket_cb

  st_h2o_socket_t* {.pure, final, importc: "struct st_h2o_socket_t", 
      header: socket_header_file.} = object
    data* {.importc: "data".}: pointer
    ssl* {.importc: "ssl".}: pointer # ptr st_h2o_socket_ssl_t
    input* {.importc: "input".}: ptr h2o_buffer_t
    bytes_read* {.importc: "bytes_read".}: csize
    on_close* {.importc: "on_close".}: INNER_C_STRUCT_4925036179929631970
    inner_cb* {.importc: "_cb".}: INNER_C_STRUCT_9346675604446717832
    inner_peername* {.importc: "_peername".}: ptr st_h2o_socket_peername_t

  h2o_socket_t* {.importc: "h2o_socket_t", 
      header: socket_header_file.} = st_h2o_socket_t

  h2o_socket_cb* {.importc: "h2o_socket_cb", 
      header: socket_header_file.} = proc (sock: ptr h2o_socket_t; err: cint) {.cdecl.}

  st_h2o_socket_peername_t* {.pure, final, importc: "struct st_h2o_socket_peername_t", 
      header: socket_header_file.} = object
    inner_len* {.importc: "len".}: Socklen
    inner_addr* {.importc: "addr".}: SockAddr

#
#  Timeout section
#
  # h2o_timeout_entry_t* = st_h2o_timeout_entry_t
  h2o_timeout_cb* {.importc: "h2o_timeout_cb", 
      header: timeout_header_file.} = proc (entry: ptr h2o_timeout_entry_t) {.cdecl.}

#*
#  an entry linked to h2o_timeout_t.
#  Modules willing to use timeouts should embed this object as part of itself, and link it to a specific timeout by calling
#  h2o_timeout_link.
# 
  st_h2o_timeout_entry_t* {.pure, final, importc: "struct st_h2o_timeout_entry_t", 
      header: timeout_header_file.} = object
    registered_at* {.importc: "registered_at".}: uint64_t
    cb* {.importc: "cb".}: h2o_timeout_cb
    inner_link* {.importc: "_link".}: h2o_linklist_t

  h2o_timeout_entry_t* = st_h2o_timeout_entry_t
#*
#  represents a collection of h2o_timeout_entry_t linked to a single timeout value
# 
  h2o_timeout_t* {.pure, final, 
      importc: "h2o_timeout_t", header: timeout_header_file.} = object
    timeout* {.importc: "timeout".}: uint64_t
    inner_link* {.importc: "_link".}: h2o_linklist_t
    inner_entries* {.importc: "_entries".}: h2o_linklist_t # link list of h2o_timeout_entry_t 
    inner_backend* {.importc: "_backend".}: st_h2o_timeout_backend_properties_t

  st_h2o_timeout_backend_properties_t* {.pure, final, 
      importc: "st_h2o_timeout_backend_properties_t",
      header: socket_header_file.} = object
    inner_dummy* {.importc: "_dummy".}: cchar

  h2o_multithread_queue_t* {.pure, 
      importc: "h2o_multithread_queue_t", 
      header: multithread_header_file.} = st_h2o_multithread_queue_t

  h2o_multithread_receiver_cb* {.
      importc: "h2o_multithread_receiver_cb", 
      header: multithread_header_file.} = proc (receiver: ptr h2o_multithread_receiver_t;
                                    messages: ptr h2o_linklist_t) {.cdecl.}
  
  st_h2o_multithread_receiver_t* {.pure, final, importc: "struct st_h2o_multithread_receiver_t",
      header: multithread_header_file.} = object
    queue* {.importc: "queue".}: ptr h2o_multithread_queue_t
    inner_link* {.importc: "_link".}: h2o_linklist_t
    inner_messages* {.importc: "_messages".}: h2o_linklist_t
    cb* {.importc: "cb".}: h2o_multithread_receiver_cb

  h2o_multithread_receiver_t* {.pure, importc: "h2o_multithread_receiver_t",
                                  header: multithread_header_file.} = st_h2o_multithread_receiver_t

  kh_type_s* {.pure, final.} [K,V] = object
    n_buckets {.importc: "khint_t".}: uint
    size {.importc: "khint_t".}: uint
    n_occupied {.importc: "khint_t".}: uint
    upper_bound {.importc: "khint_t".}: uint
    flags {.importc: "khint32_t".}: ptr uint
    keys {.importc: "khkey_t".}: ptr K
    vals {.importc: "khval_t".}: ptr V

  # kh_extmap_t* {.importc: "kh_extmap_t", nodecl.} = kh_type_s[cstring, ptr h2o_mimemap_type_t]
  # kh_typeset_t* {.importc: "kh_typeset_t", nodecl.} = kh_type_s[ptr h2o_mimemap_type_t, cchar]

  st_h2o_mimemap_t* {.pure, final, importc: "struct st_h2o_mimemap_t".} = object
    default_type* {.importc: "default_type".}: ptr h2o_mimemap_type_t 
    extmap* {.importc: "extmap".}: pointer # ptr kh_extmap_t
    typeset* {.importc: "typeset".}: pointer # ptr kh_typeset_t # refs point to the entries in extmap
    num_dynamic* {.importc: "num_dynamic".}: csize

  yoml_type_t* {.size: sizeof(cint).} = enum
    YOML_TYPE_SCALAR, YOML_TYPE_SEQUENCE, YOML_TYPE_MAPPING,
    YOML_TYPE_UNRESOLVED_ALIAS
  
  yoml_sequence_t* {.pure, final, importc: "yoml_sequence_t".} = object
    size* {.importc: "size".}: csize
    elements* {.importc: "elements".}: array[1, ptr yoml_t]

  yoml_mapping_element_t* {.pure, final, importc: "yoml_mapping_element_t".} = object
    key* {.importc: "key".}: ptr yoml_t
    value* {.importc: "value".}: ptr yoml_t

  yoml_mapping_t* {.pure, final, importc: "yoml_mapping_t".} = object
    size* {.importc: "size".}: csize
    elements* {.importc: "elements".}: array[1, yoml_mapping_element_t]

  INNER_C_UNION_16722625168103291946* {.pure, final.} = object {.
      union.}
    scalar* {.importc: "scalar".}: cstring
    sequence* {.importc: "sequence".}: yoml_sequence_t
    mapping* {.importc: "mapping".}: yoml_mapping_t
    alias* {.importc: "alias".}: cstring

  st_yoml_t* {.pure, final, importc: "struct st_yoml_t".} = object
    `type`* {.importc: "type".}: yoml_type_t
    filename* {.importc: "filename".}: cstring
    line* {.importc: "line".}: csize
    column* {.importc: "column".}: csize
    anchor* {.importc: "anchor".}: cstring
    inner_refcnt* {.importc: "_refcnt".}: csize
    data* {.importc: "data".}: INNER_C_UNION_16722625168103291946

  yoml_t* {.importc: "yoml_t".} = st_yoml_t  

  st_h2o_configurator_context_t* {.pure, final, importc: "struct st_h2o_configurator_context_t",
                               header: config_header_file.} = object
    globalconf* {.importc: "globalconf".}: ptr h2o_globalconf_t
    hostconf* {.importc: "hostconf".}: ptr h2o_hostconf_t
    pathconf* {.importc: "pathconf".}: ptr h2o_pathconf_t
    mimemap* {.importc: "mimemap".}: ptr ptr h2o_mimemap_t
    dry_run* {.importc: "dry_run".}: cint
    parent* {.importc: "parent".}: ptr st_h2o_configurator_context_t

  h2o_configurator_dispose_cb* {.importc: "h2o_configurator_dispose_cb",
      header: config_header_file.} = proc (configurator: ptr h2o_configurator_t): cint {.
    cdecl.}
  
  h2o_configurator_enter_cb* {.importc: "h2o_configurator_enter_cb",
      header: config_header_file.} = proc (configurator: ptr h2o_configurator_t;
    ctx: ptr h2o_configurator_context_t; node: ptr yoml_t): cint {.cdecl.}
  
  h2o_configurator_exit_cb* {.importc: "h2o_configurator_exit_cb",
      header: config_header_file.} = proc (configurator: ptr h2o_configurator_t;
   ctx: ptr h2o_configurator_context_t; node: ptr yoml_t): cint {.cdecl.}

  h2o_configurator_command_cb* {.importc: "h2o_configurator_command_cb",
      header: config_header_file.} = proc (cmd: ptr h2o_configurator_command_t;
    ctx: ptr h2o_configurator_context_t; node: ptr yoml_t): cint {.cdecl.}

  st_h2o_configurator_command_t* {.pure, final, importc: "struct st_h2o_configurator_command_t",
                                  header: config_header_file.} = object
#*
#      configurator to which the command belongs
#     
    configurator* {.importc: "configurator".}: ptr h2o_configurator_t 
#*
#      name of the command handled by the configurator
#     
    name* {.importc: "name".}: cstring 
#*
#      flags
#     
    flags* {.importc: "flags".}: cint 
#*
#      mandatory callback called to handle the command
#     
    cb* {.importc: "cb".}: h2o_configurator_command_cb
#*
#  basic structure of a configurator (handles a configuration command)
# 

  st_h2o_configurator_t* {.pure, final, importc: "struct st_h2o_configurator_t",
                          header: config_header_file.} = object
    inner_link* {.importc: "_link".}: h2o_linklist_t 
#*
#      optional callback called when the global config is being disposed
#     
    dispose* {.importc: "dispose".}: h2o_configurator_dispose_cb 
#*
#      optional callback called before the configuration commands are handled
#     
    enter* {.importc: "enter".}: h2o_configurator_enter_cb 
#*
#      optional callback called after all the configuration commands are handled
#     
    exit* {.importc: "exit".}: h2o_configurator_exit_cb 
#*
#      list of commands
#     
    commands* {.importc: "commands".}: H2O_VECTOR[h2o_configurator_command_t]
  

#*
#  a predefined, read-only, fast variant of h2o_iovec_t, defined in h2o/token.h
# 

  h2o_token_t* {.pure, final, importc: "h2o_token_t", header: h2o_header_file.} = object
    buf* {.importc: "buf".}: h2o_iovec_t
    http2_static_table_name_index* {.importc: "http2_static_table_name_index".}: cchar 
    # non-zero if any
    proxy_should_drop* {.importc: "proxy_should_drop", bitsize: 1.}: cchar
    is_init_header_special* {.importc: "is_init_header_special", bitsize: 1.}: cchar
    http2_should_reject* {.importc: "http2_should_reject", bitsize: 1.}: cchar
    copy_for_push_request* {.importc: "copy_for_push_request", bitsize: 1.}: cchar

#
#  basic structure of a handler (an object that MAY generate a response)
#  The handlers should register themselves to h2o_context_t::handlers.
# 

  st_h2o_handler_t* {.pure, final, importc: "struct st_h2o_handler_t", header: h2o_header_file.} = object
    inner_config_slot* {.importc: "_config_slot".}: csize
    on_context_init* {.importc: "on_context_init".}: proc (
        self: ptr h2o_handler_t; ctx: ptr h2o_context_t) {.cdecl.}
    on_context_dispose* {.importc: "on_context_dispose".}: proc (
        self: ptr h2o_handler_t; ctx: ptr h2o_context_t) {.cdecl.}
    dispose* {.importc: "dispose".}: proc (self: ptr h2o_handler_t) {.cdecl.}
    on_req* {.importc: "on_req".}: proc (self: ptr h2o_handler_t; req: ptr h2o_req_t): cint {.
        cdecl.}


#*
#  basic structure of a filter (an object that MAY modify a response)
#  The filters should register themselves to h2o_context_t::filters.
# 
  
  st_h2o_filter_t* {.pure, final, importc: "struct st_h2o_filter_t", header: h2o_header_file.} = object
    inner_config_slot* {.importc: "_config_slot".}: csize
    on_context_init* {.importc: "on_context_init".}: proc (
        self: ptr st_h2o_filter_t; ctx: ptr h2o_context_t) {.cdecl.}
    on_context_dispose* {.importc: "on_context_dispose".}: proc (
        self: ptr st_h2o_filter_t; ctx: ptr h2o_context_t) {.cdecl.}
    dispose* {.importc: "dispose".}: proc (self: ptr st_h2o_filter_t) {.cdecl.}
    on_setup_ostream* {.importc: "on_setup_ostream".}: proc (
        self: ptr st_h2o_filter_t; req: ptr h2o_req_t; slot: ptr ptr h2o_ostream_t) {.
        cdecl.}

  h2o_filter_t* {.importc: "h2o_filter_t", header: h2o_header_file.} = st_h2o_filter_t
  
  
#*
#  basic structure of a logger (an object that MAY log a request)
#  The loggers should register themselves to h2o_context_t::loggers.
# 

  st_h2o_logger_t* {.pure, final, importc: "struct st_h2o_logger_t", header: h2o_header_file.} = object
    inner_config_slot* {.importc: "_config_slot".}: csize
    on_context_init* {.importc: "on_context_init".}: proc (
        self: ptr st_h2o_logger_t; ctx: ptr h2o_context_t) {.cdecl.}
    on_context_dispose* {.importc: "on_context_dispose".}: proc (
        self: ptr st_h2o_logger_t; ctx: ptr h2o_context_t) {.cdecl.}
    dispose* {.importc: "dispose".}: proc (self: ptr st_h2o_logger_t) {.cdecl.}
    log_access* {.importc: "log_access".}: proc (self: ptr st_h2o_logger_t;
        req: ptr h2o_req_t) {.cdecl.}

  h2o_logger_t* {.importc: "h2o_logger_t", header: h2o_header_file.} = st_h2o_logger_t
  
  
#*
#  contains stringified representations of a timestamp
# 

  h2o_timestamp_string_t* {.pure, final, importc: "h2o_timestamp_string_t", header: h2o_header_file.} = object
    rfc1123* {.importc: "rfc1123".}: array[H2O_TIMESTR_RFC1123_LEN + 1, cchar]
    log* {.importc: "log".}: array[H2O_TIMESTR_LOG_LEN + 1, cchar]


#*
#  a timestamp.
#  Applications should call h2o_get_timestamp to obtain a timestamp.
# 

  h2o_timestamp_t* {.pure, final, importc: "h2o_timestamp_t", header: h2o_header_file.} = object
    at* {.importc: "at".}: timeval
    str* {.importc: "str".}: ptr h2o_timestamp_string_t

  h2o_casper_conf_t* {.pure, final, importc: "h2o_casper_conf_t", header: h2o_header_file.} = object
    capacity_bits* {.importc: "capacity_bits".}: cuint 
#*
#      capacity bits (0 to disable casper)
#     
#*
#      whether if all type of files should be tracked (or only the blocking assets)
#     
    track_all_types* {.importc: "track_all_types".}: cint

  h2o_pathconf_t* {.pure, final, importc: "h2o_pathconf_t", header: h2o_header_file.} = object
    global* {.importc: "global".}: ptr h2o_globalconf_t 
#*
#      globalconf to which the pathconf belongs
#     
#*
#      pathname in lower case with "/" appended at last and NULL terminated (or is {NULL,0} if is fallback or extension-level)
#     
    path* {.importc: "path".}: h2o_iovec_t 
#*
#      list of handlers
#     
    handlers: H2O_VECTOR[ptr h2o_handler_t]
#*
#      list of filters
#     
    filters: H2O_VECTOR[ptr h2o_filter_t]
#*
#      list of loggers (h2o_logger_t)
#     
    loggers: H2O_VECTOR[ptr h2o_logger_t]
#*
#      mimemap
#     
    mimemap* {.importc: "mimemap".}: ptr h2o_mimemap_t

  INNER_C_STRUCT_7985397168147204338* {.pure, final, header: h2o_header_file.} = object
#*
#   host and port (in lower-case; base is NULL-terminated)
#   
    hostport* {.importc: "hostport".}: h2o_iovec_t
#*
#   in lower-case; base is NULL-terminated
#         
    host* {.importc: "host".}: h2o_iovec_t 
#*
#   port number (or 65535 if default)
#         
    port* {.importc: "port".}: uint16_t

  INNER_C_STRUCT_4650926120251441829* {.pure, final, header: h2o_header_file.} = object
    reprioritize_blocking_assets* {.importc: "reprioritize_blocking_assets".}: cint 
#*
#          whether if blocking assets being pulled should be given highest priority in case of clients that do not implement
#          dependency-based prioritization
#         
#*
#          casper settings
#         
    casper* {.importc: "casper".}: h2o_casper_conf_t

  st_h2o_hostconf_t* {.pure, final, importc: "struct st_h2o_hostconf_t", header: h2o_header_file.} = object
    global* {.importc: "global".}: ptr h2o_globalconf_t 
#*
#      reverse reference to the global configuration
#     
#*
#      host and port
#     
    authority* {.importc: "authority".}: INNER_C_STRUCT_7985397168147204338 
#*
#      list of path configurations
#     
    paths: H2O_VECTOR[h2o_pathconf_t]
#*
#      catch-all path configuration
#     
    fallback_path* {.importc: "fallback_path".}: h2o_pathconf_t 
#*
#      mimemap
#     
    mimemap* {.importc: "mimemap".}: ptr h2o_mimemap_t 
#*
#      http2
#     
    http2* {.importc: "http2".}: INNER_C_STRUCT_4650926120251441829

  h2o_protocol_callbacks_t* {.pure, final, importc: "h2o_protocol_callbacks_t", header: h2o_header_file.} = object
    request_shutdown* {.importc: "request_shutdown".}: proc (ctx: ptr h2o_context_t) {.
        cdecl.}

  INNER_C_STRUCT_4580901931538447706* {.pure, final, header: h2o_header_file.} = object
    req_timeout* {.importc: "req_timeout".}: uint64_t 
#*
#          request timeout (in milliseconds)
#         
#*
#          a boolean value indicating whether or not to upgrade to HTTP/2
#         
    upgrade_to_http2* {.importc: "upgrade_to_http2".}: cint 
#*
#          list of callbacks
#         
    callbacks* {.importc: "callbacks".}: h2o_protocol_callbacks_t

  INNER_C_STRUCT_1426428716774122547* {.pure, final, header: h2o_header_file.} = object
    idle_timeout* {.importc: "idle_timeout".}: uint64_t 
#*
#          idle timeout (in milliseconds)
#         
#*
#          maximum number of HTTP2 requests (per connection) to be handled simultaneously internally.
#          H2O accepts at most 256 requests over HTTP/2, but internally limits the number of in-flight requests to the value
#          specified by this property in order to limit the resources allocated to a single connection.
#         
    max_concurrent_requests_per_connection*
        {.importc: "max_concurrent_requests_per_connection".}: csize 
#*
#          maximum nuber of streams (per connection) to be allowed in IDLE / CLOSED state (used for tracking dependencies).
#         
    max_streams_for_priority* {.importc: "max_streams_for_priority".}: csize 
#*
#          list of callbacks
#         
    callbacks* {.importc: "callbacks".}: h2o_protocol_callbacks_t

  INNER_C_STRUCT_3128962674427983968* {.pure, final, header: h2o_header_file.} = object
    io_timeout* {.importc: "io_timeout".}: uint64_t 
#*
#          io timeout (in milliseconds)
#         
  
  INNER_C_STRUCT_7101232172041112076* {.pure, final, header: h2o_header_file.} = object
    capacity* {.importc: "capacity".}: csize # capacity of the filecache 
  
  st_h2o_globalconf_t* {.pure, final, importc: "struct st_h2o_globalconf_t", header: h2o_header_file.} = object
#*
#      a NULL-terminated list of host contexts (h2o_hostconf_t)
#     
    hosts* {.importc: "hosts".}: ptr ptr h2o_hostconf_t 
#*
#      list of configurators
#     
    configurators* {.importc: "configurators".}: h2o_linklist_t 
#*
#      name of the server (not the hostname)
#     
    server_name* {.importc: "server_name".}: h2o_iovec_t 
#*
#      maximum size of the accepted request entity (e.g. POST data)
#     
    max_request_entity_size* {.importc: "max_request_entity_size".}: csize 
#*
#      maximum count for delegations
#     
    max_delegations* {.importc: "max_delegations".}: cuint 
#*
#      setuid user (or NULL)
#     
    user* {.importc: "user".}: cstring 
#*
#      SSL handshake timeout
#     
    handshake_timeout* {.importc: "handshake_timeout".}: uint64_t
    http1* {.importc: "http1".}: INNER_C_STRUCT_4580901931538447706
    http2* {.importc: "http2".}: INNER_C_STRUCT_1426428716774122547
    proxy* {.importc: "proxy".}: INNER_C_STRUCT_3128962674427983968 
#*
#      mimemap
#     
    mimemap* {.importc: "mimemap".}: ptr h2o_mimemap_t 
#*
#      filecache
#     
    filecache* {.importc: "filecache".}: INNER_C_STRUCT_7101232172041112076
    inner_num_config_slots* {.importc: "_num_config_slots".}: csize


#*
#  holds various attributes related to the mime-type
# 

  inner_mime_attributes_enum* {.size: sizeof(cint).} = enum
    H2O_MIME_ATTRIBUTE_PRIORITY_NORMAL = 0, H2O_MIME_ATTRIBUTE_PRIORITY_HIGHEST

  h2o_mime_attributes_t* {.pure, final, importc: "h2o_mime_attributes_t", header: h2o_header_file.} = object
    is_compressible* {.importc: "is_compressible".}: cchar 
#*
#      whether if the content can be compressed by using gzip
#      how the resource should be prioritized
#     
    priority* {.importc: "priority".}: inner_mime_attributes_enum

#*
#  represents either a mime-type (and associated info), or contains pathinfo in case of a dynamic type (e.g. .php files)
# 

  INNER_C_STRUCT_10551406634688412434* {.pure, final, header: h2o_header_file.} = object
    mimetype* {.importc: "mimetype".}: h2o_iovec_t
    attr* {.importc: "attr".}: h2o_mime_attributes_t

  INNER_C_STRUCT_11423226962643575186* {.pure, final, header: h2o_header_file.} = object
    pathconf* {.importc: "pathconf".}: h2o_pathconf_t

  INNER_C_UNION_13933064937591325137* {.pure, final, header: h2o_header_file.} = object {.
      union.}
    ano_13633197134914157808* {.importc: "ano_13633197134914157808".}: INNER_C_STRUCT_10551406634688412434
    dynamic* {.importc: "dynamic".}: INNER_C_STRUCT_11423226962643575186
  
  INNER_MIMEMAP_TYPE_ENUM* {.size: sizeof(cint).} = enum
    H2O_MIMEMAP_TYPE_MIMETYPE = 0
    H2O_MIMEMAP_TYPE_DYNAMIC = 1

  h2o_mimemap_type_t* {.pure, final, importc: "h2o_mimemap_type_t", header: h2o_header_file.} = object
    data* {.importc: "data".}: INNER_C_UNION_13933064937591325137 
    mimemap_type* {.importc: "type".}: INNER_MIMEMAP_TYPE_ENUM
  

#*
#  context of the http server.
# 

  INNER_C_STRUCT_18182088747053585936* {.pure, final, header: h2o_header_file.} = object
    hostinfo_getaddr* {.importc: "hostinfo_getaddr".}: h2o_multithread_receiver_t

  INNER_C_STRUCT_4754981665112351437* {.pure, final, header: h2o_header_file.} = object
#*
#          request timeout
#         
    req_timeout* {.importc: "req_timeout".}: h2o_timeout_t 
  
  INNER_C_STRUCT_2138908048990515983* {.pure, final, header: h2o_header_file.} = object
#*
#          idle timeout
#         
    idle_timeout* {.importc: "idle_timeout".}: h2o_timeout_t 
#*
#          link-list of h2o_http2_conn_t
#         
    inner_conns* {.importc: "_conns".}: h2o_linklist_t 
#*
#          timeout entry used for graceful shutdown
#         
    inner_graceful_shutdown_timeout* {.importc: "_graceful_shutdown_timeout".}: h2o_timeout_entry_t

  INNER_C_STRUCT_2500480300880389636* {.pure, final, header: h2o_header_file.} = object
#*
#          the default client context for proxy
#         
    client_ctx* {.importc: "client_ctx".}: h2o_http1client_ctx_t 
#*
#          timeout handler used by the default client context
#         
    io_timeout* {.importc: "io_timeout".}: h2o_timeout_t

  INNER_C_STRUCT_4163440338403443898* {.pure, final, header: h2o_header_file.} = object
    uv_now_at* {.importc: "uv_now_at".}: uint64_t
    tv_at* {.importc: "tv_at".}: timeval
    value* {.importc: "value".}: ptr h2o_timestamp_string_t

  st_h2o_context_t* {.pure, final, importc: "struct st_h2o_context_t", header: h2o_header_file.} = object
#*
#      points to the loop (either uv_loop_t or h2o_evloop_t, depending on the value of H2O_USE_LIBUV)
#     
    loop* {.importc: "loop".}: pointer
#*
#      timeout structure to be used for registering deferred callbacks
#     
    zero_timeout* {.importc: "zero_timeout".}: h2o_timeout_t 
#*
#      timeout structure to be used for registering 1-second timeout callbacks
#     
    one_sec_timeout* {.importc: "one_sec_timeout".}: h2o_timeout_t 
#*
#      pointer to the global configuration
#     
    globalconf* {.importc: "globalconf".}: ptr h2o_globalconf_t 
#*
#      queue for receiving messages from other contexts
#     
    queue* {.importc: "queue".}: ptr h2o_multithread_queue_t 
#*
#      receivers
#     
    receivers* {.importc: "receivers".}: INNER_C_STRUCT_18182088747053585936 
#*
#      open file cache
#     
    filecache* {.importc: "filecache".}: ptr h2o_filecache_t 
#*
#      flag indicating if shutdown has been requested
#     
    shutdown_requested* {.importc: "shutdown_requested".}: cint 
#*
#      SSL handshake timeout
#     
    handshake_timeout* {.importc: "handshake_timeout".}: h2o_timeout_t
    http1* {.importc: "http1".}: INNER_C_STRUCT_4754981665112351437
    http2* {.importc: "http2".}: INNER_C_STRUCT_2138908048990515983
    proxy* {.importc: "proxy".}: INNER_C_STRUCT_2500480300880389636 
#*
#      pointer to per-module configs
#     
    inner_module_configs* {.importc: "_module_configs".}: ptr pointer
    inner_timestamp_cache* {.importc: "_timestamp_cache".}: INNER_C_STRUCT_4163440338403443898
    pathconfs_inited: H2O_VECTOR[ptr h2o_pathconf_t]
  
  h2o_context_t* {.pure, 
      importc: "h2o_context_t", 
      header: h2o_header_file.} = st_h2o_context_t
  
#*
#  represents a HTTP header
# 

  h2o_header_t* {.pure, final, importc: "h2o_header_t", header: h2o_header_file.} = object
    name* {.importc: "name".}: ptr h2o_iovec_t 
#*
#      name of the header (may point to h2o_token_t which is an optimized subclass of h2o_iovec_t)
#     
#*
#      value of the header
#     
    value* {.importc: "value".}: h2o_iovec_t


#*
#  list of headers
# 
  h2o_headers_t* {.pure, final, importc: "h2o_headers_t", header: h2o_header_file.} = H2O_VECTOR[h2o_header_t]
#*
#  an object that generates a response.
#  The object is typically constructed by handlers calling the h2o_start_response function.
# 

  st_h2o_generator_t* {.pure, final, importc: "struct st_h2o_generator_t", header: h2o_header_file.} = object
#*
#      called by the core to request new data to be pushed via the h2o_send function.
#     
    proceed* {.importc: "proceed".}: proc (self: ptr st_h2o_generator_t;
                                       req: ptr h2o_req_t) {.cdecl.} 
#*
#      called by the core when there is a need to terminate the response abruptly
#     
    stop* {.importc: "stop".}: proc (self: ptr st_h2o_generator_t; req: ptr h2o_req_t) {.
        cdecl.}

  h2o_generator_t* {.pure, importc: "h2o_generator_t", 
      header: h2o_header_file.} = st_h2o_generator_t
  
  h2o_ostream_pull_cb* = proc (generator: ptr h2o_generator_t; req: ptr h2o_req_t;
                            buf: ptr h2o_iovec_t): cint {.cdecl.}

#*
#  an output stream that may alter the output.
#  The object is typically constructed by filters calling the h2o_prepend_ostream function.
# 

  st_h2o_ostream_t* {.pure, final, importc: "struct st_h2o_ostream_t", header: h2o_header_file.} = object
    next* {.importc: "next".}: ptr st_h2o_ostream_t 
#*
#      points to the next output stream
#     
#*
#      called by the core to send output.
#      Intermediary output streams should process the given output and call the h2o_ostream_send_next function if any data can be
#      sent.
#     
    do_send* {.importc: "do_send".}: proc (self: ptr st_h2o_ostream_t;
                                       req: ptr h2o_req_t; bufs: ptr h2o_iovec_t;
                                       bufcnt: csize; is_final: cint) {.cdecl.} 
#*
#      called by the core when there is a need to terminate the response abruptly
#     
    stop* {.importc: "stop".}: proc (self: ptr st_h2o_ostream_t; req: ptr h2o_req_t) {.
        cdecl.} 
#*
#      whether if the ostream supports "pull" interface
#     
    start_pull* {.importc: "start_pull".}: proc (self: ptr st_h2o_ostream_t;
        cb: h2o_ostream_pull_cb) {.cdecl.}


#*
#  a HTTP response
# 

  h2o_res_t* {.pure, final, importc: "h2o_res_t", header: h2o_header_file.} = object
#*
#      status code
#     
    status* {.importc: "status".}: cint 
#*
#      reason phrase
#     
    reason* {.importc: "reason".}: cstring 
#*
#      length of the content (that is sent as the Content-Length header).
#      The default value is SIZE_MAX, which means that the length is indeterminate.
#      Generators should set this value whenever possible.
#     
    content_length* {.importc: "content_length".}: csize 
#*
#      list of response headers
#     
    headers* {.importc: "headers".}: h2o_headers_t 
#*
#      mime-related attributes (may be NULL)
#     
    mime_attr* {.importc: "mime_attr".}: ptr h2o_mime_attributes_t

  h2o_conn_callbacks_t* {.pure, final, importc: "h2o_conn_callbacks_t", header: h2o_header_file.} = object
    get_sockname* {.importc: "get_sockname".}: proc (conn: ptr h2o_conn_t;
        sa: ptr SockAddr): Socklen {.cdecl.} 
#*
#      getsockname (return size of the obtained address, or 0 if failed)
#     
#*
#      getpeername (return size of the obtained address, or 0 if failed)
#     
    get_peername* {.importc: "get_peername".}: proc (conn: ptr h2o_conn_t;
        sa: ptr SockAddr): Socklen {.cdecl.} 
#*
#      callback for server push (may be NULL)
#     
    push_path* {.importc: "push_path".}: proc (req: ptr h2o_req_t; abspath: cstring;
        abspath_len: csize) {.cdecl.}


#*
#  basic structure of an HTTP connection (HTTP/1, HTTP/2, etc.)
# 

  st_h2o_conn_t* {.pure, final, importc: "struct st_h2o_conn_t", header: h2o_header_file.} = object
    ctx* {.importc: "ctx".}: ptr h2o_context_t 
#*
#      the context of the server
#     
#*
#      NULL-terminated list of hostconfs bound to the connection
#     
    hosts* {.importc: "hosts".}: ptr ptr h2o_hostconf_t 
#*
#      time when the connection was established
#     
    connected_at* {.importc: "connected_at".}: timeval 
#*
#      callbacks
#     
    callbacks* {.importc: "callbacks".}: ptr h2o_conn_callbacks_t


#*
#  filter used for capturing a response (can be used to implement subreq)
# 

  INNER_C_STRUCT_15080871410937673105* {.pure, final, header: h2o_header_file.} = object
    host* {.importc: "host".}: h2o_iovec_t
    port* {.importc: "port".}: uint16_t

  INNER_C_STRUCT_2698502867145941009* {.pure, final, header: h2o_header_file.} = object
    match* {.importc: "match".}: ptr h2o_url_t 
#*
#          if the prefix of the location header matches the url, then the header will be rewritten
#         
#*
#          path prefix to be inserted upon rewrite
#         
    path_prefix* {.importc: "path_prefix".}: h2o_iovec_t

  st_h2o_req_prefilter_t* {.pure, final, importc: "struct st_h2o_req_prefilter_t", header: h2o_header_file.} = object
    next* {.importc: "next".}: ptr st_h2o_req_prefilter_t
    on_setup_ostream* {.importc: "on_setup_ostream".}: proc (
        self: ptr st_h2o_req_prefilter_t; req: ptr h2o_req_t;
        slot: ptr ptr h2o_ostream_t) {.cdecl.}

  h2o_req_prefilter_t* {.pure, importc: "h2o_req_prefilter_t", 
      header: h2o_header_file.} = st_h2o_req_prefilter_t

  h2o_req_overrides_t* {.pure, final, importc: "h2o_req_overrides_t", header: h2o_header_file.} = object
    client_ctx* {.importc: "client_ctx".}: ptr h2o_http1client_ctx_t 
#*
#      specific client context (or NULL)
#     
#*
#      socketpool to be used when connecting to upstream (or NULL)
#     
    socketpool* {.importc: "socketpool".}: ptr h2o_socketpool_t 
#*
#      upstream host:port to connect to (or host.base == NULL)
#     
    hostport* {.importc: "hostport".}: INNER_C_STRUCT_15080871410937673105 
#*
#      parameters for rewriting the `Location` header (only used if match.len != 0)
#     
    location_rewrite* {.importc: "location_rewrite".}: INNER_C_STRUCT_2698502867145941009


#*
#  additional information for extension-based dynamic content
# 

  h2o_filereq_t* {.pure, final, importc: "h2o_filereq_t", header: h2o_header_file.} = object
    url_path_len* {.importc: "url_path_len".}: csize
    local_path* {.importc: "local_path".}: h2o_iovec_t


#*
#  a HTTP request
# 

  INNER_C_STRUCT_6929507764423655478* {.pure, final, header: h2o_header_file.} = object
    scheme* {.importc: "scheme".}: ptr h2o_url_scheme_t 
#*
#          scheme (http, https, etc.)
#         
#*
#          authority (a.k.a. the Host header; the value is supplemented if missing before the handlers are being called)
#         
    authority* {.importc: "authority".}: h2o_iovec_t 
#*
#          method
#         
    inner_method* {.importc: "method".}: h2o_iovec_t 
#*
#          abs-path of the request (unmodified)
#         
    path* {.importc: "path".}: h2o_iovec_t 
#*
#          offset of '?' within path, or SIZE_MAX if not found
#         
    query_at* {.importc: "query_at".}: csize

  INNER_C_STRUCT_9576498346364529776* {.pure, final, header: h2o_header_file.} = object
    request_begin_at* {.importc: "request_begin_at".}: timeval
    request_body_begin_at* {.importc: "request_body_begin_at".}: timeval
    response_start_at* {.importc: "response_start_at".}: timeval
    response_end_at* {.importc: "response_end_at".}: timeval

  st_h2o_req_t* {.pure, final, importc: "struct st_h2o_req_t", header: h2o_header_file.} = object
#*
#      the underlying connection
#     
    conn* {.importc: "conn".}: ptr h2o_conn_t 
#*
#      the request sent by the client (as is)
#     
    input* {.importc: "input".}: INNER_C_STRUCT_6929507764423655478 
#*
#      the host context
#     
    hostconf* {.importc: "hostconf".}: ptr h2o_hostconf_t 
#*
#      the path context
#     
    pathconf* {.importc: "pathconf".}: ptr h2o_pathconf_t 
#*
#      scheme (http, https, etc.)
#     
    scheme* {.importc: "scheme".}: ptr h2o_url_scheme_t 
#*
#      authority (of the processing request)
#     
    authority* {.importc: "authority".}: h2o_iovec_t 
#*
#      method (of the processing request)
#     
    inner_method* {.importc: "method".}: h2o_iovec_t 
#*
#      abs-path of the processing request
#     
    path* {.importc: "path".}: h2o_iovec_t 
#*
#      offset of '?' within path, or SIZE_MAX if not found
#     
    query_at* {.importc: "query_at".}: csize 
#*
#      normalized path of the processing request (i.e. no "." or "..", no query)
#     
    path_normalized* {.importc: "path_normalized".}: h2o_iovec_t 
#*
#      filters assigned per request
#     
    prefilters* {.importc: "prefilters".}: ptr h2o_req_prefilter_t 
#*
#      additional information (becomes available for extension-based dynamic content)
#     
    filereq* {.importc: "filereq".}: ptr h2o_filereq_t 
#*
#      overrides (maybe NULL)
#     
    overrides* {.importc: "overrides".}: ptr h2o_req_overrides_t 
#*
#      the HTTP version (represented as 0xMMmm (M=major, m=minor))
#     
    version* {.importc: "version".}: cint 
#*
#      list of request headers
#     
    headers* {.importc: "headers".}: H2O_VECTOR[h2o_header_t] 
#*
#      the request entity (base == NULL if none)
#     
    entity* {.importc: "entity".}: h2o_iovec_t 
#*
#      remote_user (base == NULL if none)
#     
    # remote_user* {.importc: "remote_user".}: h2o_iovec_t 
#*
#      timestamp when the request was processed
#     
    processed_at* {.importc: "processed_at".}: h2o_timestamp_t 
#*
#      additional timestamps
#     
    timestamps* {.importc: "timestamps".}: INNER_C_STRUCT_9576498346364529776 
#*
#      the response
#     
    res* {.importc: "res".}: h2o_res_t 
#*
#      number of bytes sent by the generator (excluding headers)
#     
    bytes_sent* {.importc: "bytes_sent".}: csize 
#*
#      counts the number of times the request has been reprocessed (excluding delegation)
#     
    num_reprocessed* {.importc: "num_reprocessed".}: cuint 
#*
#      counts the number of times the request has been delegated
#     
    num_delegated* {.importc: "num_delegated".}: cuint # flags 
#
#      environment variables
#    
    env* {.importc: "env".}: H2O_VECTOR[h2o_iovec_t]
#*
#      whether or not the connection is persistent.
#      Applications should set this flag to zero in case the connection cannot be kept keep-alive (due to an error etc.)
#     
    http1_is_persistent* {.importc: "http1_is_persistent".}: cchar 
#*
#      whether if the response has been delegated (i.e. reproxied).
#      For delegated responses, redirect responses would be handled internally.
#
    res_is_delegated* {.importc: "res_is_delegated".}: cchar 
#*
#      the Upgrade request header (or { NULL, 0 } if not available)
#     
    upgrade* {.importc: "upgrade".}: h2o_iovec_t 
#*
#      preferred chunk size by the ostream
#     
    preferred_chunk_size* {.importc: "preferred_chunk_size".}: csize 
#      internal structure 
    inner_generator* {.importc: "_generator".}: ptr h2o_generator_t
    inner_ostr_top* {.importc: "_ostr_top".}: ptr h2o_ostream_t
    inner_next_filter_index* {.importc: "_next_filter_index".}: csize
    inner_timeout_entry* {.importc: "_timeout_entry".}: h2o_timeout_entry_t # per-request memory pool (placed at the last since the structure is large) 
    pool* {.importc: "pool".}: h2o_mem_pool_t

  h2o_accept_ctx_t* {.pure, final, importc: "h2o_accept_ctx_t", header: h2o_header_file.} = object
    ctx* {.importc: "ctx".}: ptr h2o_context_t
    hosts* {.importc: "hosts".}: ptr ptr h2o_hostconf_t
    ssl_ctx* {.importc: "ssl_ctx".}: ptr SSL_CTX
    expect_proxy_line* {.importc: "expect_proxy_line".}: cint
    libmemcached_receiver* {.importc: "libmemcached_receiver".}: ptr h2o_multithread_receiver_t

  # h2o_doublebuffer_t* {.pure, final, importc: "h2o_doublebuffer_t", header: h2o_header_file.} = object
  #   buf* {.importc: "buf".}: ptr h2o_buffer_t
  #   bytes_inflight* {.importc: "bytes_inflight".}: csize

# lib/errordoc.c 

  st_h2o_errordoc_t* {.pure, final, importc: "struct st_h2o_errordoc_t", header: h2o_header_file.} = object
    status* {.importc: "status".}: cint
    url* {.importc: "url".}: h2o_iovec_t # can be relative 
  
  h2o_errordoc_t* {.pure, importc: "h2o_errordoc_t", 
      header: h2o_header_file.} = st_h2o_errordoc_t

  INNER_C_UNION_6455537614996837608* {.pure, final, header: h2o_header_file.} = object {.
      union.}
    absolute* {.importc: "absolute".}: cstring
    max_age* {.importc: "max_age".}: uint64_t

  st_h2o_expires_args_t* {.pure, final, importc: "struct st_h2o_expires_args_t", header: h2o_header_file.} = object
    mode* {.importc: "mode".}: cint
    data* {.importc: "data".}: INNER_C_UNION_6455537614996837608

  h2o_expires_args_t* {.pure, importc: "h2o_expires_args_t", 
      header: h2o_header_file.} = st_h2o_expires_args_t

  st_h2o_file_handler_t* {.pure, final, importc: "struct st_h2o_file_handler_t".} = object
    super* {.importc: "super".}: h2o_handler_t
    real_path* {.importc: "real_path".}: h2o_iovec_t # has "/" appended at last 
    mimemap* {.importc: "mimemap".}: pointer
    flags* {.importc: "flags".}: cint
    max_index_file_len* {.importc: "max_index_file_len".}: csize
    index_files* {.importc: "index_files".}: array[1, h2o_iovec_t]

  h2o_file_handler_t* {.pure, 
    importc: "h2o_file_handler_t", header: h2o_header_file.} = st_h2o_file_handler_t

  st_h2o_headers_command_t* {.pure, final, importc: "struct st_h2o_headers_command_t", header: h2o_header_file.} = object
    cmd* {.importc: "cmd".}: cint
    name* {.importc: "name".}: ptr h2o_iovec_t # maybe a token 
    value* {.importc: "value".}: h2o_iovec_t
  
  h2o_headers_command_t* {.pure, 
    importc: "h2o_headers_command_t", header: h2o_header_file.} = st_h2o_headers_command_t

# lib/proxy.c 

  INNER_C_STRUCT_13449554867044911570* {.pure, final.} = object
    enabled* {.importc: "enabled".}: cint
    timeout* {.importc: "timeout".}: uint64_t

  st_h2o_proxy_config_vars_t* {.pure, final, importc: "struct st_h2o_proxy_config_vars_t", header: h2o_header_file.} = object
    io_timeout* {.importc: "io_timeout".}: uint64_t
    preserve_host* {.importc: "preserve_host".}: cint
    keepalive_timeout* {.importc: "keepalive_timeout".}: uint64_t # in milliseconds; set to zero to disable keepalive 
    websocket* {.importc: "websocket".}: INNER_C_STRUCT_13449554867044911570
  
  h2o_proxy_config_vars_t* {.pure, 
    importc: "h2o_proxy_config_vars_t", header: h2o_header_file.} = st_h2o_proxy_config_vars_t

# lib/redirect.c 

  st_h2o_redirect_handler_t* {.pure, final, importc: "struct st_h2o_redirect_handler_t".} = object
    super* {.importc: "super".}: h2o_handler_t
    internal* {.importc: "internal".}: cint
    status* {.importc: "status".}: cint
    prefix* {.importc: "prefix".}: h2o_iovec_t

  h2o_redirect_handler_t* {.pure, 
    importc: "h2o_redirect_handler_t", header: h2o_header_file.} = st_h2o_redirect_handler_t

#*
#  initializes the global configuration
# 

proc h2o_config_init*(config: ptr h2o_globalconf_t) {.cdecl,
    importc: "h2o_config_init", header: h2o_header_file.}
#*
#  registers a host context
# 

proc h2o_config_register_host*(config: ptr h2o_globalconf_t; host: h2o_iovec_t;
                              port: uint16_t): ptr h2o_hostconf_t {.cdecl,
    importc: "h2o_config_register_host", header: h2o_header_file.}
#*
#  registers a path context
# 

proc h2o_config_register_path*(hostconf: ptr h2o_hostconf_t; pathname: cstring): ptr h2o_pathconf_t {.
    cdecl, importc: "h2o_config_register_path", header: h2o_header_file.}
#*
#  disposes of the resources allocated for the global configuration
# 
#*
#  registers the reproxy filter
# 

proc h2o_reproxy_register*(pathconf: ptr h2o_pathconf_t) {.cdecl,
    importc: "h2o_reproxy_register", header: h2o_header_file.}
# context 
#*
#  initializes the context
# 

proc h2o_context_init*(context: ptr h2o_context_t; loop: pointer;
                      config: ptr h2o_globalconf_t) {.cdecl,
    importc: "h2o_context_init", header: h2o_header_file.}
#*
#  disposes of the resources allocated for the context
# 

proc h2o_context_dispose*(context: ptr h2o_context_t) {.cdecl,
    importc: "h2o_context_dispose", header: h2o_header_file.}
#*
#  requests shutdown to the connections governed by the context
# 

proc h2o_context_request_shutdown*(context: ptr h2o_context_t) {.cdecl,
    importc: "h2o_context_request_shutdown", header: h2o_header_file.}
#*
# 
# 

proc h2o_context_init_pathconf_context*(ctx: ptr h2o_context_t;
                                       pathconf: ptr h2o_pathconf_t) {.cdecl,
    importc: "h2o_context_init_pathconf_context", header: h2o_header_file.}
#*
# 
# 

proc h2o_context_dispose_pathconf_context*(ctx: ptr h2o_context_t;
    pathconf: ptr h2o_pathconf_t) {.cdecl, importc: "h2o_context_dispose_pathconf_context",
                                 header: h2o_header_file.}
#*
#  sends given file as the response to the client
# 

proc h2o_file_send*(req: ptr h2o_req_t; status: cint; reason: cstring; path: cstring;
                   mime_type: h2o_iovec_t; flags: cint): cint {.cdecl,
    importc: "h2o_file_send", header: h2o_header_file.}
#*
#  registers the file handler to the context
#  @param pathconf
#  @param virtual_path
#  @param real_path
#  @param index_files optional NULL-terminated list of of filenames to be considered as the "directory-index"
#  @param mimemap the mimemap (h2o_mimemap_create is called internally if the argument is NULL)
# 

proc h2o_file_register*(pathconf: ptr h2o_pathconf_t; real_path: cstring;
                       index_files: cstringArray; mimemap: ptr h2o_mimemap_t;
                       flags: cint): ptr h2o_file_handler_t {.cdecl,
    importc: "h2o_file_register", header: h2o_header_file.}
#*
#  returns the associated mimemap
# 

proc h2o_file_get_mimemap*(handler: ptr h2o_file_handler_t): ptr h2o_mimemap_t {.
    cdecl, importc: "h2o_file_get_mimemap", header: h2o_header_file.}
#*
#  registers the configurator
# 

proc h2o_file_register_configurator*(conf: ptr h2o_globalconf_t) {.cdecl,
    importc: "h2o_file_register_configurator", header: h2o_header_file.}
#*
#  disposes of the resources allocated for the global configuration
# 

proc h2o_config_dispose*(config: ptr h2o_globalconf_t) {.cdecl,
    importc: "h2o_config_dispose", header: h2o_header_file.}
#*
#  creates a handler associated to a given pathconf
# 

proc h2o_create_handler*(conf: ptr h2o_pathconf_t; sz: csize): ptr h2o_handler_t {.
    cdecl, importc: "h2o_create_handler", header: h2o_header_file.}
#*
#  creates a filter associated to a given pathconf
# 
#*
#  adds a header to list
# 

proc h2o_add_header*(pool: ptr h2o_mem_pool_t; headers: ptr h2o_headers_t;
                    token: ptr h2o_token_t; value: cstring; value_len: csize) {.cdecl,
    importc: "h2o_add_header", header: h2o_header_file.}
#*
#  called by handlers to set the generator
#  @param req the request
#  @param generator the generator
# 

proc h2o_start_response*(req: ptr h2o_req_t; generator: ptr h2o_generator_t) {.cdecl,
    importc: "h2o_start_response", header: h2o_header_file.}
#*
#  called by the generators to send output
#  note: generators should free itself after sending the final chunk (i.e. calling the function with is_final set to true)
#  @param req the request
#  @param bufs an array of buffers
#  @param bufcnt length of the buffers array
#  @param is_final if the output is final
# 

proc h2o_send*(req: ptr h2o_req_t; bufs: ptr h2o_iovec_t; bufcnt: csize; is_final: cint) {.
    cdecl, importc: "h2o_send", header: h2o_header_file.}
# built-in generators 

const 
#*
#      enforces the http1 protocol handler to close the connection after sending the response
#     
  H2O_SEND_ERROR_HTTP1_CLOSE_CONNECTION* = 0x00000001 
#*
#      if set, does not flush the registered response headers
#     
  H2O_SEND_ERROR_KEEP_HEADERS* = 0x00000002

#*
#  sends the given string as the response
# 

proc h2o_send_inline*(req: ptr h2o_req_t; body: cstring; len: csize) {.cdecl,
    importc: "h2o_send_inline", header: h2o_header_file.}
#*
#  sends the given information as an error response to the client
# 

proc h2o_send_error*(req: ptr h2o_req_t; status: cint; reason: cstring; body: cstring;
                    flags: cint) {.cdecl, importc: "h2o_send_error", header: h2o_header_file.}
#*
#  sends error response using zero timeout; can be called by output filters while processing the headers
# 

proc h2o_send_error_deferred*(req: ptr h2o_req_t; status: cint; reason: cstring;
                             body: cstring; flags: cint) {.cdecl,
    importc: "h2o_send_error_deferred", header: h2o_header_file.}
#*
#  sends a redirect response
# 

proc h2o_send_redirect*(req: ptr h2o_req_t; status: cint; reason: cstring; url: cstring;
                       url_len: csize) {.cdecl, importc: "h2o_send_redirect",
                                       header: h2o_header_file.}
#*
#  handles redirect internally
# 

proc h2o_send_redirect_internal*(req: ptr h2o_req_t; `method`: h2o_iovec_t;
                                url_str: cstring; url_len: csize;
                                preserve_overrides: cint) {.cdecl,
    importc: "h2o_send_redirect_internal", header: h2o_header_file.}

##
#  accepts a connection
##
proc h2o_accept*(ctx: ptr h2o_accept_ctx_t, sock: ptr h2o_socket_t) {.cdecl,
    importc: "h2o_accept", header: h2o_header_file.}

# proc on_accept*(listener: PStream; status: cint) {.cdecl,
#     importc: "on_accept", header: default_header_file.}
proc create_listener*(): cint {.cdecl, importc: "create_listener", 
    header: default_header_file.}


proc c_malloc*(size: int): pointer {.importc: "malloc", header: "<stdlib.h>".}
proc c_free*(p: pointer) {.importc: "free", header: "<stdlib.h>".}

proc h2o_mem_alloc*(sz: int): pointer {.inline, cdecl.} =
  var p: pointer = c_malloc(sz)
  if p == nil: raise newException(OutOfMemError, "no memory")
  return p

when defined(libuv):
  proc h2o_uv_socket_create*(stream: pointer, close_cb: proc (handle: pointer) {.cdecl.}): ptr h2o_socket_t {.
      importc: "h2o_uv_socket_create", header: uvbinding_header_file.}


