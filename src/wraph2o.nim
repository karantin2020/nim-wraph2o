import os, tables, multitool

const 
  router_header_file = splitPath(currentSourcePath()).head & 
    "/cutils/router/router.h"
  miscs_header_file = splitPath(currentSourcePath()).head & 
    "/cutils/miscs/miscs.h"
  server_header_file = splitPath(currentSourcePath()).head & 
    "/cutils/server.h"

import 
  ./libh2o/libh2o,
  ./libh2o/h2o/strings, 
  ./libh2o/h2o/memory, 
  ./libh2o/h2o/token,
  ./statuscodes,
  ./build

##################
# Few common procs for cstring
# ################

# proc `[]`(s: cstring; x: Slice[int]): cstring {.inline, 
#     raises: [], tags: [].} =
#   discard



type
  on_req_cb* = proc (handler: ptr h2o_handler_t, 
    req: ptr h2o_req_t): cint {.cdecl.}
    ##  on_req callback type (used in register_handler)

  HTTP_METHODS* {.size: sizeof(cint).} = enum
    METHOD_GET = 2,
    METHOD_POST = 2 shl 1,
    METHOD_PUT = 2 shl 2,
    METHOD_DELETE = 2 shl 3,
    METHOD_PATCH = 2 shl 4,
    METHOD_HEAD = 2 shl 5,
    METHOD_OPTIONS = 2 shl 6

  params_t* {.pure, final, importc: "struct st_params_t", 
      header: miscs_header_file.} = object
    name {.importc: "name".}: cstring
    value {.importc: "value".}: cstring

  auth_t* {.pure, final.} = object
    isAuthenticated: cint
    credentials: cstring
    artifacts: cstring
    strategy: pointer
    mode: pointer
    error: pointer

  wraph2o_req_t* {.pure, final, importc: "struct st_wraph2o_req_t",
      header: miscs_header_file.} = object
    hostname {.importc: "hostname".}: cstring
    authority {.importc: "authority".}: cstring
    http_method {.importc: "method".}: cstring
    url {.importc: "url".}: cstring
    query {.importc: "query".}: cstring
    path {.importc: "path".}: cstring
    headers {.importc: "headers".}: ptr h2o_headers_t
    payload {.importc: "payload".}: cstring
    params: H2O_VECTOR[params_t]
    auth {.importc: "auth".}: auth_t
    base_req {.importc: "base_req".}: ptr h2o_req_t
 
proc register_handler*(hostconf: ptr h2o_hostconf_t, 
                      path: cstring, 
                      router_method: HTTP_METHODS,
                      on_req: on_req_cb
                     ) {.cdecl,
  importc: "register_handler", header: miscs_header_file.}
  ##  registers the route handler

template pool_strdup*(pool: ptr h2o_mem_pool_t, base: cstring): untyped =
  h2o_strdup(pool, base, SIZE_MAX)

template getStr*(a: h2o_iovec_t): untyped =
  ($(a.base))[0..(a.inner_len-1)]

proc send*(req: ptr h2o_req_t, 
           pbody: cstring) {.cdecl,
  importc: "res_send", header: miscs_header_file.}

proc header*(req: ptr h2o_req_t, 
             token: ptr h2o_token_t, pheader: cstring): ptr h2o_req_t =
  h2o_add_header(addr(req.pool), addr(req.res.headers), 
                 token, pheader, len pheader)
  return req

proc status*(req: ptr h2o_req_t, pstatus: cint): ptr h2o_req_t =
  req.res.status = pstatus
  req.res.reason = getStatus(pstatus)
  return req

proc statusOk*(req: ptr h2o_req_t): ptr h2o_req_t =
  req.res.status = 200
  req.res.reason = "OK"

proc h2o_server_setup*[N](argc: int, argv: array[N,cstring]) {.cdecl,
  importc: "h2o_server_setup", header: server_header_file.}

proc h2o_server_start*() {.cdecl,
  importc: "h2o_server_start", header: server_header_file.}

proc h2o_get_host*(hostport: cstring): ptr h2o_hostconf_t {.cdecl,
  importc: "h2o_get_host", header: server_header_file.}

proc h2o_get_hostport*(host: string, port: string = "8080"): ptr h2o_hostconf_t =
  return h2o_get_host(host & ":" & port)

proc newServer*() = 
  var args: seq[string] = commandLineParams()
  var ars: array[10,cstring]
  ars[0] = cstring(getAppFilename())
  args.map(proc (x:string,i:int) = 
      ars[i+1] = x)
  h2o_server_setup(len (args) + 1, ars)

proc file_send*(req: ptr h2o_req_t, status: cint, 
    reason: cstring, path: cstring, mime: cstring, flags: cint) {.cdecl,
  importc: "file_send", header: miscs_header_file.}

proc file_send*(req: ptr h2o_req_t, path: cstring) =
  file_send(req, 200, "OK", path, "text/html; charset=utf-8", 0)

proc body*(req: ptr h2o_req_t): cstring =
  var body = req.entity
  if (body.inner_len > 0):
    var ent = body.base
    return ent
  else:
    return ""

proc query*(req: ptr h2o_req_t):cstring {.cdecl,
  importc: "query", header: miscs_header_file.}

proc init_request*(req: ptr h2o_req_t): ptr wraph2o_req_t {.cdecl,
  importc: "init_request", header: miscs_header_file.}

template `@`*(name: untyped, body: untyped): untyped {.immediate, dirty.} =
  ## Handler create decorator
  proc name*(self: ptr h2o_handler_t, base_req: ptr h2o_req_t): cint {.cdecl.} =
    # echo "start handler"
    # system.setupForeignThreadGc()
    var req: ptr wraph2o_req_t = init_request(base_req)
    # echo "start body"
    body

proc send*(req: ptr wraph2o_req_t, 
           pbody: cstring) = 
  req.base_req.send(pbody)

proc header*(req: ptr wraph2o_req_t, 
             token: ptr h2o_token_t, pheader: cstring): ptr wraph2o_req_t =
  discard req.base_req.header(token, pheader)
  return req

proc status*(req: ptr wraph2o_req_t, pstatus: cint): ptr wraph2o_req_t =
  discard req.base_req.status(pstatus)
  return req

proc form*(req: ptr wraph2o_req_t): ptr wraph2o_req_t =
  discard req.base_req.header(CONTENT_TYPE, "application/json")
  return req

proc statusOk*(req: ptr wraph2o_req_t): ptr wraph2o_req_t =
  discard req.base_req.statusOk()
  return req

