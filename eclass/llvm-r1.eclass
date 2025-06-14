# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm-r1.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: llvm-utils
# @BLURB: Provide LLVM_SLOT to build against slotted LLVM
# @DESCRIPTION:
# An eclass to reliably depend on a set of LLVM-related packages
# in a matching slot.  To use the eclass:
#
# 1. Set LLVM_COMPAT to the list of supported LLVM slots.
#
# 2. Use llvm_gen_dep and/or LLVM_USEDEP to add appropriate
#    dependencies.
#
# 3. Use llvm-r1_pkg_setup, get_llvm_prefix or LLVM_SLOT.
#
# The eclass sets IUSE and REQUIRED_USE.  The flag corresponding
# to the newest supported stable LLVM slot (or the newest testing,
# if no stable slots are supported) is enabled by default.
#
# Example:
# @CODE
# LLVM_COMPAT=( {16..18} )
#
# inherit llvm-r1
#
# DEPEND="
#   dev-libs/libfoo[${LLVM_USEDEP}]
#   $(llvm_gen_dep '
#     llvm-core/clang:${LLVM_SLOT}=
#     llvm-core/llvm:${LLVM_SLOT}=
#   ')
# "
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_LLVM_R1_ECLASS} ]]; then
_LLVM_R1_ECLASS=1

inherit llvm-utils

# == internal control knobs ==

# @ECLASS_VARIABLE: _LLVM_OLDEST_SLOT
# @INTERNAL
# @DESCRIPTION:
# Oldest supported LLVM slot.  This is used to automatically filter out
# unsupported LLVM_COMPAT values.
_LLVM_OLDEST_SLOT=15

# @ECLASS_VARIABLE: _LLVM_NEWEST_STABLE
# @INTERNAL
# @DESCRIPTION:
# The newest stable LLVM version.  Versions newer than that won't
# be automatically enabled via USE defaults.
_LLVM_NEWEST_STABLE=20

# == control variables ==

# @ECLASS_VARIABLE: LLVM_COMPAT
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# A list of LLVM slots supported by the package, oldest to newest.
#
# Example:
# @CODE
# LLVM_COMPAT=( {15..17} )
# @CODE

# @ECLASS_VARIABLE: LLVM_OPTIONAL
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value, disables setting REQUIRED_USE
# and exporting pkg_setup.  You have to add LLVM_REQUIRED_USE and call
# pkg_setup manually, with appropriate USE conditions.

# == global metadata ==

# @ECLASS_VARIABLE: LLVM_REQUIRED_USE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An eclass-generated REQUIRED_USE string that enforces selecting
# exactly one slot.  It LLVM_OPTIONAL is set, it needs to be copied
# into REQUIRED_USE, under appropriate USE conditions.  Otherwise,
# it is added automatically.

# @ECLASS_VARIABLE: LLVM_USEDEP
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# An eclass-generated USE dependency string that can be applied to other
# packages using the same eclass, to enforce a LLVM slot match.

