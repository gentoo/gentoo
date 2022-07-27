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
		[[ ${VIRTUALX_REQUIRED} == "test" ]] &&
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
	local xvfbargs=( -screen 0 1280x1024x24 +extension RANDR )

	debug-print "${FUNCNAME}: running Xvfb hack"
	export XAUTHORITY=

	einfo "Starting Xvfb ..."

	debug-print "${FUNCNAME}: Xvfb -displayfd 1 ${xvfbargs[*]}"
	local logfile=${T}/Xvfb.log
	local pidfile=${T}/Xvfb.pid
	# NB: bash command substitution blocks until Xvfb prints fd to stdout
	# and then closes the fd; only then it backgrounds properly
	export DISPLAY=:$(
		Xvfb -displayfd 1 "${xvfbargs[@]}" 2>"${logfile}" &
		echo "$!" > "${pidfile}"
	)

	if [[ ${DISPLAY} == : ]]; then
		eerror "Xvfb failed to start, reprinting error log"
		cat "${logfile}"
		die "Xvfb failed to start"
	fi

	# Do not break on error, but setup $retval, as we need to kill Xvfb
	einfo "Xvfb started on DISPLAY=${DISPLAY}"
	debug-print "${FUNCNAME}: $@"
	nonfatal "$@"
	retval=$?

	# Now kill Xvfb
	kill "$(<"${pidfile}")"

	# die if our command failed
	[[ ${retval} -ne 0 ]] && die "Failed to run '$@'"

	return 0 # always return 0, it can be altered by failed kill for Xvfb
}

fi
