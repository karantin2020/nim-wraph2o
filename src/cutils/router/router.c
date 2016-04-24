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

// #include <signal.h>

h2o_handler_t* tree_match_route(void* router_tree, h2o_req_t * req) {

    // fwrite(req->path_normalized.base, req->path_normalized.len, 1, stdout);
    // fprintf(stderr, "Looking for path %*.*s with size %d\n", 
    //     req->path_normalized.len, req->path_normalized.len, 
    //     req->path_normalized.base, req->path_normalized.len);
    match_entry * entry;
    h2o_iovec_t *path_t = &req->path_normalized;
    if ('/' == path_t->base[path_t->len - 1]) {
        entry = match_entry_createl(path_t->base,
            path_t->len - 1);
    } else {
        entry = match_entry_createl(path_t->base,
            path_t->len);
    }
    h2o_handler_t* handler = NULL;
    
    if (entry) {
        entry->request_method = parse_method(req->method.base, 
            req->method.len);
        // fprintf(stderr, "Route method is %d\n", entry->request_method);
        R3Route *matched_route = r3_tree_match_route(router_tree, entry);
        // raise(SIGSEGV);
        if (matched_route) {
            handler = matched_route->data;
            
            // for (int i = 0; i < entry->vars.tokens.size; i++) {
            //     // entry->vars.slugs.entries[i];
            //     // entry->vars.tokens.entries[i];
            //     printf("Slug name is: %*.*s\n",entry->vars.slugs.entries[i].len,
            //         entry->vars.slugs.entries[i].len, entry->vars.slugs.entries[i].base);
            //     printf("Slug value is: %*.*s\n",entry->vars.tokens.entries[i].len,
            //         entry->vars.tokens.entries[i].len, entry->vars.tokens.entries[i].base);
            // }
        } else {
            // fprintf(stderr, "Didn't find match route\n");
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
    // r3_tree_dump(router_tree,0);
}

#endif