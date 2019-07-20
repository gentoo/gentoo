# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
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
# Example use for a package supporting LLVM 5 to 7:
# @CODE
# inherit cmake-utils llvm
#
# RDEPEND="
#	<sys-devel/llvm-8:=
#	|| (
#		sys-devel/llvm:7
#		sys-devel/llvm:6
#		sys-devel/llvm:5
#	)
# "
# DEPEND=${RDEPEND}
#
# LLVM_MAX_SLOT=7
#
# # only if you need to define one explicitly
# pkg_setup() {
#	llvm_pkg_setup
#	do-something-else
# }
# @CODE
#
# Example for a package needing LLVM+clang w/ a specific target:
# @CODE
# inherit cmake-utils llvm
#
# # note: do not use := on both clang and llvm, it can match different
# # slots then. clang pulls llvm in, so we can skip the latter.
# RDEPEND="
#	>=sys-devel/clang-6:=[llvm_targets_AMDGPU(+)]
# "
# DEPEND=${RDEPEND}
#
# llvm_check_deps() {
#	has_version -d "sys-devel/clang:${LLVM_SLOT}[llvm_targets_AMDGPU(+)]"
# }
# @CODE

case "${EAPI:-0}" in
	0|1|2|3|4|5)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	6|7)
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
declare -g -r _LLVM_KNOWN_SLOTS=( 10 9 8 7 6 5 4 )

# @FUNCTION: get_llvm_prefix
# @USAGE: [-b|-d] [<max_slot>]
# @DESCRIPTION:
# Find the newest LLVM install that is acceptable for the package,
# and print an absolute path to it.
#
# If -b is specified, the checks are performed relative to BROOT,
# and BROOT-path is returned.  This is appropriate when your package
# calls llvm-config executable.  -b is supported since EAPI 7.
#
# If -d is specified, the checks are performed relative to ESYSROOT,
# and ESYSROOT-path is returned.  This is appropriate when your package
# uses CMake find_package(LLVM).  -d is the default.
#
# If <max_slot> is specified, then only LLVM versions that are not newer
# than <max_slot> will be considered. Otherwise, all LLVM versions would
# be considered acceptable. The function does not support specifying
# minimal supported version -- the developer must ensure that a version
# new enough is installed via providing appropriate dependencies.
#
# If llvm_check_deps() function is defined within the ebuild, it will
# be called to verify whether a particular slot is accepable. Within
# the function scope, LLVM_SLOT will be defined to the SLOT value
# (0, 4, 5...). The function should return a true status if the slot
# is acceptable, false otherwise. If llvm_check_deps() is not defined,
# the function defaults to checking whether sys-devel/llvm:${LLVM_SLOT}
# is installed.
get_llvm_prefix() {
	debug-print-function ${FUNCNAME} "${@}"

	local hv_switch=-d
	while [[ ${1} == -* ]]; do
		case ${1} in
			-b|-d) hv_switch=${1};;
			*) break;;
		esac
		shift
	done

	local prefix=
	if [[ ${EAPI} != 6 ]]; then
		case ${hv_switch} in
			-b)
				prefix=${BROOT}
				;;
			-d)
				prefix=${ESYSROOT}
				;;
		esac
	else
		case ${hv_switch} in
			-b)
				die "${FUNCNAME} -b is not supported in EAPI ${EAPI}"
				;;
			-d)
				prefix=${EPREFIX}
				hv_switch=
				;;
		esac
	fi

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

		if declare -f llvm_check_deps >/dev/null; then
			local LLVM_SLOT=${slot}
			llvm_check_deps || continue
		else
			# check if LLVM package is installed
			has_version ${hv_switch} "sys-devel/llvm:${slot}" || continue
		fi

		echo "${prefix}/usr/lib/llvm/${slot}"
		return
	done

	# max_slot should have been unset in the iteration
	if [[ -n ${max_slot} ]]; then
		die "${FUNCNAME}: invalid max_slot=${max_slot}"
	fi

	# fallback to :0
	# assume it's always <= 4 (the lower max_slot allowed)
	if has_version ${hv_switch} "sys-devel/llvm:0"; then
		echo "${prefix}/usr"
		return
	fi

	die "No LLVM slot${1:+ <= ${1}} found installed!"
}

# @FUNCTION: llvm_pkg_setup
# @DESCRIPTION:
# Prepend the appropriate executable directory for the newest
# acceptable LLVM slot to the PATH. For path determination logic,
# please see the get_llvm_prefix documentation.
#
# The highest acceptable LLVM slot can be set in LLVM_MAX_SLOT variable.
# If it is unset or empty, any slot is acceptable.
#
# The PATH manipulation is only done for source builds. The function
# is a no-op when installing a binary package.
#
# If any other behavior is desired, the contents of the function
# should be inlined into the ebuild and modified as necessary.
llvm_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${MERGE_TYPE} != binary ]]; then
		local llvm_prefix=$(get_llvm_prefix "${LLVM_MAX_SLOT}")

		# do not prepend /usr/bin, it's not necessary and breaks other
		# prepends, https://bugs.gentoo.org/622866
		if [[ ${llvm_prefix} != ${EPREFIX}/usr ]]; then
			export PATH=${llvm_prefix}/bin:${PATH}
		fi
	fi
}

_LLVM_ECLASS=1
fi
