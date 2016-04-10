#ifndef H2O_ROUTER_H
#define H2O_ROUTER_H

#ifdef __cplusplus
extern "C" {
#endif

#include "r3.h"
#include "h2o.h"

#define RM_GET 2
#define RM_POST 2<<1
#define RM_PUT 2<<2
#define RM_DELETE 2<<3
#define RM_PATCH 2<<4
#define RM_HEAD 2<<5
#define RM_OPTIONS 2<<6

int parse_method(const char *st, int len);
h2o_handler_t* tree_match_route(void* router, h2o_req_t * req);
void compile_routes(R3Node *router_tree);

#ifdef __cplusplus
}
#endif

#endif