_llvm_set_globals() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${LLVM_COMPAT@a} != *a* ]]; then
		die "LLVM_COMPAT must be set to an array before inheriting ${ECLASS}"
	fi

	local stable=() unstable=()
	local x
	for x in "${LLVM_COMPAT[@]}"; do
		if [[ ${x} -gt ${_LLVM_NEWEST_STABLE} ]]; then
			unstable+=( "${x}" )
		elif [[ ${x} -ge ${_LLVM_OLDEST_SLOT} ]]; then
			stable+=( "${x}" )
		fi
	done

	_LLVM_SLOTS=( "${stable[@]}" "${unstable[@]}" )
	if [[ ! ${_LLVM_SLOTS[@]} ]]; then
		die "LLVM_COMPAT does not contain any valid versions (all older than ${_LLVM_OLDEST_SLOT}?)"
	fi

	if [[ ${stable[@]} ]]; then
		# If there is at least one stable slot supported, then enable
		# the newest stable slot by default.
		IUSE="+llvm_slot_${stable[-1]}"
		unset 'stable[-1]'
	else
		# Otherwise, enable the "oldest" ~arch slot.  We really only
		# expect a single ~arch version, so this primarily prevents
		# defaulting to non-keyworded slots.
		IUSE="+llvm_slot_${unstable[0]}"
		unset 'unstable[0]'
	fi
	local nondefault=( "${stable[@]}" "${unstable[@]}" )
	IUSE+=" ${nondefault[*]/#/llvm_slot_}"

	local flags=( "${_LLVM_SLOTS[@]/#/llvm_slot_}" )
	LLVM_REQUIRED_USE="^^ ( ${flags[*]} )"
	local usedep_flags=${flags[*]/%/(-)?}
	LLVM_USEDEP=${usedep_flags// /,}
	readonly LLVM_REQUIRED_USE LLVM_USEDEP

	if [[ ! ${LLVM_OPTIONAL} ]]; then
		REQUIRED_USE=${LLVM_REQUIRED_USE}
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

# == metadata helpers ==

# @FUNCTION: llvm_gen_dep
# @USAGE: <dependency>
# @DESCRIPTION:
# Output a dependency block, repeating "<dependency>" conditionally
# to all llvm_slot_* USE flags.  Any occurences of '${LLVM_SLOT}'
# within the block will be substituted for the respective slot.
#
# Example:
# @CODE
# DEPEND="
#   $(llvm_gen_dep '
#     llvm-core/clang:${LLVM_SLOT}=
#     llvm-core/llvm:${LLVM_SLOT}=
#   ')
# "
# @CODE
llvm_gen_dep() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -ne 1 ]] && die "Usage: ${FUNCNAME} <dependency>"

	local dep=${1}

	local slot
	for slot in "${_LLVM_SLOTS[@]}"; do
		echo "llvm_slot_${slot}? ( ${dep//\$\{LLVM_SLOT\}/${slot}} )"
	done
}

# == ebuild helpers ==

# @FUNCTION: get_llvm_prefix
# @USAGE: [-b|-d]
# @DESCRIPTION:
# Output the path to the selected LLVM slot.
#
# With no option or "-d", the path is prefixed by ESYSROOT.  LLVM
# dependencies should be in DEPEND then.
#
# With "-b" option, the path is prefixed by BROOT. LLVM dependencies
# should be in BDEPEND then.
get_llvm_prefix() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -gt 1 ]] && die "Usage: ${FUNCNAME} [-b|-d]"

	local prefix
	case ${1--d} in
		-d)
			prefix=${ESYSROOT}
			;;
		-b)
			prefix=${BROOT}
			;;
		*)
			die "${FUNCNAME}: invalid option: ${1}"
			;;
	esac

	echo "${prefix}/usr/lib/llvm/${LLVM_SLOT}"
}

# @FUNCTION: llvm-r1_pkg_setup
# @DESCRIPTION:
# Prepend the appropriate executable directory for the selected LLVM
# slot to PATH.
#
# The PATH manipulation is only done for source builds. The function
# is a no-op when installing a binary package.
#
# If any other behavior is desired, the contents of the function
# should be inlined into the ebuild and modified as necessary.
#
# Note that this function is not exported if LLVM_OPTIONAL is set.
# In that case, it needs to be called manually.
llvm-r1_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ -z ${LLVM_SLOT} ]] && die "LLVM_SLOT unset (broken USE_EXPAND?)"

		llvm_fix_clang_version CC CPP CXX
		# keep in sync with profiles/features/llvm/make.defaults!
		llvm_fix_tool_path ADDR2LINE AR AS LD NM OBJCOPY OBJDUMP RANLIB
		llvm_fix_tool_path READELF STRINGS STRIP

		# Set LLVM_CONFIG to help Meson (bug #907965) but only do it
		# for empty ESYSROOT (as a proxy for "are we cross-compiling?").
		if [[ -z ${ESYSROOT} ]] ; then
			llvm_fix_tool_path LLVM_CONFIG
		fi

		llvm_prepend_path "${LLVM_SLOT}"
	fi
}

fi

if [[ ! ${LLVM_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS pkg_setup
fi
