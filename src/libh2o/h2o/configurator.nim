import os, memory
const 
  configurator_header_file = splitPath(currentSourcePath()).head & 
    "/../../../deps/h2o/include/h2o/configurator.h"

type
  h2o_configurator_context_t* {.pure, final, importc: "h2o_configurator_context_t",
                               header: configurator_header_file.} = object
    globalconf* {.importc: "globalconf".}: ptr h2o_globalconf_t
    hostconf* {.importc: "hostconf".}: ptr h2o_hostconf_t
    pathconf* {.importc: "pathconf".}: ptr h2o_pathconf_t
    mimemap* {.importc: "mimemap".}: ptr ptr h2o_mimemap_t
    dry_run* {.importc: "dry_run".}: cint
    parent* {.importc: "parent".}: ptr st_h2o_configurator_context_t

  h2o_configurator_dispose_cb* = proc (configurator: ptr h2o_configurator_t): cint {.
      cdecl.}
  h2o_configurator_enter_cb* = proc (configurator: ptr h2o_configurator_t;
                                  ctx: ptr h2o_configurator_context_t;
                                  node: ptr yoml_t): cint {.cdecl.}
  h2o_configurator_exit_cb* = proc (configurator: ptr h2o_configurator_t;
                                 ctx: ptr h2o_configurator_context_t;
                                 node: ptr yoml_t): cint {.cdecl.}
  h2o_configurator_command_cb* = proc (cmd: ptr h2o_configurator_command_t;
                                    ctx: ptr h2o_configurator_context_t;
                                    node: ptr yoml_t): cint {.cdecl.}
  st_h2o_configurator_command_t* {.pure, final, importc: "st_h2o_configurator_command_t",
                                  header: configurator_header_file.} = object
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

type
  st_h2o_configurator_t* {.pure, final, importc: "st_h2o_configurator_t",
                          header: configurator_header_file.} = object
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
  
