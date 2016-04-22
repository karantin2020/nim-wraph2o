#if WITH_ROUTER

#include "router.h"
#include "str_array.h"

int parse_method(const char *st, int len) {
    switch(len) {
        case 3:
            if (st[0]=='g' || st[0] == 'G')
                return RM_GET;
            else return RM_PUT;
            break;
        case 4:
            if (st[0]=='p' || st[0] == 'P')
                return RM_POST;
            else return RM_HEAD;
            break;
        case 5:
            return RM_PATCH;
            break;
        case 6:
            return RM_DELETE;
            break;
        case 7:
            return RM_OPTIONS;
            break;
    }
}

h2o_handler_t* tree_match_route(void* router_tree, h2o_req_t * req) {

    match_entry * entry = match_entry_createl(req->path_normalized.base,
        req->path_normalized.len);
    h2o_handler_t* handler = NULL;
    
    if (entry) {
        entry->request_method = parse_method(req->method.base, 
            req->method.len);
        R3Route *matched_route = r3_tree_match_route(router_tree, entry);
        if (matched_route) {
            handler = matched_route->data;
            unsigned int t_size = entry->vars.tokens.size;

            // h2o_iovec_t *slugs = entry->vars.slugs.entries;
            // h2o_iovec_t *tokens = entry->vars.tokens.entries;
            
            // for (int i = 0; i < t_size; i++) {
            //     // slugs + i;
            //     // tokens + i;
            //     printf("Slug name is: %*.*s\n",(slugs)->len,
            //         (slugs)->len,(slugs)->base);
            //     printf("Slug value is: %*.*s\n",(tokens)->len,
            //         (tokens)->len,(tokens)->base);
            //     slugs++;
            //     tokens++;
            // }
        }
    }
    match_entry_free(entry);
    return handler;
}

void compile_routes(R3Node *router_tree) {
    char *errstr = NULL;
    int err = r3_tree_compile(router_tree, &errstr);
    if (err != 0) {
        // fail
        printf("Compile router_tree error: %s\n", errstr);
        free(errstr); // errstr is created from `asprintf`, so you have to free it manually.
    }
}

#endif