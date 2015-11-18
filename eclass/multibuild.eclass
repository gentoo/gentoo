# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: multibuild.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @BLURB: A generic eclass for building multiple variants of packages.
# @DESCRIPTION:
# The multibuild eclass aims to provide a generic framework for building
# multiple 'variants' of a package (e.g. multilib, Python
# implementations).

case "${EAPI:-0}" in
	0|1|2|3)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	4|5|6)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_MULTIBUILD} ]]; then

# @ECLASS-VARIABLE: MULTIBUILD_VARIANTS
# @DESCRIPTION:
# An array specifying all enabled variants which multibuild_foreach*
# can execute the process for.
#
# In ebuild, it can be set in global scope. Eclasses should set it
# locally in function scope to support nesting properly.
#
# Example:
# @CODE
# python_foreach_impl() {
#	local MULTIBUILD_VARIANTS=( python{2_5,2_6,2_7} ... )
#	multibuild_foreach_variant python_compile
# }
# @CODE

# @ECLASS-VARIABLE: MULTIBUILD_VARIANT
# @DESCRIPTION:
# The current variant which the function was executed for.
#
# Example value:
# @CODE
# python2_6
# @CODE

# @ECLASS-VARIABLE: MULTIBUILD_ID
# @DESCRIPTION:
# The unique identifier for a multibuild run. In a simple run, it is
# equal to MULTIBUILD_VARIANT. In a nested multibuild environment, it
# contains the complete selection tree.
#
# It can be used to create variant-unique directories and files.
#
# Example value:
# @CODE
# amd64-double
# @CODE

# @ECLASS-VARIABLE: BUILD_DIR
# @DESCRIPTION:
# The current build directory. In global scope, it is supposed
# to contain an 'initial' build directory. If unset, ${S} is used.
#
# multibuild_foreach_variant() sets BUILD_DIR locally
# to variant-specific build directories based on the initial value
# of BUILD_DIR.
#
# Example value:
# @CODE
# ${WORKDIR}/foo-1.3-python2_6
# @CODE

# @FUNCTION: multibuild_foreach_variant
# @USAGE: [<argv>...]
# @DESCRIPTION:
# Run the passed command repeatedly for each of the enabled package
# variants.
#
# Each of the runs will have variant-specific BUILD_DIR set, and output
# teed to a separate log in ${T}.
#
# The function returns 0 if all commands return 0, or the first non-zero
# exit status otherwise. However, it performs all the invocations
# nevertheless. It is preferred to call 'die' inside of the passed
# function.
multibuild_foreach_variant() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MULTIBUILD_VARIANTS} ]] \
		|| die "MULTIBUILD_VARIANTS need to be set"

	local bdir=${BUILD_DIR:-${S}}

	# Avoid writing outside WORKDIR if S=${WORKDIR}.
	[[ ${bdir%%/} == ${WORKDIR%%/} ]] && bdir=${WORKDIR}/build

	local prev_id=${MULTIBUILD_ID:+${MULTIBUILD_ID}-}
	local ret=0 lret=0 v

	debug-print "${FUNCNAME}: initial build_dir = ${bdir}"

	for v in "${MULTIBUILD_VARIANTS[@]}"; do
		local MULTIBUILD_VARIANT=${v}
		local MULTIBUILD_ID=${prev_id}${v}
		local BUILD_DIR=${bdir%%/}-${v}

		_multibuild_run() {
			# find the first non-private command
			local i=1
			while [[ ${!i} == _* ]]; do
				(( i += 1 ))
			done

			[[ ${i} -le ${#} ]] && einfo "${v}: running ${@:${i}}"
			"${@}"
		}

		_multibuild_run "${@}" \
			> >(exec tee -a "${T}/build-${MULTIBUILD_ID}.log") 2>&1
		lret=${?}
	done
	[[ ${ret} -eq 0 && ${lret} -ne 0 ]] && ret=${lret}

	return ${ret}
}

# @FUNCTION: multibuild_parallel_foreach_variant
# @USAGE: [<argv>...]
# @DESCRIPTION:
# Run the passed command repeatedly for each of the enabled package
# variants. This used to run the commands in parallel but now it's
# just a deprecated alias to multibuild_foreach_variant.
#
# The function returns 0 if all commands return 0, or the first non-zero
# exit status otherwise. However, it performs all the invocations
# nevertheless. It is preferred to call 'die' inside of the passed
# function.
multibuild_parallel_foreach_variant() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${EAPI} == [45] ]] || die "${FUNCNAME} is banned in EAPI ${EAPI}"

	multibuild_foreach_variant "${@}"
}

