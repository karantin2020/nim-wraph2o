#ifndef SERVER_MAIN_H
#define SERVER_MAIN_H

#include "h2o.h"

void h2o_server_setup(int argc, char **argv);
h2o_hostconf_t *h2o_get_host(const char *hostport);
void h2o_server_start();
// int h2o_server_prestart();
H2O_NORETURN void *run_loop(void *_thread_index);

#endif SERVER_MAIN_H