#ifndef H2O_MISCS_H
#define H2O_MISCS_H

#include "h2o.h"
#include "router.h"

void print_hosts(h2o_globalconf_t *confgs);
h2o_hostconf_t * get_hostconf(h2o_globalconf_t *confgs, char *hostport);
h2o_pathconf_t *register_handler(h2o_hostconf_t *hostconf, 
        const char *path, 
        int method,
        int (*on_req)(h2o_handler_t *, h2o_req_t *));

void res_send(h2o_req_t *req, const char* _body);
void print_paths(h2o_hostconf_t *hostconf);
void configure_router(h2o_globalconf_t *global_ptr);
int file_send(h2o_req_t *req, int status, const char *reason, const char *path, const char *mime_type, int flags);

#endif