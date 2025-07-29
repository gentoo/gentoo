# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: rust.eclass
# @MAINTAINER:
# Matt Jolly <kangie@gentoo.org>
# @AUTHOR:
# Matt Jolly <kangie@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Utility functions to build against slotted Rust
# @DESCRIPTION:
# An eclass to reliably depend on a Rust or Rust/LLVM combination for
# a given Rust slot. To use the eclass:
#
# 1. If required, set RUST_{MAX,MIN}_VER to the range of supported slots.
#
# 2. If rust is optional, set RUST_OPTIONAL to a non-empty value then
#    appropriately gate ${RUST_DEPEND}.
#
# 3. Use rust_pkg_setup, get_rust_prefix, or RUST_SLOT.

# Example use for a package supporting Rust 1.72.0 to 1.82.0:
# @CODE
#
# RUST_MAX_VER="1.82.0"
# RUST_MIN_VER="1.72.0"
#
# inherit meson rust
#
# # only if you need to define one explicitly
# pkg_setup() {
#	rust_pkg_setup
#	do-something-else
# }
# @CODE
#
# Example for a package needing Rust w/ a specific target:
# @CODE
# RUST_REQ_USE='clippy'
# RUST_MULTILIB=1
#
# inherit multilib-minimal meson rust
#
# @CODE

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_RUST_ECLASS} ]]; then
_RUST_ECLASS=1

if [[ -n ${RUST_NEEDS_LLVM} ]]; then
	inherit llvm-r1
fi

if [[ -n ${RUST_MULTILIB} ]]; then
	inherit multilib-build
	RUST_REQ_USE="${RUST_REQ_USE+${RUST_REQ_USE},}${MULTILIB_USEDEP}"
fi

# == internal control knobs ==

# @ECLASS_VARIABLE: _RUST_LLVM_MAP
# @INTERNAL
# @DESCRIPTION:
# Definitive list of Rust slots and the associated LLVM slot, newest first.
declare -A -g -r _RUST_LLVM_MAP=(
	["9999"]=20
	["1.89.0"]=20
	["1.88.0"]=20
	["1.87.0"]=20
	["1.86.0"]=19
	["1.85.1"]=19
	["1.85.0"]=19
	["1.84.1"]=19
	["1.84.0"]=19
	["1.83.0"]=19
	["1.82.0"]=19
	["1.81.0"]=18
	["1.80.1"]=18
	["1.79.0"]=18
	["1.78.0"]=18
	["1.77.1"]=17
	["1.76.0"]=17
	["1.75.0"]=17
	["1.74.1"]=17
)

# @ECLASS_VARIABLE: _RUST_SLOTS_ORDERED
# @INTERNAL
# @DESCRIPTION:
# Array of Rust slots, newest first.
# While _RUST_LLVM_MAP stores useful info about the relationship between Rust and LLVM slots,
# this array is used to store the Rust slots in a more convenient order for iteration.
declare -a -g -r _RUST_SLOTS_ORDERED=(
	"9999"
	"1.89.0"
	"1.88.0"
	"1.87.0"
	"1.86.0"
	"1.85.1"
	"1.85.0"
	"1.84.1"
	"1.84.0"
	"1.83.0"
	"1.82.0"
	"1.81.0"
	"1.80.1"
	"1.79.0"
	"1.78.0"
	"1.77.1"
	"1.76.0"
	"1.75.0"
	"1.74.1"
)

# == user control knobs ==

# @ECLASS_VARIABLE: ERUST_SLOT_OVERRIDE
# @USER_VARIABLE
# @DESCRIPTION:
# Specify the version (slot) of Rust to be used by the package. This is
# useful for troubleshooting and debugging purposes. If unset, the newest
# acceptable Rust version will be used. May be combined with ERUST_TYPE_OVERRIDE.
# This variable must not be set in ebuilds.

# @ECLASS_VARIABLE: ERUST_TYPE_OVERRIDE
# @USER_VARIABLE
# @DESCRIPTION:
# Specify the type of Rust to be used by the package from options:
# 'source' or 'binary' (-bin). This is useful for troubleshooting and
# debugging purposes. If unset, the standard eclass logic will be used
# to determine the type of Rust to use (i.e. prefer source if binary
# is also available). May be combined with ERUST_SLOT_OVERRIDE.
# This variable must not be set in ebuilds.

