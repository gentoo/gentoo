#!/bin/sh

#
# Run Mozilla Thunderbird (bin) on X11
#
export MOZ_DISABLE_WAYLAND=1
exec @PREFIX@/bin/thunderbird-bin "$@"
