# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: check-reqs.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Bo Ørsted Andresen <zlin@gentoo.org>
# Original Author: Ciaran McCreesh <ciaranm@gentoo.org>
# @BLURB: Provides a uniform way of handling ebuild which have very high build requirements
# @DESCRIPTION:
# This eclass provides a uniform way of handling ebuilds which have very high
# build requirements in terms of memory or disk space. It provides a function
# which should usually be called during pkg_setup().
#
# The chosen action only happens when the system's resources are detected
# correctly and only if they are below the threshold specified by the package.
#
# @CODE
# # need this much memory (does *not* check swap)
# CHECKREQS_MEMORY="256M"
#
# # need this much temporary build space
# CHECKREQS_DISK_BUILD="2G"
#
# # install will need this much space in /usr
# CHECKREQS_DISK_USR="1G"
#
# # install will need this much space in /var
# CHECKREQS_DISK_VAR="1024M"
#
# @CODE
#
# If you don't specify a value for, say, CHECKREQS_MEMORY, then the test is not
# carried out.
#
# These checks should probably mostly work on non-Linux, and they should
# probably degrade gracefully if they don't. Probably.

if [[ ! ${_CHECK_REQS_ECLASS_} ]]; then

# @ECLASS-VARIABLE: CHECKREQS_MEMORY
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much RAM is needed? Eg.: CHECKREQS_MEMORY=15M

# @ECLASS-VARIABLE:  CHECKREQS_DISK_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much diskspace is needed to build the package? Eg.: CHECKREQS_DISK_BUILD=2T

# @ECLASS-VARIABLE: CHECKREQS_DISK_USR
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much space in /usr is needed to install the package? Eg.: CHECKREQS_DISK_USR=15G

# @ECLASS-VARIABLE: CHECKREQS_DISK_VAR
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much space is needed in /var? Eg.: CHECKREQS_DISK_VAR=3000M

EXPORT_FUNCTIONS pkg_setup
case "${EAPI:-0}" in
	0|1|2|3) ;;
	4|5|6) EXPORT_FUNCTIONS pkg_pretend ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

# Obsolete function executing all the checks and printing out results
check_reqs() {
	eerror "Package calling old ${FUNCNAME} function."
	eerror "It should call check-reqs_pkg_pretend and check-reqs_pkg_setup."
	die "${FUNCNAME} is banned"
}

# @FUNCTION: check-reqs_pkg_setup
# @DESCRIPTION:
# Exported function running the resources checks in pkg_setup phase.
# It should be run in both phases to ensure condition changes between
# pkg_pretend and pkg_setup won't affect the build.
check-reqs_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	check-reqs_prepare
	check-reqs_run
	check-reqs_output
}

# @FUNCTION: check-reqs_pkg_pretend
# @DESCRIPTION:
# Exported function running the resources checks in pkg_pretend phase.
check-reqs_pkg_pretend() {
	debug-print-function ${FUNCNAME} "$@"

	check-reqs_pkg_setup "$@"
}

# @FUNCTION: check-reqs_prepare
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks the variables that should be defined.
check-reqs_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z ${CHECKREQS_MEMORY} &&
			-z ${CHECKREQS_DISK_BUILD} &&
			-z ${CHECKREQS_DISK_USR} &&
			-z ${CHECKREQS_DISK_VAR} ]]; then
		eerror "Set some check-reqs eclass variables if you want to use it."
		eerror "If you are user and see this message file a bug against the package."
		die "${FUNCNAME}: check-reqs eclass called but not actualy used!"
	fi
}

# @FUNCTION: check-reqs_run
# @INTERNAL
# @DESCRIPTION:
# Internal function that runs the check based on variable settings.
check-reqs_run() {
	debug-print-function ${FUNCNAME} "$@"

	# some people are *censored*
	unset CHECKREQS_FAILED

	[[ ${EAPI:-0} == [0123] ]] && local MERGE_TYPE=""

	# use != in test, because MERGE_TYPE only exists in EAPI 4 and later
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ -n ${CHECKREQS_MEMORY} ]] && \
			check-reqs_memory \
				${CHECKREQS_MEMORY}

		[[ -n ${CHECKREQS_DISK_BUILD} ]] && \
			check-reqs_disk \
				"${T}" \
				"${CHECKREQS_DISK_BUILD}"
	fi

	if [[ ${MERGE_TYPE} != buildonly ]]; then
		[[ -n ${CHECKREQS_DISK_USR} ]] && \
			check-reqs_disk \
				"${EROOT}/usr" \
				"${CHECKREQS_DISK_USR}"

		[[ -n ${CHECKREQS_DISK_VAR} ]] && \
			check-reqs_disk \
				"${EROOT}/var" \
				"${CHECKREQS_DISK_VAR}"
	fi
}

# @FUNCTION: check-reqs_get_kibibytes
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns number in KiB.
# Returns 1024**2 for 1G or 1024**3 for 1T.
check-reqs_get_kibibytes() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "Usage: ${FUNCNAME} [size]"

	local unit=${1:(-1)}
	local size=${1%[GMT]}

	case ${unit} in
		M) echo $((1024 * size)) ;;
		G) echo $((1024 * 1024 * size)) ;;
		T) echo $((1024 * 1024 * 1024 * size)) ;;
		*)
			die "${FUNCNAME}: Unknown unit: ${unit}"
		;;
	esac
}

