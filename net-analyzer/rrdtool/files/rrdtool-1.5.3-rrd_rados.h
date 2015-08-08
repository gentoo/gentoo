#ifndef RRD_RADOS_H
#define RRD_RADOS_H

#include <rados/librados.h>

#include "rrd_tool.h"

typedef struct rrd_rados_t {
    rados_t cluster;
    rados_ioctx_t ioctx;
    const char *oid;
    rados_write_op_t write_op;
    int lock;
} rrd_rados_t;

rrd_rados_t* rrd_rados_open(const char *oid);
int rrd_rados_close(rrd_rados_t *rrd_rados);
int rrd_rados_create(const char *oid, rrd_t *rrd);
size_t rrd_rados_read(rrd_rados_t *rrd_rados, void *data, size_t len, uint64_t offset);
size_t rrd_rados_write(rrd_rados_t *rrd_rados, const void *data, size_t len, uint64_t offset);
int rrd_rados_flush(rrd_rados_t *rrd_rados);
int rrd_rados_lock(rrd_rados_t *rrd_rados);

#endif
