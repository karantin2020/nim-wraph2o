#ifndef H2O_MISCS_H
#define H2O_MISCS_H

#include "h2o.h"
#include "h2o/memory.h"
// #include "h2o/string_.h"
#include "router.h"

typedef struct st_params_t {
	const char *name;
	const char *value;
} params_t;

typedef H2O_VECTOR(params_t) vec_params_t;

typedef struct st_wraph2o_req_t {
    /**
     * host name (w/o port number)
     */
    const char *hostname;
    /**
     * authority (of the processing request)
     */
    const char *authority;
    /**
     * method (of the processing request)
     */
    const char *method;
    /**
     * abs-path of the processing request
     */
    const char *url;
    /**
     * offset of '?' within path, or SIZE_MAX if not found
     */
    const char *query;
    /*
     * normalized path of the processing request (i.e. no "." or "..", no query)
     */
    const char *path;
    /**
     * list of request headers
     */
    h2o_headers_t *headers;
    /**
     * the request entity (or request body, equal to NULL if none)
     */
    const char *payload;
    /**
     * router params
     */
    vec_params_t params;
    /**
     * authentication params
     */
    struct {
        bool isAuthenticated;
        const char *credentials;         // Special keys: 'app', 'user', 'scope'
        const char *artifacts;           // Scheme-specific artifacts
        void *strategy;
        void *mode;
        void *error;
    } auth;
    /**
     * original request
     */
    h2o_req_t *base_req;
} wraph2o_req_t;

void print_hosts(h2o_globalconf_t *confgs);
h2o_hostconf_t * get_hostconf(h2o_globalconf_t *confgs, char *hostport);
h2o_pathconf_t *register_handler(h2o_hostconf_t *hostconf, 
        const char *path, 
        int method,
        int (*on_req)(h2o_handler_t *, h2o_req_t *));

wraph2o_req_t* init_request(h2o_req_t *req);
void parse_headers(h2o_req_t *h2o_req);
void res_send(h2o_req_t *req, const char* _body);
void print_paths(h2o_hostconf_t *hostconf);
void configure_router(h2o_globalconf_t *global_ptr);
int file_send(h2o_req_t *req, int status, const char *reason, const char *path, const char *mime_type, int flags);
const char *query(h2o_req_t *req);

#endif