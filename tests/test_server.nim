import
  os,
  # htmlgen,
  multitool,
  cstd,
  ../src/wraph2o,
  ../src/libh2o/libh2o,
  ../src/libh2o/h2o/token

@hello_test:
  ## equal to proc (self: ptr h2o_handler_t, 
  ##   base_req: ptr h2o_req_t): cint {.cdecl.}
  ## req: ptr wraph2o_req_t
  # echo req.path
  req
    .header(CONTENT_TYPE, "text/plain")
    .status(200)
    .send(req.path)

@form_test:
  req
    .form()
    .header(Set_cookie, "data=json")
    .statusOk()
    .send( """
{"name":"ilya"}""" )

# proc hello_test(self: ptr h2o_handler_t, req: ptr h2o_req_t): cint {.cdecl.} =
#   req
#     .header(CONTENT_TYPE, "text/html")
#     .status(200)
#     .send(req.path.base)

proc file_test(self: ptr h2o_handler_t, req: ptr h2o_req_t): cint {.cdecl.} =
  req
    .file_send("./examples/doc_root/index.html")

proc post_test(self: ptr h2o_handler_t, req: ptr h2o_req_t): cint {.cdecl.} =
  req.status(200)
    .send(req.body())

newServer()

var host = h2o_get_hostport("127.0.0.1","8080")
host.register_handler("/hello", METHOD_GET, hello_test)
host.register_handler("/form", METHOD_GET, form_test)
host.register_handler("/file", METHOD_GET, file_test)
host.register_handler("/post", METHOD_POST, post_test)


h2o_server_start()