# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @BLURB: Utility functions to build against slotted LLVM
# @DESCRIPTION:
# The llvm.eclass provides utility functions that can be used to build
# against specific version of slotted LLVM (with fallback to :0 for old
# versions).
#
# This eclass does not generate dependency strings. You need to write
# a proper dependency string yourself to guarantee that appropriate
# version of LLVM is installed.
#
# Example use for a package supporting LLVM 3.8 to 5:
# @CODE
# inherit cmake-utils llvm
#
# RDEPEND="
#	<sys-devel/llvm-6_rc:=
#	|| (
#		sys-devel/llvm:5
#		sys-devel/llvm:4
#		>=sys-devel/llvm-3.8:0
#	)
# "
#
# LLVM_MAX_SLOT=5
#
# # only if you need to define one explicitly
# pkg_setup() {
#	llvm_pkg_setup
#	do-something-else
# }
# @CODE

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

EXPORT_FUNCTIONS pkg_setup

if [[ ! ${_LLVM_ECLASS} ]]; then

# @ECLASS-VARIABLE: LLVM_MAX_SLOT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Highest LLVM slot supported by the package. Needs to be set before
# llvm_pkg_setup is called. If unset, no upper bound is assumed.

# @ECLASS-VARIABLE: _LLVM_KNOWN_SLOTS
# @INTERNAL
# @DESCRIPTION:
# Correct values of LLVM slots, newest first.
declare -g -r _LLVM_KNOWN_SLOTS=( 6 5 4 )

# @FUNCTION: get_llvm_prefix
# @USAGE: [<max_slot>]
# @DESCRIPTION:
# Prints the absolute path to an LLVM install prefix corresponding to
# the newest installed version of LLVM that is not newer than
# <max_slot>. If no <max_slot> is specified, there is no upper limit.
#
# Note that the function does not support lower-bound version, so you
# need to provide correct dependencies to ensure that a new enough
# version will be always installed. Otherwise, the function could return
# a version lower than required.
get_llvm_prefix() {
	debug-print-function ${FUNCNAME} "${@}"

	local max_slot=${1}
	local slot
	for slot in "${_LLVM_KNOWN_SLOTS[@]}"; do
		# skip higher slots
		if [[ -n ${max_slot} ]]; then
			if [[ ${max_slot} == ${slot} ]]; then
				max_slot=
			else
				continue
			fi
		fi

		local p=${EPREFIX}/usr/lib/llvm/${slot}
		if [[ -x ${p}/bin/llvm-config ]]; then
			echo "${p}"
			return
		fi
	done

	# max_slot should have been unset in the iteration
	if [[ -n ${max_slot} ]]; then
		die "${FUNCNAME}: invalid max_slot=${max_slot}"
	fi

	# fallback to :0
	# assume it's always <= 4 (the lower max_slot allowed)
	p=${EPREFIX}/usr
	if [[ -x ${p}/bin/llvm-config ]]; then
		echo "${p}"
		return
	fi

	die "No LLVM slot${1:+ <= ${1}} found in PATH!"
}

# @FUNCTION: llvm_pkg_setup
# @DESCRIPTION:
# Prepend the executable directory corresponding to the newest
# installed LLVM version that is not newer than ${LLVM_MAX_SLOT}
# to PATH. If LLVM_MAX_SLOT is unset or empty, the newest installed
# slot will be used.
#
# The PATH manipulation is only done for source builds. The function
# is a no-op when installing a binary package.
#
# If any other behavior is desired, the contents of the function
# should be inlined into the ebuild and modified as necessary.
llvm_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${MERGE_TYPE} != binary ]]; then
		export PATH=$(get_llvm_prefix ${LLVM_MAX_SLOT})/bin:${PATH}
	fi
}

_LLVM_ECLASS=1
fi
