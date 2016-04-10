import
  os,
  # htmlgen,
  multitool,
  ../src/wraph2o,
  ../src/libh2o/libh2o,
  ../src/libh2o/h2o/token

proc hello_test(self: ptr h2o_handler_t, req: ptr h2o_req_t): cint {.cdecl.} =
  req
    .header(CONTENT_TYPE, "text/html")
    .status(200)
    .send("Hello")

proc file_test(self: ptr h2o_handler_t, req: ptr h2o_req_t): cint {.cdecl.} =
  req
  # .header(CONTENT_TYPE, "text/html")
  # .status(200)
  # .send(html body h1 "Hello")
  .file_send("./examples/doc_root/index.html")

proc post_test(self: ptr h2o_handler_t, req: ptr h2o_req_t): cint {.cdecl.} =
  echo req.body()
  req.status(200)
  .send(req.body())

newServer()

var host = h2o_get_hostport("127.0.0.1","8080")
host.register_handler("/hello", METHOD_GET, hello_test)
host.register_handler("/file", METHOD_GET, file_test)
host.register_handler("/post", METHOD_POST, post_test)


h2o_server_start()