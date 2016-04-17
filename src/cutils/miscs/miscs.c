#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#if WITH_ROUTER
#include "router.h"
#include "miscs.h"

#define H2O_STRLEN(s) (s), strlen(s)

void print_hosts(h2o_globalconf_t *confgs) 
{
    h2o_hostconf_t **ptr = confgs->hosts;
    for ( ; *ptr != NULL; ptr++ )
    {
        fprintf(stderr, "First host is: %s\n",(*ptr)->authority.hostport.base);
    }
}

h2o_hostconf_t * get_hostconf(h2o_globalconf_t *confgs, char *hostport)
{
    h2o_hostconf_t **ptr = confgs->hosts;
    h2o_hostconf_t * found_host = NULL;
    for ( ; *ptr != NULL; ptr++ )
    {
        if (strncmp((*ptr)->authority.hostport.base, hostport,
            (*ptr)->authority.hostport.len) == 0) {
            found_host = *ptr;
            // fprintf(stderr, "Found host: %s\n",found_host->authority.hostport.base);
            break;
        }
    }
    return found_host;
}

h2o_pathconf_t *register_handler(h2o_hostconf_t *hostconf, 
        const char *path, 
        int method,
        int (*on_req)(h2o_handler_t *, h2o_req_t *))
{
    assert(hostconf && path);
    h2o_pathconf_t *pathconf = h2o_config_register_path(hostconf, path, 0);
    h2o_handler_t *handler = h2o_create_handler(pathconf, sizeof(*handler));
    handler->on_req = on_req;
#if WITH_ROUTER
    r3_tree_insert_routel(hostconf->router_tree, 
        method, path, strlen(path), handler );
#endif
    return pathconf;
}

void res_send(h2o_req_t *req, const char* _body)
{
    static h2o_generator_t generator = {NULL, NULL};
    h2o_iovec_t body = h2o_strdup(&req->pool, _body, SIZE_MAX);
    h2o_start_response(req, &generator);
    h2o_send(req, &body, 1, 1);
}

void print_paths(h2o_hostconf_t *hostconf)
{
    h2o_pathconf_t *paths;
    paths = hostconf->paths.entries;
    int i = 0;
    for (;i<hostconf->paths.size;i++) {
        fprintf(stderr, "Hostconf path: %s\n", paths[i].path.base);
    }
}

void configure_router(h2o_globalconf_t *global_ptr)
{
	fprintf(stderr, "Configure globalconf router\n");
    global_ptr->router_capacity = 10;
    global_ptr->cb_create_router = r3_tree_create;
    h2o_hostconf_t **ptr = global_ptr->hosts;
    for ( ; *ptr; ptr++ )
    {
        (*ptr)->cb_free_router = r3_tree_free;
        (*ptr)->cb_tree_match_route =  tree_match_route;
    }
}

int file_send(h2o_req_t *req, int status, const char *reason, const char *path, const char *mime_type, int flags)
{
    return h2o_file_send(req, status, reason, path, h2o_iovec_init(H2O_STRLEN(mime_type)), 0);
}

const char *query(h2o_req_t *req)
{
    if (req->query_at == SIZE_MAX) {
        return "";
    }
    else {
        return req->path.base + req->query_at;
    }
}

wraph2o_req_t* init_request(h2o_req_t *h2o_req)
{
    wraph2o_req_t* req = h2o_mem_alloc_pool(&h2o_req->pool, sizeof(*req));
    memset(req,0,sizeof(*req));
    if (h2o_req->hostconf->authority.host.len) {
        req->hostname = h2o_strdup(&h2o_req->pool, 
            h2o_req->hostconf->authority.host.base, h2o_req->hostconf->authority.host.len).base;
    }
    req->method = h2o_strdup(&h2o_req->pool, h2o_req->method.base,
        h2o_req->method.len).base;
    req->url = h2o_strdup(&h2o_req->pool, h2o_req->path.base,
        h2o_req->path.len).base;
    if (h2o_req->query_at == SIZE_MAX) {
        req->query = h2o_strdup(&h2o_req->pool, "", 1).base;
    } else {
        req->query = h2o_strdup(&h2o_req->pool, h2o_req->path.base + h2o_req->query_at,
            h2o_req->path.len - h2o_req->query_at).base;
    }
    req->path = h2o_strdup(&h2o_req->pool, h2o_req->path_normalized.base,
        h2o_req->path_normalized.len).base;
    if (h2o_req->entity.base) {
        req->payload = h2o_strdup(&h2o_req->pool, h2o_req->entity.base,
            h2o_req->entity.len).base;
    } else {
        req->payload = h2o_strdup(&h2o_req->pool, "", 1).base;
    }
    if (h2o_req->authority.len) {
        req->authority = h2o_strdup(&h2o_req->pool, h2o_req->authority.base,
            h2o_req->authority.len).base;
    } else {
        req->authority = h2o_strdup(&h2o_req->pool, "", 1).base;
    }
    req->base_req = h2o_req;
    return req;
}

#endif