# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm-r2.eclass
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
# 3. Use llvm-r2_pkg_setup, llvm_chost_setup, llvm_cbuild_setup,
#    get_llvm_prefix or LLVM_SLOT.
#
# The eclass sets IUSE and REQUIRED_USE.  The flag corresponding
# to the newest supported stable LLVM slot (or the newest testing,
# if no stable slots are supported) is enabled by default.
#
# Note that the eclass aims for a best-effort support of CHOST builds
# (i.e. compiling/linking against LLVM) and CBUILD use (i.e. calling
# LLVM tools at build time).  You need to determine what the package
# in question needs, and put the appropriate packages in DEPEND and/or
# BDEPEND appropriately.
#
# Example:
# @CODE
# LLVM_COMPAT=( {16..18} )
#
# inherit llvm-r2
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

if [[ -z ${_LLVM_R2_ECLASS} ]]; then
_LLVM_R2_ECLASS=1

inherit llvm-utils multilib

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
_LLVM_NEWEST_STABLE=21

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

# @FUNCTION: generate_llvm_config
# @DESCRIPTION:
# Output a llvm-config compatible script that yields paths specific
# to the requested LLVM version.
generate_llvm_config() {
	debug-print-function ${FUNCNAME} "$@"

	local bindir=$(get_llvm_prefix -b)/bin
	[[ ! -d ${bindir} ]] && bindir=

	local prefix=$(get_llvm_prefix -d)
	local includedir=${prefix}/include
	local libdir=${prefix}/$(get_libdir)
	local cmake_conf=${libdir}/cmake/llvm/LLVMConfig.cmake
	if [[ ! -f ${cmake_conf} ]]; then
		cat <<-EOF
			#!/usr/bin/env sh
			echo "LLVM ${LLVM_SLOT} not installed for ABI=${ABI}" >&2
			exit 127
		EOF
		return
	fi

	local version=$(
		sed -ne 's:set(LLVM_PACKAGE_VERSION \(.*\)):\1:p' "${cmake_conf}" || die
	)
	[[ -n ${version} ]] || die
	local cppdefs=$(
		sed -ne 's:set(LLVM_DEFINITIONS "\(.*\)"):\1:p' "${cmake_conf}" || die
	)
	[[ -n ${cppdefs} ]] || die
	local targets=$(
		sed -ne 's:set(LLVM_TARGETS_TO_BUILD \(.*\)):\1:p' "${cmake_conf}" || die
	)
	[[ -n ${targets} ]] || die
	local libs=$(
		sed -ne 's:set(LLVM_AVAILABLE_LIBS \(.*\)):\1:p' "${cmake_conf}" || die
	)
	[[ -n ${libs} ]] || die
	local target_triple=$(
		sed -ne 's:set(LLVM_TARGET_TRIPLE "\(.*\)"):\1:p' "${cmake_conf}" || die
	)
	[[ -n ${target_triple} ]] || die

	readarray -d';' -t targets <<<"${targets}"
	readarray -d';' -t libs <<<"${libs}"
	# easier than parsing CMake booleans
	local assertions=OFF
	[[ ${cppdefs} == *-D_DEBUG* ]] && assertions=ON
	# major + suffix
	local shlib_name=LLVM-${version%%.*}
	[[ ${version} == *git* ]] && shlib_name+="git${version##*git}"

	local components=(
		"${libs[@]#LLVM}" "${targets[@]}"
		# special component groups (grep for add_llvm_component_group)
		all all-targets engine native nativecodegen
	)

	cat <<-EOF
		#!/usr/bin/env sh

		echo "\${0} \${*}" >> "${T}/llvm-config-calls.txt"

		do_echo() {
			echo "  \${*}" >> "${T}/llvm-config-calls.txt"
			echo "\${@}"
		}

		for arg; do
			case \${arg} in
				--assertion-mode)
					do_echo "${assertions}"
					;;
				--bindir)
					if [ -n "${bindir}" ]; then
						do_echo "${bindir}"
					else
						do_echo "CBUILD LLVM not available" >&2
						exit 1
					fi
					;;
				--build-mode)
					do_echo RelWithDebInfo
					;;
				--build-system)
					do_echo cmake
					;;
				--cflags|--cppflags)
					do_echo "-I${includedir} ${cppdefs[*]}"
					;;
				--cmakedir)
					do_echo "${libdir}/cmake/llvm"
					;;
				--components)
					do_echo "${components[*],,}"
					;;
				--cxxflags)
					do_echo "-I${includedir} -std=c++17 ${cppdefs[*]}"
					;;
				--has-rtti)
					do_echo YES
					;;
				--host-target)
					do_echo "${target_triple}"
					;;
				--ignore-libllvm)
					# ignored
					;;
				--includedir)
					do_echo "${includedir}"
					;;
				--ldflags)
					do_echo "-L${libdir}"
					;;
				--libdir)
					do_echo "${libdir}"
					;;
				--libfiles)
					do_echo "${libdir}/lib${shlib_name}.so"
					;;
				--libnames)
					do_echo lib${shlib_name}.so
					;;
				--libs)
					do_echo "-l${shlib_name}"
					;;
				--link-shared|--link-static)
					# ignored
					;;
				--obj-root|--prefix)
					do_echo "${prefix}"
					;;
				--shared-mode)
					do_echo shared
					;;
				--system-libs)
					do_echo
					;;
				--targets-built)
					do_echo "${targets[*]}"
					;;
				--version)
					do_echo "${version}"
					;;
				-*)
					do_echo "Unsupported option: \${arg}" >&2
					exit 1
					;;
				*)
					# ignore components, we always return the dylib
					;;
			esac
		done
	EOF
}
# @FUNCTION: llvm_cbuild_setup
# @DESCRIPTION:
# Prepend the PATH for selected LLVM version in CBUILD.
#
# This function is meant to be used when the package in question uses
# LLVM tools at build time.  It is called automatically
# by llvm-r2_pkg_setup if LLVM is found installed in BROOT.
#
# Note that llvm-config from this path must not be used to build against
# LLVM, as that will break cross-compilation.
llvm_cbuild_setup() {
	debug-print-function ${FUNCNAME} "$@"

	local broot_prefix=$(get_llvm_prefix -b)
	einfo "Using ${broot_prefix} for CBUILD LLVM ${LLVM_SLOT}"
	[[ -d ${broot_prefix}/bin ]] ||
		die "LLVM ${LLVM_SLOT} not found installed in BROOT (expected: ${broot_prefix}/bin)"

	llvm_fix_clang_version CC CPP CXX
	# keep in sync with profiles/features/llvm/make.defaults!
	llvm_fix_tool_path ADDR2LINE AR AS LD NM OBJCOPY OBJDUMP RANLIB
	llvm_fix_tool_path READELF STRINGS STRIP
	llvm_prepend_path -b "${LLVM_SLOT}"
}

