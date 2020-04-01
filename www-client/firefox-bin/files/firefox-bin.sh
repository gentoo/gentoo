#!/bin/bash

##
## Usage:
##
## $ firefox-bin
##
## This script is meant to run Mozilla Firefox in Gentoo.

cmdname=$(basename "$0")

##
## Variables
##
MOZ_ARCH=$(uname -m)
case ${MOZ_ARCH} in
	x86_64|s390x|sparc64)
		MOZ_LIB_DIR="@PREFIX@/lib64"
		SECONDARY_LIB_DIR="@PREFIX@/lib"
		;;
	*)
		MOZ_LIB_DIR="@PREFIX@/lib"
		SECONDARY_LIB_DIR="@PREFIX@/lib64"
		;;
esac

MOZ_FIREFOX_FILE="firefox-bin"
MOZILLA_FIVE_HOME="@MOZ_FIVE_HOME@"
MOZ_EXTENSIONS_PROFILE_DIR="${HOME}/.mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
MOZ_PROGRAM="${MOZILLA_FIVE_HOME}/${MOZ_FIREFOX_FILE}"
APULSELIB_DIR="@APULSELIB_DIR@"
DESKTOP_FILE="firefox-bin"

##
## Enable Wayland backend?
##
if @DEFAULT_WAYLAND@ && [[ -z ${MOZ_DISABLE_WAYLAND} ]]; then
	if [[ -n "$WAYLAND_DISPLAY" ]]; then
		DESKTOP_FILE="firefox-bin-wayland"
		export MOZ_ENABLE_WAYLAND=1
	fi
elif [[ -n ${MOZ_DISABLE_WAYLAND} ]]; then
	DESKTOP_FILE="firefox-bin-x11"
fi

##
## Use D-Bus remote exclusively when there's Wayland display.
##
if [[ -n "${WAYLAND_DISPLAY}" ]]; then
	export MOZ_DBUS_REMOTE=1
fi

##
## Make sure that we set the plugin path
##
MOZ_PLUGIN_DIR="plugins"

if [[ -n "${MOZ_PLUGIN_PATH}" ]]; then
	MOZ_PLUGIN_PATH=${MOZ_PLUGIN_PATH}:${MOZ_LIB_DIR}/mozilla/${MOZ_PLUGIN_DIR}
else
	MOZ_PLUGIN_PATH=${MOZ_LIB_DIR}/mozilla/${MOZ_PLUGIN_DIR}
fi

if [[ -d "${SECONDARY_LIB_DIR}/mozilla/${MOZ_PLUGIN_DIR}" ]]; then
	MOZ_PLUGIN_PATH=${MOZ_PLUGIN_PATH}:${SECONDARY_LIB_DIR}/mozilla/${MOZ_PLUGIN_DIR}
fi

export MOZ_PLUGIN_PATH

##
## Set MOZ_APP_LAUNCHER for gnome-session
##
export MOZ_APP_LAUNCHER="@PREFIX@/bin/${cmdname}"

##
## Disable the GNOME crash dialog, Moz has it's own
##
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
	GNOME_DISABLE_CRASH_DIALOG=1
	export GNOME_DISABLE_CRASH_DIALOG
fi

##
## Enable Xinput2 (#617344)
##
export MOZ_USE_XINPUT2=1

# Don't throw "old profile" dialog box.
export MOZ_ALLOW_DOWNGRADE=1

##
## Set special variables for -bin
export LD_LIBRARY_PATH="${APULSELIB_DIR:${APULSELIB_DIR}:}${MOZILLA_FIVE_HOME}"
export GTK_PATH="${MOZ_LIB_DIR}/gtk-3.0"

##
## Route to the correct .desktop file to get proper
## name and actions
##
if [[ $@ != *"--name "* ]]; then
	set -- --name "${DESKTOP_FILE}" "$@"
fi

# Run the browser
exec ${MOZ_PROGRAM} "$@"
