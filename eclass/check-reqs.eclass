# Copyright 2004-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: check-reqs.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Bo Ørsted Andresen <zlin@gentoo.org>
# Original Author: Ciaran McCreesh <ciaranm@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Provides a uniform way of handling ebuilds with very high build requirements
# @DESCRIPTION:
# This eclass provides a uniform way of handling ebuilds which have very high
# build requirements in terms of memory or disk space. It provides a function
# which should usually be called ``during pkg_setup()``.
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
# If you don't specify a value for, say, ``CHECKREQS_MEMORY``, then the test is
# not carried out.
#
# These checks should probably mostly work on non-Linux, and they should
# probably degrade gracefully if they don't. Probably.

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI=${EAPI:-0} is not supported" ;;
esac

EXPORT_FUNCTIONS pkg_pretend pkg_setup

if [[ ! ${_CHECK_REQS_ECLASS} ]]; then
_CHECK_REQS_ECLASS=1

# @ECLASS_VARIABLE: CHECKREQS_MEMORY
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much RAM is needed? Eg.: ``CHECKREQS_MEMORY=15M``

# @ECLASS_VARIABLE: CHECKREQS_DISK_BUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much diskspace is needed to build the package? Eg.: ``CHECKREQS_DISK_BUILD=2T``

# @ECLASS_VARIABLE: CHECKREQS_DISK_USR
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much space in /usr is needed to install the package? Eg.: ``CHECKREQS_DISK_USR=15G``

# @ECLASS_VARIABLE: CHECKREQS_DISK_VAR
# @DEFAULT_UNSET
# @DESCRIPTION:
# How much space is needed in /var? Eg.: ``CHECKREQS_DISK_VAR=3000M``

# @ECLASS_VARIABLE: CHECKREQS_DONOTHING
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Do not error out in ``_check-reqs_output`` if requirements are not met.
# This is a user flag and should under *no circumstances* be set in the ebuild.
[[ -n ${I_KNOW_WHAT_I_AM_DOING} ]] && CHECKREQS_DONOTHING=1

# @ECLASS_VARIABLE: CHECKREQS_FAILED
# @INTERNAL
# @DESCRIPTION:
# If set the checks failed and eclass should abort the build.
# Internal, do not set yourself.

# @FUNCTION: check-reqs_pkg_setup
# @DESCRIPTION:
# Exported function running the resources checks in ``pkg_setup`` phase.
# It should be run in both phases to ensure condition changes between
# ``pkg_pretend`` and ``pkg_setup`` won't affect the build.
check-reqs_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	_check-reqs_prepare
	_check-reqs_run
	_check-reqs_output
}

# @FUNCTION: check-reqs_pkg_pretend
# @DESCRIPTION:
# Exported function running the resources checks in ``pkg_pretend`` phase.
check-reqs_pkg_pretend() {
	debug-print-function ${FUNCNAME} "$@"

	check-reqs_pkg_setup "$@"
}

# @FUNCTION: check-reqs_prepare
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks the variables that should be defined.
check-reqs_prepare() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_prepare "$@"
}

# @FUNCTION: _check-reqs_prepare
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks the variables that should be defined.
_check-reqs_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z ${CHECKREQS_MEMORY} &&
			-z ${CHECKREQS_DISK_BUILD} &&
			-z ${CHECKREQS_DISK_USR} &&
			-z ${CHECKREQS_DISK_VAR} ]]; then
		eerror "Set some check-reqs eclass variables if you want to use it."
		eerror "If you are user and see this message file a bug against the package."
		die "${FUNCNAME}: check-reqs eclass called but not actually used!"
	fi
}

# @FUNCTION: check-reqs_run
# @INTERNAL
# @DESCRIPTION:
# Internal function that runs the check based on variable settings.
check-reqs_run() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_run "$@"
}

# @FUNCTION: _check-reqs_run
# @INTERNAL
# @DESCRIPTION:
# Internal function that runs the check based on variable settings.
_check-reqs_run() {
	debug-print-function ${FUNCNAME} "$@"

	# some people are *censored*
	unset CHECKREQS_FAILED

	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ -n ${CHECKREQS_MEMORY} ]] && \
			_check-reqs_memory \
				${CHECKREQS_MEMORY}

		[[ -n ${CHECKREQS_DISK_BUILD} ]] && \
			_check-reqs_disk \
				"${T}" \
				"${CHECKREQS_DISK_BUILD}"
	fi

	if [[ ${MERGE_TYPE} != buildonly ]]; then
		[[ -n ${CHECKREQS_DISK_USR} ]] && \
			_check-reqs_disk \
				"${EROOT%/}/usr" \
				"${CHECKREQS_DISK_USR}"

		[[ -n ${CHECKREQS_DISK_VAR} ]] && \
			_check-reqs_disk \
				"${EROOT%/}/var" \
				"${CHECKREQS_DISK_VAR}"
	fi
}

# @FUNCTION: check-reqs_get_kibibytes
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns number in KiB.
# Returns 1024**2 for 1G or 1024**3 for 1T.
check-reqs_get_kibibytes() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_get_kibibytes "$@"
}

# @FUNCTION: _check-reqs_get_kibibytes
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns number in KiB.
# Returns 1024**2 for 1G or 1024**3 for 1T.
_check-reqs_get_kibibytes() {
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
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_get_number "$@"
}

# @FUNCTION: _check-reqs_get_number
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns the numerical value without the unit.
# Returns "1" for "1G" or "150" for "150T".
_check-reqs_get_number() {
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
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_get_unit "$@"
}

