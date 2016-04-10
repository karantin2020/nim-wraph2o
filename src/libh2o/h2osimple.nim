import libh2o, libuv, ../libuv/wrapuv

when defined(windows):
  import winlean
elif defined(posix):
  import posix
else:
  {.error: "h2o module not ported to your operating system!".}


template testHttpMethod*(req, targetMethod: expr): expr =
  if (h2o_memis(req.inner_method.base, req.inner_method.inner_len, 
    cstring(targetMethod), len(targetMethod)) == 0):
    return -1

