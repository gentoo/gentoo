#!/bin/bash
# Wrapper script for conkeror

for cmd in firefox firefox-bin; do
    xr=$(type -p ${cmd})
    if [[ -n ${xr} ]]; then
	: ${MOZ_PLUGIN_PATH:=/usr/lib/nsbrowser/plugins} #497070
	export MOZ_PLUGIN_PATH
 	exec "${xr}" -app /usr/share/conkeror/application.ini "$@"
    fi
done

echo "$0: firefox required, but not found." >&2
exit 1