# == control variables ==

# @ECLASS_VARIABLE: RUST_MAX_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Highest Rust slot supported by the package. Needs to be set before
# rust_pkg_setup is called. If unset, no upper bound is assumed.

# @ECLASS_VARIABLE: RUST_MIN_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Lowest Rust slot supported by the package. Needs to be set before
# rust_pkg_setup is called. If unset, no lower bound is assumed.

# @ECLASS_VARIABLE: RUST_SLOT
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The selected Rust slot for building, from the range defined by
# RUST_MAX_VER and RUST_MIN_VER. This is set by rust_pkg_setup.

# @ECLASS_VARIABLE: RUST_TYPE
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# The selected Rust type for building, either 'source' or 'binary'.
# This is set by rust_pkg_setup.

# @ECLASS_VARIABLE: RUST_NEEDS_LLVM
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value generate a llvm_slot_${llvm_slot}? gated
# dependency block for rust slots in LLVM_COMPAT. This is useful for
# packages that need a tight coupling between Rust and LLVM but don't
# really care _which_ version of Rust is selected. Combine with
# RUST_MAX_VER and RUST_MIN_VER to limit the range of Rust versions
# that are acceptable. Will `die` if llvm-r1 is not inherited or
# an invalid combination of RUST and LLVM slots is detected; this probably
# means that a LLVM slot in LLVM_COMPAT has had all of its Rust slots filtered.

# @ECLASS_VARIABLE: RUST_MULTILIB
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value insert MULTILIB_USEDEP into the generated
# Rust dependency. For this to be useful inherit a multilib eclass and
# configure the appropriate phase functions.

# @ECLASS_VARIABLE: RUST_DEPEND
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# This is an eclass-generated Rust dependency string, filtered by
# RUST_MAX_VER and RUST_MIN_VER. If RUST_NEEDS_LLVM is set, this
# is grouped and gated by an appropriate `llvm_slot_x` USE for all
# implementations listed in LLVM_COMPAT.

# @ECLASS_VARIABLE: RUST_OPTIONAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value, the Rust dependency will not be added
# to BDEPEND. This is useful for packages that need to gate rust behind
# certain USE themselves.

# @ECLASS_VARIABLE: RUST_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Additional USE-dependencies to be added to the Rust dependency.
# This is useful for packages that need to depend on specific Rust
# features, like clippy or rustfmt. The variable is expanded before
# being used in the Rust dependency.

# == global metadata ==

