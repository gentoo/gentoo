#!/bin/sh

#
# Run Mozilla Thunderbird under Wayland
#
export MOZ_ENABLE_WAYLAND=1
exec @PREFIX@/bin/thunderbird "$@"
