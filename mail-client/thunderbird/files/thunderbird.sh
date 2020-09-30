#!/bin/bash

##
## Usage:
##
## $ thunderbird
##
## This script is meant to run Mozilla Thunderbird in Gentoo.

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

MOZ_THUNDERBIRD_FILE="thunderbird"

if [[ ! -r ${MOZ_LIB_DIR}/thunderbird/${MOZ_THUNDERBIRD_FILE} ]]; then
	if [[ ! -r ${SECONDARY_LIB_DIR}/thunderbird/${MOZ_THUNDERBIRD_FILE} ]]; then
		echo "Error: ${MOZ_LIB_DIR}/thunderbird/${MOZ_THUNDERBIRD_FILE} not found" >&2
		if [[ -d $SECONDARY_LIB_DIR ]]; then
			echo "       ${SECONDARY_LIB_DIR}/thunderbird/${MOZ_THUNDERBIRD_FILE} not found" >&2
		fi
		exit 1
	fi
	MOZ_LIB_DIR="$SECONDARY_LIB_DIR"
fi
MOZILLA_FIVE_HOME="${MOZ_LIB_DIR}/thunderbird"
MOZ_EXTENSIONS_PROFILE_DIR="${HOME}/.mozilla/extensions/{3550f703-e582-4d05-9a08-453d09bdfdc6}"
MOZ_PROGRAM="${MOZILLA_FIVE_HOME}/${MOZ_THUNDERBIRD_FILE}"
DESKTOP_FILE="thunderbird"

##
## Enable Wayland backend?
##
if @DEFAULT_WAYLAND@ && [[ -z ${MOZ_DISABLE_WAYLAND} ]]; then
	if [[ -n "$WAYLAND_DISPLAY" ]]; then
		DESKTOP_FILE="thunderbird-wayland"
		export MOZ_ENABLE_WAYLAND=1
	fi
elif [[ -n ${MOZ_DISABLE_WAYLAND} ]]; then
	DESKTOP_FILE="thunderbird-x11"
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
## Disable the GNOME crash dialog, Mozilla has its own
##
if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
	GNOME_DISABLE_CRASH_DIALOG=1
	export GNOME_DISABLE_CRASH_DIALOG
fi

##
## Enable Xinput2 (#617344)
##

# respect user settings
MOZ_USE_XINPUT2=${MOZ_USE_XINPUT2:-auto}

if [[ ${MOZ_USE_XINPUT2} == auto && -n ${WAYLAND_DISPLAY} ]]; then
	# enabling XINPUT2 should be safe for all wayland users
	MOZ_USE_XINPUT2=1
elif [[ ${MOZ_USE_XINPUT2} == auto && ${XDG_CURRENT_DESKTOP^^} == KDE ]]; then
	# XINPUT2 is known to cause problems for KWin users
	MOZ_USE_XINPUT2=0
elif [[ ${MOZ_USE_XINPUT2} == auto && ${XDG_CURRENT_DESKTOP^^} == LXQT ]]; then
	# LXQt uses KWin
	MOZ_USE_XINPUT2=0
elif [[ ${MOZ_USE_XINPUT2} == auto ]]; then
	# should work on Mate, Xfce, FluxBox, OpenBox and all the others ...
	MOZ_USE_XINPUT2=1
fi

[[ ${MOZ_USE_XINPUT2} != 0 ]] && export MOZ_USE_XINPUT2=${MOZ_USE_XINPUT2}

# Don't throw "old profile" dialog box.
export MOZ_ALLOW_DOWNGRADE=1

##
## Route to the correct .desktop file to get proper
## name and actions
##
if [[ $@ != *"--name "* ]]; then
	set -- --name "${DESKTOP_FILE}" "$@"
fi

# Run the mail client
exec ${MOZ_PROGRAM} "$@"