_rust_set_globals() {
	debug-print-function ${FUNCNAME} "$@"

	# If RUST_MIN_VER is older than our oldest slot we'll just set it to that
	# internally so we don't have to worry about it later.
	if ver_test "${_RUST_SLOTS_ORDERED[-1]}" -gt "${RUST_MIN_VER:-0}"; then
		RUST_MIN_VER="${_RUST_SLOTS_ORDERED[-1]}"
	fi

	# and if it falls between slots we'll set it to the next highest slot
	# We can skip this we match a slot exactly.
	if [[ "${_RUST_SLOTS_ORDERED[@]}" != *"${RUST_MIN_VER}"* ]]; then
		local i
		for (( i=${#_RUST_SLOTS_ORDERED[@]}-1 ; i>=0 ; i-- )); do
			if ver_test "${_RUST_SLOTS_ORDERED[$i]}" -gt "${RUST_MIN_VER}"; then
				RUST_MIN_VER="${_RUST_SLOTS_ORDERED[$i]}"
				break
			fi
		done
	fi

	if [[ -n "${RUST_MAX_VER}" && -n "${RUST_MIN_VER}" ]]; then
		if ! ver_test "${RUST_MAX_VER}" -ge "${RUST_MIN_VER}"; then
			die "RUST_MAX_VER must not be older than RUST_MIN_VER"
		fi
	fi

	local slot
	# Try to keep this in order of newest to oldest
	for slot in "${_RUST_SLOTS_ORDERED[@]}"; do
		if ver_test "${slot}" -le "${RUST_MAX_VER:-9999}" &&
			ver_test "${slot}" -ge "${RUST_MIN_VER:-0}"
			then
				_RUST_SLOTS+=( "${slot}" )
		fi
	done

	_RUST_SLOTS=( "${_RUST_SLOTS[@]}" )
	readonly _RUST_SLOTS

	local rust_dep=()
	local llvm_slot
	local rust_slot
	local usedep="${RUST_REQ_USE+[${RUST_REQ_USE}]}"

	# If we're not using LLVM, we can just generate a simple Rust dependency
	if [[ -z "${RUST_NEEDS_LLVM}" ]]; then
		rust_dep=( "|| (" )
		# We can be more flexible if we generate a simpler, open-ended dependency
		# when we don't have a max version set.
		if [[ -z "${RUST_MAX_VER}" ]]; then
			rust_dep+=(
				">=dev-lang/rust-bin-${RUST_MIN_VER}:*${usedep}"
				">=dev-lang/rust-${RUST_MIN_VER}:*${usedep}"
			)
		else
			# depend on each slot between RUST_MIN_VER and RUST_MAX_VER; it's a bit specific but
			# won't hurt as we only ever add newer Rust slots.
			for slot in "${_RUST_SLOTS[@]}"; do
				rust_dep+=(
					"dev-lang/rust-bin:${slot}${usedep}"
					"dev-lang/rust:${slot}${usedep}"
				)
			done
		fi
		rust_dep+=( ")" )
		RUST_DEPEND="${rust_dep[*]}"
	else
		for llvm_slot in "${LLVM_COMPAT[@]}"; do
			# Quick sanity check to make sure that the llvm slot is valid for Rust.
			if [[ "${_RUST_LLVM_MAP[@]}" == *"${llvm_slot}"* ]]; then
				# We're working a bit backwards here; iterate over _RUST_LLVM_MAP, check the
				# LLVM slot, and if it matches add this to a new array because it may (and likely will)
				# match multiple Rust slots. We already filtered Rust max/min slots.
				# We always have a usedep for the LLVM slot, append `,RUST_REQ_USE` if it's set
				usedep="[llvm_slot_${llvm_slot}${RUST_REQ_USE+,${RUST_REQ_USE}}]"
				local slot_dep_content=()
				for rust_slot in "${_RUST_SLOTS[@]}"; do
					if [[ "${_RUST_LLVM_MAP[${rust_slot}]}" == "${llvm_slot}" ]]; then
						slot_dep_content+=(
							"dev-lang/rust-bin:${rust_slot}${usedep}"
							"dev-lang/rust:${rust_slot}${usedep}"
						)
					fi
				done
				if [[ "${#slot_dep_content[@]}" -ne 0 ]]; then
					rust_dep+=( "llvm_slot_${llvm_slot}? ( || ( ${slot_dep_content[*]} ) )" )
				else
					die "${FUNCNAME}: no Rust slots found for LLVM slot ${llvm_slot}"
				fi
			fi
		done
		RUST_DEPEND="${rust_dep[*]}"
	fi

	readonly RUST_DEPEND
	if [[ -z ${RUST_OPTIONAL} ]]; then
		BDEPEND="${RUST_DEPEND}"
	fi
}
_rust_set_globals
unset -f _rust_set_globals

# == ebuild helpers ==

# @FUNCTION: _get_rust_slot
# @USAGE: [-b|-d]
# @DESCRIPTION:
# Find the newest Rust install that is acceptable for the package,
# and export its version (i.e. SLOT) and type (source or bin[ary])
# as RUST_SLOT and RUST_TYPE.
#
# If -b is specified, the checks are performed relative to BROOT,
# and BROOT-path is returned. -b is the default.
#
# If -d is specified, the checks are performed relative to ESYSROOT,
# and ESYSROOT-path is returned.
#
# If RUST_M{AX,IN}_VER is non-zero, then only Rust versions that
# are not newer or older than the specified slot(s) will be considered.
# Otherwise, all Rust versions are considered acceptable.
#
# If the `rust_check_deps()` function is defined within the ebuild, it
# will be called to verify whether a particular slot is acceptable.
# Within the function scope, RUST_SLOT and LLVM_SLOT will be defined.
#
# The function should return a true status if the slot is acceptable,
# false otherwise. If rust_check_deps() is not defined, the function
# defaults to checking whether a suitable Rust package is installed.
_get_rust_slot() {
	debug-print-function ${FUNCNAME} "$@"

	local hv_switch=-b
	while [[ ${1} == -* ]]; do
		case ${1} in
			-b|-d) hv_switch="${1}";;
			*) break;;
		esac
		shift
	done

	local max_slot
	if [[ -z "${RUST_MAX_VER}" ]]; then
		max_slot=
	else
		max_slot="${RUST_MAX_VER}"
	fi
	local slot
	local llvm_slot

	if [[ -n "${RUST_NEEDS_LLVM}" ]]; then
		local unique_slots=()
		local llvm_r1_slot
		# Associative array keys are unique, so let's use that to our advantage
		for llvm_slot in "${_RUST_LLVM_MAP[@]}"; do
			unique_slots["${llvm_slot}"]="1"
		done
		for llvm_slot in "${!unique_slots[@]}"; do
			if [[ "${LLVM_COMPAT[@]}" == *"${llvm_slot}"* ]]; then
				# We can check for the USE
				use "llvm_slot_${llvm_slot}" && llvm_r1_slot="${llvm_slot}"
			fi
		done
		if [[ -z "${llvm_r1_slot}" ]]; then
			die "${FUNCNAME}: no LLVM slot found"
		fi
	fi

	# iterate over known slots, newest first
	for slot in "${_RUST_SLOTS_ORDERED[@]}"; do
		llvm_slot="${_RUST_LLVM_MAP[${slot}]}"
		# skip higher slots
		if [[ -n "${max_slot}" ]]; then
			if ver_test "${slot}" -eq "${max_slot}"; then
				max_slot=
			elif ver_test "${slot}" -gt "${max_slot}"; then
				continue
			fi
		fi

		if [[ -n "${ERUST_SLOT_OVERRIDE}" && "${slot}" != "${ERUST_SLOT_OVERRIDE}" ]]; then
			continue
		fi

		# If we're in LLVM mode we can skip any slots that don't match the selected USE
		if [[ -n "${RUST_NEEDS_LLVM}" ]]; then
			if [[ "${llvm_slot}" != "${llvm_r1_slot}" ]]; then
				einfo "Skipping Rust ${slot} as it does not match llvm_slot_${llvm_r1_slot}"
				continue
			fi
		fi

		einfo "Checking whether Rust ${slot} is suitable ..."

		if declare -f rust_check_deps >/dev/null; then
			local RUST_SLOT="${slot}"
			local LLVM_SLOT="${_RUST_LLVM_MAP[${slot}]}"
			rust_check_deps && return
		else
			local usedep="${RUST_REQ_USE+[${RUST_REQ_USE}]}"
			# When checking for installed packages prefer the source package;
			# if effort was put into building it we should use it.
			local rust_pkgs
			case "${ERUST_TYPE_OVERRIDE}" in
				source)
					rust_pkgs=(
						"dev-lang/rust:${slot}${usedep}"
					)
					;;
				binary)
					rust_pkgs=(
						"dev-lang/rust-bin:${slot}${usedep}"
					)
					;;
				*)
					rust_pkgs=(
						"dev-lang/rust:${slot}${usedep}"
						"dev-lang/rust-bin:${slot}${usedep}"
					)
					;;
			esac
			local _pkg
			for _pkg in "${rust_pkgs[@]}"; do
				einfo " Checking for ${_pkg} ..."
				if has_version "${hv_switch}" "${_pkg}"; then
					export RUST_SLOT="${slot}"
					if [[ "${_pkg}" == "dev-lang/rust:${slot}${usedep}" ]]; then
						export RUST_TYPE="source"
					else
						export RUST_TYPE="binary"
					fi
					return
				fi
			done
		fi

		# We want to process the slot before escaping the loop if we've hit the minimum slot
		if ver_test "${slot}" -eq "${RUST_MIN_VER}"; then
			break
		fi
	done

	# max_slot should have been unset in the iteration
	if [[ -n "${max_slot}" ]]; then
		die "${FUNCNAME}: invalid max_slot=${max_slot}"
	fi

	local requirement_msg=""
	[[ -n "${RUST_MAX_VER}" ]] && requirement_msg+="<= ${RUST_MAX_VER} "
	[[ -n "${RUST_MIN_VER}" ]] && requirement_msg+=">= ${RUST_MIN_VER} "
	[[ -n "${RUST_REQ_USE}" ]] && requirement_msg+="with USE=${RUST_REQ_USE}"
	requirement_msg="${requirement_msg% }"
	die "No Rust matching requirements${requirement_msg:+ (${requirement_msg})} found installed!"
}

