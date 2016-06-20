# Package

version       = "0.1.0"
author        = "karantin2020"
description   = "wrapper of h2o library"
license       = "MIT"

# Build

#bin = @["nimble"]
#srcDir = "src"

# Dependencies

requires "nim >= 0.12.0"

# Tasks

task buildr3, "Build r3 library":
  let curPath = thisDir()
  if dirExists("./deps/r3"):
    withDir "./deps/r3":
      exec "git pull https://github.com/karantin2020/r3.git"
  else:
    withDir "./deps":
      exec "git clone https://github.com/karantin2020/r3.git"
  withDir "./deps/r3":
    exec "./autogen.sh"
    exec "./configure && make"
  if fileExists("./build/libr3.a"):
    rmFile("./build/libr3.a")
  exec "ln -s " & curPath & 
    "/deps/r3/.libs/libr3.a ./build/libr3.a"

task buildh2o, "Build h2o library and make links":
  let curPath = thisDir()
  if dirExists("./deps/h2o"):
    echo "\nPull h2o repo..."
    withDir "./deps/h2o":
      exec "git pull https://github.com/karantin2020/h2o.git"
  else:
    echo "\nGet h2o repo..."
    withDir "./deps":
      exec "git clone https://github.com/karantin2020/h2o.git"
  echo "\nBuilding h2o lib..."
  withDir "./deps/h2o":
    exec "cmake -DWITH_ROUTER_LIB=ON . && make libh2o-evloop"
  echo "\nMaking links to `h2o`, `libh2o`, `examples`"
  # if fileExists("./build/h2o"):
  #   rmFile("./build/h2o")
  # if fileExists("./build/libh2o.a"):
  #   rmFile("./build/libh2o.a")
  if fileExists("./build/libh2o-evloop.a"):
    rmFile("./build/libh2o-evloop.a")
  # if dirExists("./build/examples"):
  #   rmFile("./build/examples")
  # exec "ln -s " & curPath & "/deps/h2o/h2o ./build/h2o"
  # exec "ln -s " & curPath & "/deps/h2o/libh2o.a ./build/libh2o.a"
  exec "ln -s " & curPath & "/deps/h2o/libh2o-evloop.a ./build/libh2o-evloop.a"
  # exec "ln -s " & curPath & "/deps/h2o/examples ./build/examples"
  # exec "./build/h2o -v"
  echo "\nEverything is done!\n"

task rebuildh2o, "Rebuild h2o library and make links":
  let curPath = thisDir()
  if dirExists("./deps/h2o"):
    rmDir "./deps/h2o"
    withDir "./deps":
      exec "git clone https://github.com/karantin2020/h2o.git"
  else:
    echo "\nGet h2o repo..."
    withDir "./deps":
      exec "git clone https://github.com/karantin2020/h2o.git"
  echo "\nRebuilding h2o lib..."
  withDir "./deps/h2o":
    exec "cmake . && make"
  echo "\nMaking links to `h2o`, `libh2o`, `examples`"
  # if fileExists("./build/h2o"):
  #   rmFile("./build/h2o")
  # if fileExists("./build/libh2o.a"):
  #   rmFile("./build/libh2o.a")
  if fileExists("./build/libh2o-evloop.a"):
    rmFile("./build/libh2o-evloop.a")
  # if dirExists("./build/examples"):
  #   rmFile("./build/examples")
  # exec "ln -s " & curPath & "/deps/h2o/h2o ./build/h2o"
  # exec "ln -s " & curPath & "/deps/h2o/libh2o.a ./build/libh2o.a"
  exec "ln -s " & curPath & "/deps/h2o/libh2o-evloop.a ./build/libh2o-evloop.a"
  # exec "ln -s " & curPath & "/deps/h2o/examples ./build/examples"
  exec "./build/h2o -v"
  echo "\nEverything is done!\n"

task compileh2o, "Compile h2o library":
  echo "\nBuilding h2o lib..."
  withDir "./deps/h2o":
    # exec "make clean"
    exec "cmake -DWITH_ROUTER_LIB=ON . && make libh2o-evloop"
  echo "\nEverything is done!\n"

task tests, "Run tests":
  echo "Test compilation evloopServer"
  withDir "tests/evloopServer":
    exec "nim c --noMain --verbosity:1 evloopServer.nim"
    # exec "./evloopServer -c examples/h2o/h2o.conf"

task testserver, "Build testserver":
  echo "Building test server"
  withDir "tests":
    exec "nim c -d:libressl test_server.nim"

