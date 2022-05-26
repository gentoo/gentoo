# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: virtualx.eclass
# @MAINTAINER:
# x11@gentoo.org
# @AUTHOR:
# Original author: Martin Schlemmer <azarah@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: This eclass can be used for packages that need a working X environment to build.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} is not supported." ;;
esac

if [[ ! ${_VIRTUALX_ECLASS} ]]; then
_VIRTUALX_ECLASS=1

# @ECLASS_VARIABLE: VIRTUALX_REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# Variable specifying the dependency on xorg-server and xhost.
# Possible special values are "always" and "manual", which specify
# the dependency to be set unconditionaly or not at all.
# Any other value is taken as useflag desired to be in control of
# the dependency (eg. VIRTUALX_REQUIRED="kde" will add the dependency
# into "kde? ( )" and add kde into IUSE.
: ${VIRTUALX_REQUIRED:=test}

# @ECLASS_VARIABLE: VIRTUALX_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Standard dependencies string that is automatically added to BDEPEND
# (in EAPI-6: DEPEND) unless VIRTUALX_REQUIRED is set to "manual".
# DEPRECATED: Pre-EAPI-8 you can specify the variable BEFORE inherit
# to add more dependencies.
[[ ${EAPI} != [67] ]] && VIRTUALX_DEPEND=""
VIRTUALX_DEPEND+="
	x11-base/xorg-server[xvfb]
	x11-apps/xhost
"
[[ ${EAPI} != [67] ]] && readonly VIRTUALX_DEPEND

[[ ${VIRTUALX_COMMAND} ]] && die "VIRTUALX_COMMAND has been removed and is a no-op"

case ${VIRTUALX_REQUIRED} in
	manual)
		;;
	always)
		BDEPEND="${VIRTUALX_DEPEND}"
		;;
	*)
		BDEPEND="${VIRTUALX_REQUIRED}? ( ${VIRTUALX_DEPEND} )"
		IUSE="${VIRTUALX_REQUIRED}"
		[[ ${VIRTUALX_REQUIRED} == test ]] &&
			RESTRICT+=" !test? ( test )"
		;;
esac

[[ ${EAPI} == 6 ]] && DEPEND="${BDEPEND}"


# @FUNCTION: virtx
# @USAGE: <command> [command arguments]
# @DESCRIPTION:
# Start new Xvfb session and run commands in it.
#
# IMPORTANT: The command is run nonfatal !!!
#
# This means we are checking for the return code and raise an exception if it
# isn't 0. So you need to make sure that all commands return a proper
# code and not just die. All eclass function used should support nonfatal
# calls properly.
#
# The rational behind this is the tear down of the started Xfvb session. A
# straight die would leave a running session behind.
#
# Example:
#
# @CODE
# src_test() {
# 	virtx default
# }
# @CODE
#
# @CODE
# python_test() {
# 	virtx py.test --verbose
# }
# @CODE
#
# @CODE
# my_test() {
#   some_command
#   return $?
# }
#
# src_test() {
#   virtx my_test
# }
# @CODE
virtx() {
	debug-print-function ${FUNCNAME} "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"

	local i=0
	local retval=0
	local OLD_SANDBOX_ON="${SANDBOX_ON}"
	local XVFB XHOST XDISPLAY
	local xvfbargs="-screen 0 1280x1024x24 +extension RANDR"
	XVFB=$(type -p Xvfb) || die
	XHOST=$(type -p xhost) || die

	debug-print "${FUNCNAME}: running Xvfb hack"
	export XAUTHORITY=
	# The following is derived from Mandrake's hack to allow
	# compiling without the X display

	einfo "Scanning for an open DISPLAY to start Xvfb ..."
	# If we are in a chrooted environment, and there is already a
	# X server started outside of the chroot, Xvfb will fail to start
	# on the same display (most cases this is :0 ), so make sure
	# Xvfb is started, else bump the display number
	#
	# Azarah - 5 May 2002
	# GNOME GDM may have started X on DISPLAY :0 with a
	# lock file /tmp/.X1024-lock, therefore start the search at 1.
	# Else a leftover /tmp/.X1-lock will prevent finding an available display.
	XDISPLAY=$(i=1; while [[ -f /tmp/.X${i}-lock ]] ; do ((i++));done; echo ${i})
	debug-print "${FUNCNAME}: XDISPLAY=${XDISPLAY}"

	# We really do not want SANDBOX enabled here
	export SANDBOX_ON="0"

	debug-print "${FUNCNAME}: ${XVFB} :${XDISPLAY} ${xvfbargs}"
	${XVFB} :${XDISPLAY} ${xvfbargs} &>/dev/null &
	sleep 2

	local start=${XDISPLAY}
	while [[ ! -f /tmp/.X${XDISPLAY}-lock ]]; do
		# Stop trying after 15 tries
		if ((XDISPLAY - start > 15)) ; then
			eerror "'${XVFB} :${XDISPLAY} ${xvfbargs}' returns:"
			echo
			${XVFB} :${XDISPLAY} ${xvfbargs}
			echo
			eerror "If possible, correct the above error and try your emerge again."
			die "Unable to start Xvfb"
		fi
			((XDISPLAY++))
		debug-print "${FUNCNAME}: ${XVFB} :${XDISPLAY} ${xvfbargs}"
		${XVFB} :${XDISPLAY} ${xvfbargs} &>/dev/null &
		sleep 2
	done

	# Now enable SANDBOX again if needed.
	export SANDBOX_ON="${OLD_SANDBOX_ON}"

	einfo "Starting Xvfb on \$DISPLAY=${XDISPLAY} ..."

	export DISPLAY=:${XDISPLAY}
	# Do not break on error, but setup $retval, as we need
	# to kill Xvfb
	debug-print "${FUNCNAME}: $@"
	nonfatal "$@"
	retval=$?

	# Now kill Xvfb
	kill $(cat /tmp/.X${XDISPLAY}-lock)

	# die if our command failed
	[[ ${retval} -ne 0 ]] && die "Failed to run '$@'"

	return 0 # always return 0, it can be altered by failed kill for Xvfb
}

fi
