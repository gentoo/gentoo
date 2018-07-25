# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: virtualx.eclass
# @MAINTAINER:
# x11@gentoo.org
# @AUTHOR:
# Original author: Martin Schlemmer <azarah@gentoo.org>
# @BLURB: This eclass can be used for packages that needs a working X environment to build.

if [[ ! ${_VIRTUAL_X} ]]; then

case "${EAPI:-0}" in
	0|1|2|3)
		die "virtualx.eclass: EAPI ${EAPI} is too old."
		;;
	4|5|6)
		;;
	*)
		die "virtualx.eclass: EAPI ${EAPI} is not supported yet."
		;;
esac

[[ ${EAPI} == [45] ]] && inherit eutils

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# Variable specifying the dependency on xorg-server and xhost.
# Possible special values are "always" and "manual", which specify
# the dependency to be set unconditionaly or not at all.
# Any other value is taken as useflag desired to be in control of
# the dependency (eg. VIRTUALX_REQUIRED="kde" will add the dependency
# into "kde? ( )" and add kde into IUSE.
: ${VIRTUALX_REQUIRED:=test}

# @ECLASS-VARIABLE: VIRTUALX_DEPEND
# @DESCRIPTION:
# Dep string available for use outside of eclass, in case a more
# complicated dep is needed.
# You can specify the variable BEFORE inherit to add more dependencies.
VIRTUALX_DEPEND="${VIRTUALX_DEPEND}
	!prefix? ( x11-base/xorg-server[xvfb] )
	x11-apps/xhost
"

# @ECLASS-VARIABLE: VIRTUALX_COMMAND
# @DESCRIPTION:
# Command (or eclass function call) to be run in the X11 environment
# (within virtualmake function).
: ${VIRTUALX_COMMAND:="emake"}

case ${VIRTUALX_REQUIRED} in
	manual)
		;;
	always)
		DEPEND="${VIRTUALX_DEPEND}"
		RDEPEND=""
		;;
	optional|tests)
		[[ ${EAPI} == [45] ]] \
			|| die 'Values "optional" and "tests" for VIRTUALX_REQUIRED are banned in EAPI > 5'
		# deprecated section YAY.
		eqawarn "VIRTUALX_REQUIRED=optional and VIRTUALX_REQUIRED=tests are deprecated."
		eqawarn "You can drop the variable definition completely from ebuild,"
		eqawarn "because it is default behaviour."

		if [[ -n ${VIRTUALX_USE} ]]; then
			# so they like to specify the useflag
			eqawarn "VIRTUALX_USE variable is deprecated."
			eqawarn "Please read eclass manpage to find out how to use VIRTUALX_REQUIRED"
			eqawarn "to achieve the same behaviour."
		fi

		[[ -z ${VIRTUALX_USE} ]] && VIRTUALX_USE="test"
		DEPEND="${VIRTUALX_USE}? ( ${VIRTUALX_DEPEND} )"
		RDEPEND=""
		IUSE="${VIRTUALX_USE}"
		;;
	*)
		DEPEND="${VIRTUALX_REQUIRED}? ( ${VIRTUALX_DEPEND} )"
		RDEPEND=""
		IUSE="${VIRTUALX_REQUIRED}"
		;;
esac

# @FUNCTION: virtualmake
# @DESCRIPTION:
# Function which start new Xvfb session
# where the VIRTUALX_COMMAND variable content gets executed.
virtualmake() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${EAPI} == [45] ]] \
		|| die "${FUNCNAME} is unsupported in EAPI > 5, please use virtx"

	# backcompat for maketype
	if [[ -n ${maketype} ]]; then
		[[ ${EAPI} == [45] ]] || die "maketype is banned in EAPI > 5"
		eqawarn "ebuild is exporting \$maketype=${maketype}"
		eqawarn "Ebuild should be migrated to use 'virtx command' instead."
		VIRTUALX_COMMAND=${maketype}
	fi

	virtx "${VIRTUALX_COMMAND}" "${@}"
}


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
	XDISPLAY=$(i=0; while [[ -f /tmp/.X${i}-lock ]] ; do ((i++));done; echo ${i})
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

# @FUNCTION: Xmake
# @DESCRIPTION:
# Same as "make", but set up the Xvfb hack if needed.
# Deprecated call.
Xmake() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${EAPI} == [45] ]] \
		|| die "${FUNCNAME} is unsupported in EAPI > 5, please use 'virtx emake -j1 ....'"

	eqawarn "you should not execute make directly"
	eqawarn "rather execute Xemake -j1 if you have issues with parallel make"
	VIRTUALX_COMMAND="emake -j1" virtualmake "$@"
}

# @FUNCTION: Xemake
# @DESCRIPTION:
# Same as "emake", but set up the Xvfb hack if needed.
Xemake() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${EAPI} == [45] ]] \
		|| die "${FUNCNAME} is unsupported in EAPI > 5, please use 'virtx emake ....'"

	VIRTUALX_COMMAND="emake" virtualmake "$@"
}

# @FUNCTION: Xeconf
# @DESCRIPTION:
# Same as "econf", but set up the Xvfb hack if needed.
Xeconf() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${EAPI} == [45] ]] \
		|| die "${FUNCNAME} is unsupported in EAPI > 5, please use 'virtx econf ....'"

	VIRTUALX_COMMAND="econf" virtualmake "$@"
}

_VIRTUAL_X=1
fi
