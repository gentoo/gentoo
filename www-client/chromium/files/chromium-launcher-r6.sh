#!/bin/bash

# Allow the user to override command-line flags, bug #357629.
# This is based on Debian's chromium-browser package, and is intended
# to be consistent with Debian.
for f in /etc/chromium/*; do
    [[ -f ${f} ]] && source "${f}"
done

# Prefer user defined CHROMIUM_USER_FLAGS (from env) over system
# default CHROMIUM_FLAGS (from /etc/chromium/default).
CHROMIUM_FLAGS=${CHROMIUM_USER_FLAGS:-"$CHROMIUM_FLAGS"}

# Let the wrapped binary know that it has been run through the wrapper
export CHROME_WRAPPER=$(readlink -f "$0")

PROGDIR=${CHROME_WRAPPER%/*}

case ":$PATH:" in
  *:$PROGDIR:*)
    # $PATH already contains $PROGDIR
    ;;
  *)
    # Append $PROGDIR to $PATH
    export PATH="$PATH:$PROGDIR"
    ;;
esac

if [[ ${EUID} == 0 && -O ${XDG_CONFIG_HOME:-${HOME}} ]]; then
	# Running as root with HOME owned by root.
	# Pass --user-data-dir to work around upstream failsafe.
	CHROMIUM_FLAGS="--user-data-dir=${XDG_CONFIG_HOME:-${HOME}/.config}/chromium
		${CHROMIUM_FLAGS}"
fi

# Select session type and platform
if @@FORCE_OZONE_PLATFORM@@; then
	CHROMIUM_FLAGS="--enable-features=UseOzonePlatform ${CHROMIUM_FLAGS}"
elif @@OZONE_AUTO_SESSION@@ && ! ${DISABLE_OZONE_PLATFORM:-false}; then
	if [[ ${XDG_SESSION_TYPE} == wayland || -n ${WAYLAND_DISPLAY} && ${XDG_SESSION_TYPE} != x11 ]]; then
		CHROMIUM_FLAGS="--enable-features=UseOzonePlatform ${CHROMIUM_FLAGS}"
	fi
fi

# Set the .desktop file name
export CHROME_DESKTOP="chromium-browser-chromium.desktop"

exec -a "chromium-browser" "$PROGDIR/chrome" --extra-plugin-dir=/usr/lib/nsbrowser/plugins ${CHROMIUM_FLAGS} "$@"