# @FUNCTION: multibuild_for_best_variant
# @USAGE: [<argv>...]
# @DESCRIPTION:
# Run the passed command once, for the best of the enabled package
# variants.
#
# The run will have a proper, variant-specificBUILD_DIR set, and output
# teed to a separate log in ${T}.
#
# The function returns command exit status.
multibuild_for_best_variant() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${MULTIBUILD_VARIANTS} ]] \
		|| die "MULTIBUILD_VARIANTS need to be set"

	# bash-4.1 can't handle negative subscripts
	local MULTIBUILD_VARIANTS=(
		"${MULTIBUILD_VARIANTS[$(( ${#MULTIBUILD_VARIANTS[@]} - 1 ))]}"
	)
	multibuild_foreach_variant "${@}"
}

# @FUNCTION: multibuild_copy_sources
# @DESCRIPTION:
# Create per-variant copies of source tree. The source tree is assumed
# to be in ${BUILD_DIR}, or ${S} if the former is unset. The copies will
# be placed in directories matching BUILD_DIRs used by
# multibuild_foreach().
multibuild_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local _MULTIBUILD_INITIAL_BUILD_DIR=${BUILD_DIR:-${S}}

	einfo "Will copy sources from ${_MULTIBUILD_INITIAL_BUILD_DIR}"

	local cp_args=()
	if cp --reflink=auto --version &>/dev/null; then
		# enable reflinking if possible to make this faster
		cp_args+=( --reflink=auto )
	fi

	_multibuild_create_source_copy() {
		einfo "${MULTIBUILD_VARIANT}: copying to ${BUILD_DIR}"
		cp -pr "${cp_args[@]}" \
			"${_MULTIBUILD_INITIAL_BUILD_DIR}" "${BUILD_DIR}" || die
	}

	multibuild_foreach_variant _multibuild_create_source_copy
}

# @FUNCTION: run_in_build_dir
# @USAGE: <argv>...
# @DESCRIPTION:
# Run the given command in the directory pointed by BUILD_DIR.
run_in_build_dir() {
	debug-print-function ${FUNCNAME} "${@}"
	local ret

	[[ ${#} -ne 0 ]] || die "${FUNCNAME}: no command specified."
	[[ ${BUILD_DIR} ]] || die "${FUNCNAME}: BUILD_DIR not set."

	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	"${@}"
	ret=${?}
	popd >/dev/null || die

	return ${ret}
}

# @FUNCTION: multibuild_merge_root
# @USAGE: <src-root> <dest-root>
# @DESCRIPTION:
# Merge the directory tree (fake root) from <src-root> to <dest-root>
# (the real root). Both directories have to be real, absolute paths
# (i.e. including ${D}). Source root will be removed.
multibuild_merge_root() {
	local src=${1}
	local dest=${2}

	local ret

	if use userland_BSD; then
		# Most of BSD variants fail to copy broken symlinks, #447370
		# also, they do not support --version

		tar -C "${src}" -f - -c . \
			| tar -x -f - -C "${dest}"
		[[ ${PIPESTATUS[*]} == '0 0' ]]
		ret=${?}
	else
		local cp_args=()

		if cp -a --version &>/dev/null; then
			cp_args+=( -a )
		else
			cp_args+=( -P -R -p )
		fi

		if cp --reflink=auto --version &>/dev/null; then
			# enable reflinking if possible to make this faster
			cp_args+=( --reflink=auto )
		fi

		cp "${cp_args[@]}" "${src}"/. "${dest}"/
		ret=${?}
	fi

	if [[ ${ret} -ne 0 ]]; then
		die "${MULTIBUILD_VARIANT:-(unknown)}: merging image failed."
	fi

	rm -rf "${src}"
}

_MULTIBUILD=1
fi
