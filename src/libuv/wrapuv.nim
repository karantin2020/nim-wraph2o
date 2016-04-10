import posix, libuv

type
  uv_run_mode* = enum 
    UV_RUN_DEFAULT = 0, UV_RUN_ONCE, UV_RUN_NOWAIT

proc uv_tcp_bind*(handle: libuv.PTcp; inner_addr: ptr SockAddr; flags: cuint): cint {.
  importc: "uv_tcp_bind", header: "uv.h".}

proc uv_ip4_addr*(ip: cstring; port: cint; inner_addr: ptr SockAddr_in): cint {.
  importc: "uv_ip4_addr", header: "uv.h".}

proc uv_tcp_init*(a2: libuv.PLoop; handle: libuv.PTcp): cint {.
  importc: "uv_tcp_init", header: "uv.h".}

proc uv_loop_init*(loop: libuv.PLoop): cint {.
  importc: "uv_loop_init", header: "uv.h".}

proc uv_run*(a2: libuv.PLoop; mode: uv_run_mode): cint {.
  importc: "uv_run", header: "uv.h".}

proc uv_stop*(loop: libuv.PLoop) {.
  importc: "uv_stop", header: "uv.h".}

proc uv_loop_close*(loop: libuv.PLoop): cint {.importc.}