# @FUNCTION: get_rust_path
# @USAGE: prefix slot rust_type
# @DESCRIPTION:
# Given arguments of prefix, slot, and rust_type, return an appropriate path
# for the Rust install. The rust_type should be either "source"
# or "binary". If the rust_type is not one of these, the function
# will die.
get_rust_path() {
	debug-print-function ${FUNCNAME} "$@"

	local prefix="${1}"
	local slot="${2}"
	local rust_type="${3}"

	if [[ ${#} -ne 3 ]]; then
		die "${FUNCNAME}: invalid number of arguments"
	fi

	case ${rust_type} in
		source) echo "${prefix}/usr/lib/rust/${slot}/";;
		binary) echo "${prefix}/opt/rust-bin-${slot}/";;
		*) die "${FUNCNAME}: invalid rust_type=${rust_type}";;
	esac
}

# @FUNCTION: get_rust_prefix
# @USAGE: [-b|-d]
# @DESCRIPTION:
# Find the newest Rust install that is acceptable for the package,
# and print an absolute path to it. If both -bin and regular Rust
# are installed, the regular Rust is preferred.
#
# The options and behavior are the same as _get_rust_slot.
get_rust_prefix() {
	debug-print-function ${FUNCNAME} "$@"

	local prefix=${BROOT}
	[[ ${1} == -d ]] && prefix=${ESYSROOT}

	_get_rust_slot "$@"
	get_rust_path "${prefix}" "${RUST_SLOT}" "${RUST_TYPE}"
}

