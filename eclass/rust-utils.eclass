# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rust-utils.eclass
# @MAINTAINER:
# rust@gentoo.org
# @AUTHOR:
# gibix <gibix@riseup.net>
# A utility eclass providing functions to query rust implementations.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.
#
# CREDITS: has been hardly-inspired by python*.class

case "${EAPI:-0}" in
	6|7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS-VARIABLE: _RUST_ALL_IMPLS
# @INTERNAL
# @DESCRIPTION:
# All supported Rust implementations, most preferred last.
# Keep in sync with _rust_impl_supported and _rust_package_dep
_RUST_ALL_IMPLS=(
	rust1_25
	rust1_26
	rust1_27
)
readonly _RUST_ALL_IMPLS

# @FUNCTION: _rust_impl_supported
# @USAGE: <impl>
# @INTERNAL
# @DESCRIPTION:
# Check whether the implementation <impl> (RUST_COMPAT-form)
# is still supported.
#
# Returns 0 if the implementation is valid and supported. If it is
# unsupported, returns 1 -- and the caller should ignore the entry.
# If it is invalid, dies with an appopriate error messages.
_rust_impl_supported() {
	local impl=${1}

	case "${impl}" in
		"${_RUST_ALL_IMPLS[@]}")
			return 0
			;;
	esac

	return 1
}

# @FUNCTION: rust_export
# @USAGE: <impl>
# @INTERNAL
# @DESCRIPTION:
# Export cargo build config (RUSTC)
# TODO: best match
rust_export() {
	local impl

	case "${1}" in
		rust*)
			impl=${1/rust/rustc-}
			impl=${impl/_/.}
			shift
			;;
		*)
			die "rust export called without a valid rust implementation"
			;;
	esac

	export RUSTC="$(ls /usr/bin/${impl}.[0-9])"

	if [ ${#MULTIBUILD_VARIANTS[*]} -gt 1 ]; then
		export RUST_ROOT="/usr/$(get_libdir)/$(ls /usr/$(get_libdir) | grep ${impl/rustc/rust})"
	else
		export RUST_ROOT="/usr"
	fi

}

# @FUNCTION: rust_package_dep
# @USAGE: <impl>
# @INTERNAL
# @DESCRIPTION:
# Return rust dependency in precise format
rust_package_dep() {
	case ${1} in
		rust1_25)
			echo "=virtual/rust-1.25*"
			;;
		rust1_26)
			echo "=virtual/rust-1.26*"
			;;
		rust1_27)
			echo "=virtual/rust-1.27*"
			;;
		*)
			die "Invalid implementation: ${impl}"
	esac
}

# @FUNCTION: _rust_set_impls
# @INTERNAL
# @DESCRIPTION:
# Check RUST_COMPAT for well-formedness and validity, if RUST_COMPAT
# is not used looks to _RUST_ALL_IMPLS then set two global variables:
#
# - _RUST_SUPPORTED_IMPLS containing valid implementations supported
#   by the ebuild (RUST_COMPAT),
#
# - and _RUST_UNSUPPORTED_IMPLS containing valid implementations that
#   are not supported by the ebuild.
#
_rust_set_impls() {
	local i supp=() unsupp=()

	if ! declare -p RUST_COMPAT &>/dev/null; then
		for i in "${_RUST_ALL_IMPLS[@]}"; do
			supp+=( "${i}" )
		done
	else
		if [[ $(declare -p RUST_COMPAT) != "declare -a"* ]]; then
			die 'RUST_COMPAT must be an array.'
		fi

		for i in "${RUST_COMPAT[@]}"; do
			# trigger validity checks
			_rust_impl_supported "${i}"
		done

		for i in "${_RUST_ALL_IMPLS[@]}"; do
			if has "${i}" "${RUST_COMPAT[@]}"; then
				supp+=( "${i}" )
			else
				unsupp+=( "${i}" )
			fi
		done
	fi

	if [[ ! ${supp[@]} ]]; then
		die "No supported implementation in RUST_COMPAT."
	fi

	if [[ ${_RUST_SUPPORTED_IMPLS[@]} ]]; then
		# set once already, verify integrity
		if [[ ${_RUST_SUPPORTED_IMPLS[@]} != ${supp[@]} ]]; then
			eerror "Supported impls (RUST_COMPAT) changed between inherits!"
			eerror "Before: ${_RUST_SUPPORTED_IMPLS[*]}"
			eerror "Now   : ${supp[*]}"
			die "_RUST_SUPPORTED_IMPLS integrity check failed"
		fi
		if [[ ${_RUST_UNSUPPORTED_IMPLS[@]} != ${unsupp[@]} ]]; then
			eerror "Unsupported impls changed between inherits!"
			eerror "Before: ${_RUST_UNSUPPORTED_IMPLS[*]}"
			eerror "Now   : ${unsupp[*]}"
			die "_RUST_UNSUPPORTED_IMPLS integrity check failed"
		fi
	else
		_RUST_SUPPORTED_IMPLS=( "${supp[@]}" )
		_RUST_UNSUPPORTED_IMPLS=( "${unsupp[@]}" )
		readonly _RUST_SUPPORTED_IMPLS _RUST_UNSUPPORTED_IMPLS
	fi
}
