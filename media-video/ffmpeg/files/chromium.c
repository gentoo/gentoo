#include "libavformat/avformat.h"
#include "libavformat/internal.h"

int64_t av_stream_get_first_dts(const AVStream *st);
int64_t av_stream_get_first_dts(const AVStream *st)
{
    return cffstream(st)->first_dts;
}