# @FUNCTION: rust_prepend_path
# @USAGE: <slot> <type>
# @DESCRIPTION:
# Prepend the path to the specified Rust to PATH and re-export it.
rust_prepend_path() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -ne 2 ]] && die "Usage: ${FUNCNAME} <slot> <type>"
	export PATH="$(get_rust_path "${BROOT}" "$@")/bin:${PATH}"
}

# @FUNCTION: rust_pkg_setup
# @DESCRIPTION:
# Prepend the appropriate executable directory for the newest
# acceptable Rust slot to the PATH. If used with LLVM, an appropriate
# `llvm-r1_pkg_setup` call should be made in addition to this function.
# For path determination logic, please see the get_rust_prefix documentation.
#
# The highest acceptable Rust slot can be set in the RUST_MAX_VER variable.
# If it is unset or empty, any slot is acceptable.
#
# The lowest acceptable Rust slot can be set in the RUST_MIN_VER variable.
# If it is unset or empty, any slot is acceptable.
#
# `CARGO` and `RUSTC` variables are set for the selected slot and exported.
#
# The PATH manipulation is only done for source builds. The function
# is a no-op when installing a binary package.
#
# If any other behavior is desired, the contents of the function
# should be inlined into the ebuild and modified as necessary.
rust_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${MERGE_TYPE} != binary ]]; then
		_get_rust_slot -b
		rust_prepend_path "${RUST_SLOT}" "${RUST_TYPE}"
		local prefix=$(get_rust_path "${BROOT}" "${RUST_SLOT}" "${RUST_TYPE}")
		CARGO="${prefix}bin/cargo"
		RUSTC="${prefix}bin/rustc"
		export CARGO RUSTC
		einfo "Using Rust ${RUST_SLOT} (${RUST_TYPE})"
	fi
}

fi

EXPORT_FUNCTIONS pkg_setup