# @FUNCTION: llvm_chost_setup
# @DESCRIPTION:
# Set the environment for finding selected LLVM slot installed
# for CHOST.  Create llvm-config wrappers to satisfy legacy lookups.
#
# This function is meant to be used when the package in question uses
# LLVM compiles against and links to LLVM.  It is called automatically
# by llvm-r2_pkg_setup if LLVM is found installed in ESYSROOT.
#
# Note that the generated llvm-config may refer to CBUILD installation
# of LLVM via --bindir, if it is found available.
llvm_chost_setup() {
	debug-print-function ${FUNCNAME} "$@"

	local esysroot_prefix=$(get_llvm_prefix -d)
	einfo "Using ${esysroot_prefix} for CHOST LLVM ${LLVM_SLOT}"
	[[ -d ${esysroot_prefix} ]] ||
		die "LLVM ${LLVM_SLOT} not found installed in ESYSROOT (expected: ${esysroot_prefix})"

	# satisfies find_package() in CMake
	export LLVM_ROOT="${esysroot_prefix}"
	export Clang_ROOT="${esysroot_prefix}"
	export LLD_ROOT="${esysroot_prefix}"
	export MLIR_ROOT="${esysroot_prefix}"
	export Polly_ROOT="${esysroot_prefix}"

	# satisfies llvm-config calls, e.g. from meson
	export PATH="${T}/llvm-bin:${PATH}"
	mkdir "${T}"/llvm-bin || die
	# we need to generate it per-ABI, since libdir changes
	local ABI
	for ABI in $(get_all_abis); do
		local path="${T}/llvm-bin/$(get_abi_CHOST)-llvm-config"
		generate_llvm_config > "${path}" || die
		chmod +x "${path}" || die
	done
	ln -s "$(get_abi_CHOST)-llvm-config" "${T}/llvm-bin/llvm-config" || die
}

# @FUNCTION: llvm-r2_pkg_setup
# @DESCRIPTION:
# Handle all supported setup actions automatically.  If LLVM is found
# installed for CBUILD, call llvm_cbuild_setup.  If it is found
# installed for CHOST, call llvm_chost_setup.
#
# This function is a no-op when installing a binary package.
#
# Note that this function is not exported if LLVM_OPTIONAL is set.
# In that case, it needs to be called manually.
llvm-r2_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ -z ${LLVM_SLOT} ]] && die "LLVM_SLOT unset (broken USE_EXPAND?)"

		if [[ -d $(get_llvm_prefix -b)/bin ]]; then
			llvm_cbuild_setup
		fi

		if [[ -d $(get_llvm_prefix -d) ]]; then
			llvm_chost_setup
		fi
	fi
}

fi

if [[ ! ${LLVM_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS pkg_setup
fi
