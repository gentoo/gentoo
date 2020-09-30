#!/bin/sh

#
# Run Mozilla Thunderbird on X11
#
export MOZ_DISABLE_WAYLAND=1
exec @PREFIX@/bin/thunderbird "$@"
