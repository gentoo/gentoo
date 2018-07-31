# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rust.eclass
# @MAINTAINER:
# rust@gentoo.org
# @AUTHOR:
# gibix <gibix@riseup.net>
#
# A common eclass providing helper functions to build and install
# packages multiple rust implementations.
#
# CREDITS: has been hardly-inspired by python*.class

case "${EAPI:-0}" in
	6|7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

inherit multibuild rust-utils

# This is the core funcion for exported variables in the ebuild.
_rust_set_globals() {
	local deps

	_rust_set_impls

	local requse=""
	[ ${#flags[@]} -gt 0 ] && requse="|| ( ${flags[*]} )"

	for i in "${_RUST_SUPPORTED_IMPLS[@]}"; do
		deps+="rust_targets_${i}? ( $(rust_package_dep ${i}) ) "
	done

	local flags=( "${_RUST_SUPPORTED_IMPLS[@]/#/rust_targets_}" )
	export RUST_DEPS=${deps}

	RDEPEND=${deps}
	REQUIRED_USE=${requse}
	IUSE=${flags[*]}
	# TODO
	# RUST_USEDEP =
}
_rust_set_globals
unset -f _rust_set_globals

# @ECLASS-VARIABLE: RUST_COMPAT
# @DESCRIPTION:
# This variable contains a list of Rust implementations the package
# supports. It must be set before the `inherit' call. It has to be
# an array.
#
# Example:
# @CODE
# RUST_COMPAT=( rust1_26, rust1_27 )
# @CODE
#

# @FUNCTION: rust_setup
# @DESCRIPTION:
# Checks for conflicts between RUST_COMPAT and RUST_SUPPORTED_IMPLS
rust_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	local rustcompat=( "${RUST_COMPAT[@]}" )

	# (reverse iteration -- newest impl first)
	local found
	for (( i = ${#_RUST_SUPPORTED_IMPLS[@]} - 1; i >= 0; i-- )); do
		local impl=${_RUST_SUPPORTED_IMPLS[i]}

		# check RUST_COMPAT
		has "${impl}" "${rustcompat[@]}" || continue

		found=1
		break
	done
}

rust_build_foreach_variant() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS
	_rust_obtain_impls

	multibuild_foreach_variant _rust_multibuild_wrapper "${@}"
}

_rust_obtain_impls() {
	MULTIBUILD_VARIANTS=()

	local impl
	for impl in "${_RUST_SUPPORTED_IMPLS[@]}"; do
		use "rust_targets_${impl}" && MULTIBUILD_VARIANTS+=( "${impl}" )
	done
}

_rust_multibuild_wrapper() {
	rust_export ${MULTIBUILD_VARIANT}

	"${@}"
}