# @FUNCTION: _check-reqs_get_unit
# @INTERNAL
# @DESCRIPTION:
# Internal function that returns the unit without the numerical value.
# Returns "GiB" for "1G" or "TiB" for "150T".
_check-reqs_get_unit() {
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
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_get_unit "$@"
}

# @FUNCTION: _check-reqs_output
# @INTERNAL
# @DESCRIPTION:
# Internal function that prints the warning and dies if required based on
# the test results.
_check-reqs_output() {
	debug-print-function ${FUNCNAME} "$@"

	local msg="ewarn"

	[[ ${EBUILD_PHASE} == "pretend" && -z ${CHECKREQS_DONOTHING} ]] && msg="eerror"
	if [[ -n ${CHECKREQS_FAILED} ]]; then
		${msg}
		${msg} "Space constraints set in the ebuild were not met!"
		${msg} "The build will most probably fail, you should enhance the space"
		${msg} "as per failed tests."
		${msg}

		[[ ${EBUILD_PHASE} == "pretend" && -z ${CHECKREQS_DONOTHING} ]] && \
			die "Build requirements not met!"
	fi
}

# @FUNCTION: check-reqs_memory
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks size of RAM.
check-reqs_memory() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_memory "$@"
}

# @FUNCTION: _check-reqs_memory
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks size of RAM.
_check-reqs_memory() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${1} ]] && die "Usage: ${FUNCNAME} [size]"

	local size=${1}
	local actual_memory
	local actual_swap

	_check-reqs_start_phase \
		${size} \
		"RAM"

	if [[ -r /proc/meminfo ]] ; then
		actual_memory=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
		actual_swap=$(awk '/SwapTotal/ { print $2 }' /proc/meminfo)
	else
		actual_memory=$(sysctl hw.physmem 2>/dev/null)
		[[ $? -eq 0 ]] && actual_memory=$(echo "${actual_memory}" \
			| sed -e 's/^[^:=]*[:=][[:space:]]*//')
		actual_swap=$(sysctl vm.swap_total 2>/dev/null)
		[[ $? -eq 0 ]] && actual_swap=$(echo "${actual_swap}" \
			| sed -e 's/^[^:=]*[:=][[:space:]]*//')
	fi
	if [[ -n ${actual_memory} ]] ; then
		if [[ ${actual_memory} -ge $(_check-reqs_get_kibibytes ${size}) ]] ; then
			eend 0
		elif [[ -n ${actual_swap} && $((${actual_memory} + ${actual_swap})) \
				-ge $(_check-reqs_get_kibibytes ${size}) ]] ; then
			ewarn "Amount of main memory is insufficient, but amount"
			ewarn "of main memory combined with swap is sufficient."
			ewarn "Build process may make computer very slow!"
			eend 0
		else
			eend 1
			_check-reqs_unsatisfied \
				${size} \
				"RAM"
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
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_disk "$@"
}

# @FUNCTION: _check-reqs_disk
# @INTERNAL
# @DESCRIPTION:
# Internal function that checks space on the harddrive.
_check-reqs_disk() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${2} ]] && die "Usage: ${FUNCNAME} [path] [size]"

	local path=${1}
	local size=${2}
	local space_kbi

	_check-reqs_start_phase \
		${size} \
		"disk space at \"${path}\""

	space_kbi=$(df -Pk "${1}" 2>/dev/null | awk 'FNR == 2 {print $4}')

	if [[ $? == 0 && -n ${space_kbi} ]] ; then
		if [[ ${space_kbi} -lt $(_check-reqs_get_kibibytes ${size}) ]] ; then
			eend 1
			_check-reqs_unsatisfied \
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
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_start_phase "$@"
}

# @FUNCTION: _check-reqs_start_phase
# @INTERNAL
# @DESCRIPTION:
# Internal function that inform about started check
_check-reqs_start_phase() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${2} ]] && die "Usage: ${FUNCNAME} [size] [location]"

	local size=${1}
	local location=${2}
	local sizeunit="$(_check-reqs_get_number ${size}) $(_check-reqs_get_unit ${size})"

	ebegin "Checking for at least ${sizeunit} ${location}"
}

# @FUNCTION: check-reqs_unsatisfied
# @INTERNAL
# @DESCRIPTION:
# Internal function that informs about check result.
# It has different output between pretend and setup phase,
# where in pretend phase it is fatal.
check-reqs_unsatisfied() {
	[[ ${EAPI} == [67] ]] ||
		die "Internal function ${FUNCNAME} is not available in EAPI ${EAPI}."
	_check-reqs_unsatisfied "$@"
}

# @FUNCTION: _check-reqs_unsatisfied
# @INTERNAL
# @DESCRIPTION:
# Internal function that informs about check result.
# It has different output between pretend and setup phase,
# where in pretend phase it is fatal.
_check-reqs_unsatisfied() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${2} ]] && die "Usage: ${FUNCNAME} [size] [location]"

	local msg="ewarn"
	local size=${1}
	local location=${2}
	local sizeunit="$(_check-reqs_get_number ${size}) $(_check-reqs_get_unit ${size})"

	[[ ${EBUILD_PHASE} == "pretend" && -z ${CHECKREQS_DONOTHING} ]] && msg="eerror"
	${msg} "There is NOT at least ${sizeunit} ${location}"

	CHECKREQS_FAILED="true"
}

fi
