import tables

proc getStatus*(num:cint): cstring = 
  let ndiv:int = num div 100
  if ndiv == 1: 
    if num == 100:
      return "Continue"
    elif num == 101: 
      return "Switching Protocols"
    else: 
      discard
  if ndiv == 2: 
    if num == 200:
      return "OK"
    elif num == 201: 
      return "Created"
    else: 
      discard
  if ndiv == 3: 
    if num == 300:
      return "Multiple Choices"
    elif num == 301: 
      return "Moved Permanently"
    elif num == 302: 
      return "Found"
    elif num == 303: 
      return "See Other"
    elif num == 304: 
      return "Not Modified"
    elif num == 305: 
      return "Use Proxy"
    elif num == 307: 
      return "Temporary Redirect"
    else: 
      discard
  if ndiv == 4: 
    let ndivin: int = num div 10
    if ndivin == 40:
      if num == 400:
        return "Bad Request"
      elif num == 401: 
        return "Unauthorized"
      elif num == 402: 
        return "Payment Required"
      elif num == 403: 
        return "Forbidden"
      elif num == 404: 
        return "Not Found"
      elif num == 405: 
        return "Method Not Allowed"
      elif num == 406: 
        return "Not Acceptable"
      elif num == 407: 
        return "Proxy Authentication Required"
      elif num == 408: 
        return "Request Time-out"
      elif num == 409: 
        return "Conflict"
      else:
        discard
    elif ndivin == 41:
      if num == 410: 
        return "Gone"
      elif num == 411: 
        return "Length Required"
      elif num == 412: 
        return "Precondition Failed"
      elif num == 413: 
        return "Request Entity Too Large"
      elif num == 414: 
        return "Request-URI Too Large"
      elif num == 415: 
        return "Unsupported Media Type"
      elif num == 416: 
        return "Requested range not satisfiable"
      elif num == 417: 
        return "Expectation Failed"
      elif num == 418: 
        return "I\'m a teapot"
      else:
        discard
    elif ndivin == 42:
      if num == 422: 
        return "Unprocessable Entity"
      elif num == 423: 
        return "Locked"
      elif num == 424: 
        return "Failed Dependency"
      elif num == 425: 
        return "Unordered Collection"
      elif num == 426: 
        return "Upgrade Required"
      else:
        discard
    elif ndivin == 44:
      if num == 444: 
        return "No Response"
      elif num == 449: 
        return "Retry With"
      else:
        discard
    elif ndivin == 45:
      if num == 450: 
        return "Blocked by Windows Parental Controls"
      else:
        discard
    elif ndivin == 49:
      if num == 499: 
        return "Client Closed Request"
      else:
        discard
    else: 
      discard
  if ndiv == 5: 
    if num == 200:
      return "OK"
    elif num == 201: 
      return "Created"
    else: 
      discard
  else: 
    discard

