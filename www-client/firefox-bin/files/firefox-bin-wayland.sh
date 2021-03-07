#!/bin/sh

#
# Run Mozilla Firefox (bin) on Wayland
#
export MOZ_ENABLE_WAYLAND=1
exec @PREFIX@/bin/firefox-bin "$@"
