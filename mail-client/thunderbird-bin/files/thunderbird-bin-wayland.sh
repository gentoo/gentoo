#!/bin/sh

#
# Run Mozilla Thunderbird (bin) under Wayland
#
export MOZ_ENABLE_WAYLAND=1
exec @PREFIX@/bin/thunderbird-bin "$@"
