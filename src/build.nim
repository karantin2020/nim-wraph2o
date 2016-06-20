import os
const 
  dirCurrentPath = splitPath(currentSourcePath()).head
  dirMainPath = dirCurrentPath & "/"
  dirDepsPath = dirCurrentPath & "/../deps/"
  dirSourcePath = dirCurrentPath & "/"
  dirBuildPath = dirCurrentPath & "/../build/"

when defined(libuv):
    {.passC: "-DH2O_USE_LIBUV=1 -DWITH_ROUTER=1 -DH2O_USE_BROTLI=1".}
else:
    {.passC: "-DH2O_USE_LIBUV=0 -DWITH_ROUTER=1 -DH2O_USE_BROTLI=1".}

# Includes section
{.passC: "-I/usr/local/include".}
{.passC: "-I/usr/include".}
{.passC: "-I" & dirSourcePath & "cutils/router".}
{.passC: "-I" & dirSourcePath & "cutils/miscs".}

{.passC: "-I" & dirDepsPath & "h2o/include".}
{.passC: "-I" & dirDepsPath & "h2o/src".}
{.passC: "-I" & dirDepsPath & "h2o/deps/cloexec".}
{.passC: "-I" & dirDepsPath & "h2o/deps/brotli/enc".}
{.passC: "-I" & dirDepsPath & "h2o/deps/golombset".}
{.passC: "-I" & dirDepsPath & "h2o/deps/libyrmcds".}
{.passC: "-I" & dirDepsPath & "h2o/deps/klib".}
{.passC: "-I" & dirDepsPath & "h2o/deps/neverbleed".}
{.passC: "-I" & dirDepsPath & "h2o/deps/picohttpparser".}
{.passC: "-I" & dirDepsPath & "h2o/deps/picotest".}
{.passC: "-I" & dirDepsPath & "h2o/deps/yaml/include".}
{.passC: "-I" & dirDepsPath & "h2o/deps/yoml".}

{.passC: "-I" & dirDepsPath & "r3/include".}
# {.passC: "-I" & dirDepsPath & "pcre".}

# Wraph2o lib sources
{.compile: dirSourcePath & "cutils/router/router.c".}
{.compile: dirSourcePath & "cutils/miscs/miscs.c".}

#  h2o src/ sources
{.compile: dirMainPath & "cutils/server_main.c".}
{.compile: dirDepsPath & "h2o/src/ssl.c".}
{.compile: dirDepsPath & "h2o/deps/neverbleed/neverbleed.c".}

# h2o deps/yaml sources
{.compile: dirDepsPath & "h2o/deps/yaml/src/api.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/dumper.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/emitter.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/loader.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/parser.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/reader.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/scanner.c".}
{.compile: dirDepsPath & "h2o/deps/yaml/src/writer.c".}

# h2o brotli source files
{.compile: dirDepsPath & "h2o/deps/brotli/enc/backward_references.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/block_splitter.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/brotli_bit_stream.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/compress_fragment.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/compress_fragment_two_pass.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/dictionary.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/encode.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/entropy_encode.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/histogram.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/literal_cost.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/metablock.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/static_dict.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/streams.cc".}
{.compile: dirDepsPath & "h2o/deps/brotli/enc/utf8_util.cc".}
{.compile: dirDepsPath & "h2o/lib/handler/compress/brotli.cc".}

when defined(libuv):
    {.passL: dirBuildPath & "libh2o.a"}
    {.passL: "-luv".}
else:
    {.passL: dirBuildPath & "libh2o-evloop.a"}

{.passL: dirBuildPath & "libr3.a".}
# {.passL: dirBuildPath & "libpcre.a".}
# {.passL: "-ljson-c".}
{.passL: "-lpcre".}

when defined(libressl):
    {.passL: "-lssl".}
    {.passL: "-lcrypto".}
else:
    {.passL: "-L/lib/x86_64-linux-gnu".}
    {.passL: "-l:libssl.so.1.0.0".}
    {.passL: "-l:libcrypto.so.1.0.0".}
{.passL: "-lz".}
{.passL: "-lstdc++".}
{.passL: "-lm".}