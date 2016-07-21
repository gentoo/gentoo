#!/bin/bash

# Allow the user to override command-line flags, bug #357629.
# This is based on Debian's chromium-browser package, and is intended
# to be consistent with Debian.
if [ -f /etc/chromium/default ] ; then
	. /etc/chromium/default
fi

# Prefer user defined CHROMIUM_USER_FLAGS (from env) over system
# default CHROMIUM_FLAGS (from /etc/chromium/default).
CHROMIUM_FLAGS=${CHROMIUM_USER_FLAGS:-"$CHROMIUM_FLAGS"}

# Let the wrapped binary know that it has been run through the wrapper
export CHROME_WRAPPER="`readlink -f "$0"`"

PROGDIR="`dirname "$CHROME_WRAPPER"`"

case ":$PATH:" in
  *:$PROGDIR:*)
    # $PATH already contains $PROGDIR
    ;;
  *)
    # Append $PROGDIR to $PATH
    export PATH="$PATH:$PROGDIR"
    ;;
esac

# Set the .desktop file name
export CHROME_DESKTOP="chromium-browser-chromium.desktop"

exec -a "chromium-browser" "$PROGDIR/chrome" --extra-plugin-dir=/usr/lib/nsbrowser/plugins ${CHROMIUM_FLAGS} "$@"
