import os
const token_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/token.h"

import ../libh2o

# const H2O_MAX_TOKENS* = 100

# var h2o_tokens* {.importc: "h2o__tokens", header: token_header_file.}:  array[H2O_MAX_TOKENS,h2o_token_t]

# proc H2O_TOKEN_CONTENT_TYPE* (): ptr h2o_token_t =
#   addr h2o_tokens[22]

var
  AUTHORITY* {.importc: "H2O_TOKEN_AUTHORITY", 
    header: token_header_file.}: ptr h2o_token_t
  METHOD* {.importc: "H2O_TOKEN_METHOD", 
    header: token_header_file.}: ptr h2o_token_t
  PATH* {.importc: "H2O_TOKEN_PATH", 
    header: token_header_file.}: ptr h2o_token_t
  SCHEME* {.importc: "H2O_TOKEN_SCHEME", 
    header: token_header_file.}: ptr h2o_token_t
  STATUS* {.importc: "H2O_TOKEN_STATUS", 
    header: token_header_file.}: ptr h2o_token_t
  ACCEPT* {.importc: "H2O_TOKEN_ACCEPT", 
    header: token_header_file.}: ptr h2o_token_t
  ACCEPT_CHARSET* {.importc: "H2O_TOKEN_ACCEPT_CHARSET", 
    header: token_header_file.}: ptr h2o_token_t
  ACCEPT_ENCODING* {.importc: "H2O_TOKEN_ACCEPT_ENCODING", 
    header: token_header_file.}: ptr h2o_token_t
  ACCEPT_LANGUAGE* {.importc: "H2O_TOKEN_ACCEPT_LANGUAGE", 
    header: token_header_file.}: ptr h2o_token_t
  ACCEPT_RANGES* {.importc: "H2O_TOKEN_ACCEPT_RANGES", 
    header: token_header_file.}: ptr h2o_token_t
  ACCESS_CONTROL_ALLOW_ORIGIN* {.importc: "H2O_TOKEN_ACCESS_CONTROL_ALLOW_ORIGIN", 
    header: token_header_file.}: ptr h2o_token_t
  AGE* {.importc: "H2O_TOKEN_AGE", 
    header: token_header_file.}: ptr h2o_token_t
  ALLOW* {.importc: "H2O_TOKEN_ALLOW", 
    header: token_header_file.}: ptr h2o_token_t
  AUTHORIZATION* {.importc: "H2O_TOKEN_AUTHORIZATION", 
    header: token_header_file.}: ptr h2o_token_t
  CACHE_CONTROL* {.importc: "H2O_TOKEN_CACHE_CONTROL", 
    header: token_header_file.}: ptr h2o_token_t
  CONNECTION* {.importc: "H2O_TOKEN_CONNECTION", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_DISPOSITION* {.importc: "H2O_TOKEN_CONTENT_DISPOSITION", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_ENCODING* {.importc: "H2O_TOKEN_CONTENT_ENCODING", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_LANGUAGE* {.importc: "H2O_TOKEN_CONTENT_LANGUAGE", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_LENGTH* {.importc: "H2O_TOKEN_CONTENT_LENGTH", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_LOCATION* {.importc: "H2O_TOKEN_CONTENT_LOCATION", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_RANGE* {.importc: "H2O_TOKEN_CONTENT_RANGE", 
    header: token_header_file.}: ptr h2o_token_t
  CONTENT_TYPE* {.importc: "H2O_TOKEN_CONTENT_TYPE", 
    header: token_header_file.}: ptr h2o_token_t
  COOKIE* {.importc: "H2O_TOKEN_COOKIE", 
    header: token_header_file.}: ptr h2o_token_t
  DATE* {.importc: "H2O_TOKEN_DATE", 
    header: token_header_file.}: ptr h2o_token_t
  ETAG* {.importc: "H2O_TOKEN_ETAG", 
    header: token_header_file.}: ptr h2o_token_t
  EXPECT* {.importc: "H2O_TOKEN_EXPECT", 
    header: token_header_file.}: ptr h2o_token_t
  EXPIRES* {.importc: "H2O_TOKEN_EXPIRES", 
    header: token_header_file.}: ptr h2o_token_t
  FROM* {.importc: "H2O_TOKEN_FROM", 
    header: token_header_file.}: ptr h2o_token_t
  HOST* {.importc: "H2O_TOKEN_HOST", 
    header: token_header_file.}: ptr h2o_token_t
  HTTP2_SETTINGS* {.importc: "H2O_TOKEN_HTTP2_SETTINGS", 
    header: token_header_file.}: ptr h2o_token_t
  IF_MATCH* {.importc: "H2O_TOKEN_IF_MATCH", 
    header: token_header_file.}: ptr h2o_token_t
  IF_MODIFIED_SINCE* {.importc: "H2O_TOKEN_IF_MODIFIED_SINCE", 
    header: token_header_file.}: ptr h2o_token_t
  IF_NONE_MATCH* {.importc: "H2O_TOKEN_IF_NONE_MATCH", 
    header: token_header_file.}: ptr h2o_token_t
  IF_RANGE* {.importc: "H2O_TOKEN_IF_RANGE", 
    header: token_header_file.}: ptr h2o_token_t
  IF_UNMODIFIED_SINCE* {.importc: "H2O_TOKEN_IF_UNMODIFIED_SINCE", 
    header: token_header_file.}: ptr h2o_token_t
  KEEP_ALIVE* {.importc: "H2O_TOKEN_KEEP_ALIVE", 
    header: token_header_file.}: ptr h2o_token_t
  LAST_MODIFIED* {.importc: "H2O_TOKEN_LAST_MODIFIED", 
    header: token_header_file.}: ptr h2o_token_t
  LINK* {.importc: "H2O_TOKEN_LINK", 
    header: token_header_file.}: ptr h2o_token_t
  LOCATION* {.importc: "H2O_TOKEN_LOCATION", 
    header: token_header_file.}: ptr h2o_token_t
  MAX_FORWARDS* {.importc: "H2O_TOKEN_MAX_FORWARDS", 
    header: token_header_file.}: ptr h2o_token_t
  PROXY_AUTHENTICATE* {.importc: "H2O_TOKEN_PROXY_AUTHENTICATE", 
    header: token_header_file.}: ptr h2o_token_t
  PROXY_AUTHORIZATION* {.importc: "H2O_TOKEN_PROXY_AUTHORIZATION", 
    header: token_header_file.}: ptr h2o_token_t
  RANGE* {.importc: "H2O_TOKEN_RANGE", 
    header: token_header_file.}: ptr h2o_token_t
  REFERER* {.importc: "H2O_TOKEN_REFERER", 
    header: token_header_file.}: ptr h2o_token_t
  REFRESH* {.importc: "H2O_TOKEN_REFRESH", 
    header: token_header_file.}: ptr h2o_token_t
  RETRY_AFTER* {.importc: "H2O_TOKEN_RETRY_AFTER", 
    header: token_header_file.}: ptr h2o_token_t
  SERVER* {.importc: "H2O_TOKEN_SERVER", 
    header: token_header_file.}: ptr h2o_token_t
  SET_COOKIE* {.importc: "H2O_TOKEN_SET_COOKIE", 
    header: token_header_file.}: ptr h2o_token_t
  STRICT_TRANSPORT_SECURITY* {.importc: "H2O_TOKEN_STRICT_TRANSPORT_SECURITY", 
    header: token_header_file.}: ptr h2o_token_t
  TE* {.importc: "H2O_TOKEN_TE", 
    header: token_header_file.}: ptr h2o_token_t
  TRANSFER_ENCODING* {.importc: "H2O_TOKEN_TRANSFER_ENCODING", 
    header: token_header_file.}: ptr h2o_token_t
  UPGRADE* {.importc: "H2O_TOKEN_UPGRADE", 
    header: token_header_file.}: ptr h2o_token_t
  USER_AGENT* {.importc: "H2O_TOKEN_USER_AGENT", 
    header: token_header_file.}: ptr h2o_token_t
  VARY* {.importc: "H2O_TOKEN_VARY", 
    header: token_header_file.}: ptr h2o_token_t
  VIA* {.importc: "H2O_TOKEN_VIA", 
    header: token_header_file.}: ptr h2o_token_t
  WWW_AUTHENTICATE* {.importc: "H2O_TOKEN_WWW_AUTHENTICATE", 
    header: token_header_file.}: ptr h2o_token_t
  X_FORWARDED_FOR* {.importc: "H2O_TOKEN_X_FORWARDED_FOR", 
    header: token_header_file.}: ptr h2o_token_t
  X_REPROXY_URL* {.importc: "H2O_TOKEN_X_REPROXY_URL", 
    header: token_header_file.}: ptr h2o_token_t