# @FUNCTION: check-reqs_get_number
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns the numerical value without the unit.
# Returns "1" for "1G" or "150" for "150T".
check-reqs_get_number() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "Usage: ${FUNCNAME} [size]"

	local size=${1%[GMT]}
	[[ ${size} == ${1} ]] && die "${FUNCNAME}: Missing unit: ${1}"

	echo ${size}
}

# @FUNCTION: check-reqs_get_unit
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns the unit without the numerical value.
# Returns "GiB" for "1G" or "TiB" for "150T".
check-reqs_get_unit() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "Usage: ${FUNCNAME} [size]"

	local unit=${1:(-1)}

	case ${unit} in
		M) echo "MiB" ;;
		G) echo "GiB" ;;
		T) echo "TiB" ;;
		*)
			die "${FUNCNAME}: Unknown unit: ${unit}"
		;;
	esac
}

# @FUNCTION: check-reqs_output
# @INTERNAL
# @DESCRIPTION:
# Internal function that prints the warning and dies if required based on
# the test results.
check-reqs_output() {
	debug-print-function ${FUNCNAME} "$@"

	local msg="ewarn"

	[[ ${EBUILD_PHASE} == "pretend" && -z ${I_KNOW_WHAT_I_AM_DOING} ]] && msg="eerror"
	if [[ -n ${CHECKREQS_FAILED} ]]; then
		${msg}
		${msg} "Space constraints set in the ebuild were not met!"
		${msg} "The build will most probably fail, you should enhance the space"
		${msg} "as per failed tests."
		${msg}

		[[ ${EBUILD_PHASE} == "pretend" && -z ${I_KNOW_WHAT_I_AM_DOING} ]] && \
			die "Build requirements not met!"
	fi
}

# @FUNCTION: check-reqs_memory
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks size of RAM.
check-reqs_memory() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "Usage: ${FUNCNAME} [size]"

	local size=${1}
	local actual_memory

	check-reqs_start_phase \
		${size} \
		"RAM"

	if [[ -r /proc/meminfo ]] ; then
		actual_memory=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
	else
		actual_memory=$(sysctl hw.physmem 2>/dev/null )
		[[ "$?" == "0" ]] &&
			actual_memory=$(echo $actual_memory | sed -e 's/^[^:=]*[:=]//' )
	fi
	if [[ -n ${actual_memory} ]] ; then
		if [[ ${actual_memory} -lt $(check-reqs_get_kibibytes ${size}) ]] ; then
			eend 1
			check-reqs_unsatisfied \
				${size} \
				"RAM"
		else
			eend 0
		fi
	else
		eend 1
		ewarn "Couldn't determine amount of memory, skipping..."
	fi
}

# @FUNCTION: check-reqs_disk
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks space on the harddrive.
check-reqs_disk() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${2} ]] && die "Usage: ${FUNCNAME} [path] [size]"

	local path=${1}
	local size=${2}
	local space_kbi

	check-reqs_start_phase \
		${size} \
		"disk space at \"${path}\""

	space_kbi=$(df -Pk "${1}" 2>/dev/null | awk 'FNR == 2 {print $4}')

	if [[ $? == 0 && -n ${space_kbi} ]] ; then
		if [[ ${space_kbi} -lt $(check-reqs_get_kibibytes ${size}) ]] ; then
			eend 1
			check-reqs_unsatisfied \
				${size} \
				"disk space at \"${path}\""
		else
			eend 0
		fi
	else
		eend 1
		ewarn "Couldn't determine disk space, skipping..."
	fi
}

# @FUNCTION: check-reqs_start_phase
# @INTERNAL
# @DESCRIPTION:
# Internal function that inform about started check
check-reqs_start_phase() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${2} ]] && die "Usage: ${FUNCNAME} [size] [location]"

	local size=${1}
	local location=${2}
	local sizeunit="$(check-reqs_get_number ${size}) $(check-reqs_get_unit ${size})"

	ebegin "Checking for at least ${sizeunit} ${location}"
}

# @FUNCTION: check-reqs_unsatisfied
# @INTERNAL
# @DESCRIPTION:
# Internal function that inform about check result.
# It has different output between pretend and setup phase,
# where in pretend phase it is fatal.
check-reqs_unsatisfied() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${2} ]] && die "Usage: ${FUNCNAME} [size] [location]"

	local msg="ewarn"
	local size=${1}
	local location=${2}
	local sizeunit="$(check-reqs_get_number ${size}) $(check-reqs_get_unit ${size})"

	[[ ${EBUILD_PHASE} == "pretend" && -z ${I_KNOW_WHAT_I_AM_DOING} ]] && msg="eerror"
	${msg} "There is NOT at least ${sizeunit} ${location}"

	# @ECLASS-VARIABLE: CHECKREQS_FAILED
	# @DESCRIPTION:
	# @INTERNAL
	# If set the checks failed and eclass should abort the build.
	# Internal, do not set yourself.
	CHECKREQS_FAILED="true"
}

_CHECK_REQS_ECLASS_=1
fi
