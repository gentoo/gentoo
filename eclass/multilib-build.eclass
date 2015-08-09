# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: multilib-build.eclass
# @MAINTAINER:
# gx86-multilib team <multilib@gentoo.org>
# @AUTHOR:
# Author: Michał Górny <mgorny@gentoo.org>
# @BLURB: flags and utility functions for building multilib packages
# @DESCRIPTION:
# The multilib-build.eclass exports USE flags and utility functions
# necessary to build packages for multilib in a clean and uniform
# manner.
#
# Please note that dependency specifications for multilib-capable
# dependencies shall use the USE dependency string in ${MULTILIB_USEDEP}
# to properly request multilib enabled.

if [[ ! ${_MULTILIB_BUILD} ]]; then

# EAPI=4 is required for meaningful MULTILIB_USEDEP.
case ${EAPI:-0} in
	4|5) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit multibuild multilib

# @ECLASS-VARIABLE: _MULTILIB_FLAGS
# @INTERNAL
# @DESCRIPTION:
# The list of multilib flags and corresponding ABI values. If the same
# flag is reused for multiple ABIs (e.g. x86 on Linux&FreeBSD), multiple
# ABIs may be separated by commas.
#
# Please contact multilib before modifying this list. This way we can
# ensure that every *preliminary* work is done and the multilib can be
# extended safely.
_MULTILIB_FLAGS=(
	abi_x86_32:x86,x86_fbsd,x86_freebsd,x86_linux,x86_macos,x86_solaris
	abi_x86_64:amd64,amd64_fbsd,x64_freebsd,amd64_linux,x64_macos,x64_solaris
	abi_x86_x32:x32
	abi_mips_n32:n32
	abi_mips_n64:n64
	abi_mips_o32:o32
	abi_ppc_32:ppc,ppc_aix,ppc_macos
	abi_ppc_64:ppc64
	abi_s390_32:s390
	abi_s390_64:s390x
)

# @ECLASS-VARIABLE: MULTILIB_COMPAT
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of multilib ABIs supported by the ebuild. If unset, defaults to
# all ABIs supported by the eclass.
#
# This variable is intended for use in prebuilt multilib packages that
# can provide binaries only for a limited set of ABIs. If ABIs need to
# be limited due to a bug in source code, package.use.mask is to be used
# instead. Along with MULTILIB_COMPAT, KEYWORDS should contain '-*'.
#
# Note that setting this variable effectively disables support for all
# other ABIs, including other architectures. For example, specifying
# abi_x86_{32,64} disables support for MIPS as well.
#
# The value of MULTILIB_COMPAT determines the value of IUSE. If set, it
# also enables REQUIRED_USE constraints.
#
# Example use:
# @CODE
# # Upstream provides binaries for x86 & amd64 only
# MULTILIB_COMPAT=( abi_x86_{32,64} )
# @CODE

# @ECLASS-VARIABLE: MULTILIB_USEDEP
# @DESCRIPTION:
# The USE-dependency to be used on dependencies (libraries) needing
# to support multilib as well.
#
# Example use:
# @CODE
# RDEPEND="dev-libs/libfoo[${MULTILIB_USEDEP}]
#	net-libs/libbar[ssl,${MULTILIB_USEDEP}]"
# @CODE

# @ECLASS-VARIABLE: MULTILIB_ABI_FLAG
# @DEFAULT_UNSET
# @DESCRIPTION:
# The complete ABI name. Resembles the USE flag name.
#
# This is set within multilib_foreach_abi(),
# multilib_parallel_foreach_abi() and multilib-minimal sub-phase
# functions.
#
# It may be null (empty) when the build is done on ABI not controlled
# by a USE flag (e.g. on non-multilib arch or when using multilib
# portage). The build will always be done for a single ABI then.
#
# Example value:
# @CODE
# abi_x86_64
# @CODE

_multilib_build_set_globals() {
	local flags=( "${_MULTILIB_FLAGS[@]%:*}" )

	if [[ ${MULTILIB_COMPAT[@]} ]]; then
		# Validate MULTILIB_COMPAT and filter out the flags.
		local f
		for f in "${MULTILIB_COMPAT[@]}"; do
			if ! has "${f}" "${flags[@]}"; then
				die "Invalid value in MULTILIB_COMPAT: ${f}"
			fi
		done

		flags=( "${MULTILIB_COMPAT[@]}" )

		REQUIRED_USE="|| ( ${flags[*]} )"
	fi

	local usedeps=${flags[@]/%/(-)?}

	IUSE=${flags[*]}
	MULTILIB_USEDEP=${usedeps// /,}
}
_multilib_build_set_globals

# @FUNCTION: multilib_get_enabled_abis
# @DESCRIPTION:
# Return the ordered list of enabled ABIs if multilib builds
# are enabled. The best (most preferred) ABI will come last.
#
# If multilib is disabled, the default ABI will be returned
# in order to enforce consistent testing with multilib code.
multilib_get_enabled_abis() {
	debug-print-function ${FUNCNAME} "${@}"

	local pairs=( $(multilib_get_enabled_abi_pairs) )
	echo "${pairs[@]#*.}"
}

# @FUNCTION: multilib_get_enabled_abi_pairs
# @DESCRIPTION:
# Return the ordered list of enabled <use-flag>.<ABI> pairs
# if multilib builds are enabled. The best (most preferred)
# ABI will come last.
#
# If multilib is disabled, the default ABI will be returned
# along with empty <use-flag>.
multilib_get_enabled_abi_pairs() {
	debug-print-function ${FUNCNAME} "${@}"

	local abis=( $(get_all_abis) )

	local abi i found
	for abi in "${abis[@]}"; do
		for i in "${_MULTILIB_FLAGS[@]}"; do
			local m_abis=${i#*:} m_abi
			local m_flag=${i%:*}

			# split on ,; we can't switch IFS for function scope because
			# paludis is broken (bug #486592), and switching it locally
			# for the split is more complex than cheating like this
			for m_abi in ${m_abis//,/ }; do
				if [[ ${m_abi} == ${abi} ]] \
					&& { [[ ! "${MULTILIB_COMPAT[@]}" ]] || has "${m_flag}" "${MULTILIB_COMPAT[@]}"; } \
					&& use "${m_flag}"
				then
					echo "${m_flag}.${abi}"
					found=1
					break 2
				fi
			done
		done
	done

	if [[ ! ${found} ]]; then
		# ${ABI} can be used to override the fallback (multilib-portage),
		# ${DEFAULT_ABI} is the safe fallback.
		local abi=${ABI:-${DEFAULT_ABI}}

		debug-print "${FUNCNAME}: no ABIs enabled, fallback to ${abi}"
		debug-print "${FUNCNAME}: ABI=${ABI}, DEFAULT_ABI=${DEFAULT_ABI}"
		echo ".${abi}"
	fi
}

# @FUNCTION: _multilib_multibuild_wrapper
# @USAGE: <argv>...
# @INTERNAL
# @DESCRIPTION:
# Initialize the environment for ABI selected for multibuild.
_multilib_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"

	local ABI=${MULTIBUILD_VARIANT#*.}
	local MULTILIB_ABI_FLAG=${MULTIBUILD_VARIANT%.*}

	multilib_toolchain_setup "${ABI}"
	"${@}"
}

# @FUNCTION: multilib_foreach_abi
# @USAGE: <argv>...
# @DESCRIPTION:
# If multilib support is enabled, sets the toolchain up for each
# supported ABI along with the ABI variable and correct BUILD_DIR,
# and runs the given commands with them.
#
# If multilib support is disabled, it just runs the commands. No setup
# is done.
multilib_foreach_abi() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abi_pairs) )
	multibuild_foreach_variant _multilib_multibuild_wrapper "${@}"
}

# @FUNCTION: multilib_parallel_foreach_abi
# @USAGE: <argv>...
# @DESCRIPTION:
# If multilib support is enabled, sets the toolchain up for each
# supported ABI along with the ABI variable and correct BUILD_DIR,
# and runs the given commands with them.
#
# If multilib support is disabled, it just runs the commands. No setup
# is done.
#
# This function used to run multiple commands in parallel. Now it's just
# a deprecated alias to multilib_foreach_abi.
multilib_parallel_foreach_abi() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abi_pairs) )
	multibuild_foreach_variant _multilib_multibuild_wrapper "${@}"
}

# @FUNCTION: multilib_for_best_abi
# @USAGE: <argv>...
# @DESCRIPTION:
# Runs the given command with setup for the 'best' (usually native) ABI.
multilib_for_best_abi() {
	debug-print-function ${FUNCNAME} "${@}"

	eqawarn "QA warning: multilib_for_best_abi() function is deprecated and should"
	eqawarn "not be used. The multilib_is_native_abi() check may be used instead."

	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abi_pairs) )

	multibuild_for_best_variant _multilib_multibuild_wrapper "${@}"
}

# @FUNCTION: multilib_check_headers
# @DESCRIPTION:
# Check whether the header files are consistent between ABIs.
#
# This function needs to be called after each ABI's installation phase.
# It obtains the header file checksums and compares them with previous
# runs (if any). Dies if header files differ.
multilib_check_headers() {
	_multilib_header_cksum() {
		[[ -d ${ED}usr/include ]] && \
		find "${ED}"usr/include -type f \
			-exec cksum {} + | sort -k2
	}

	local cksum=$(_multilib_header_cksum)
	local cksum_file=${T}/.multilib_header_cksum

	if [[ -f ${cksum_file} ]]; then
		local cksum_prev=$(< "${cksum_file}")

		if [[ ${cksum} != ${cksum_prev} ]]; then
			echo "${cksum}" > "${cksum_file}.new"

			eerror "Header files have changed between ABIs."

			if type -p diff &>/dev/null; then
				eerror "$(diff -du "${cksum_file}" "${cksum_file}.new")"
			else
				eerror "Old checksums in: ${cksum_file}"
				eerror "New checksums in: ${cksum_file}.new"
			fi

			die "Header checksum mismatch, aborting."
		fi
	else
		echo "${cksum}" > "${cksum_file}"
	fi
}

# @FUNCTION: multilib_copy_sources
# @DESCRIPTION:
# Create a single copy of the package sources for each enabled ABI.
#
# The sources are always copied from initial BUILD_DIR (or S if unset)
# to ABI-specific build directory matching BUILD_DIR used by
# multilib_foreach_abi().
multilib_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"

	local MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abi_pairs) )
	multibuild_copy_sources
}

# @ECLASS-VARIABLE: MULTILIB_WRAPPED_HEADERS
# @DESCRIPTION:
# A list of headers to wrap for multilib support. The listed headers
# will be moved to a non-standard location and replaced with a file
# including them conditionally to current ABI.
#
# This variable has to be a bash array. Paths shall be relative to
# installation root (${ED}), and name regular files. Recursive wrapping
# is not supported.
#
# Please note that header wrapping is *discouraged*. It is preferred to
# install all headers in a subdirectory of libdir and use pkg-config to
# locate the headers. Some C preprocessors will not work with wrapped
# headers.
#
# Example:
# @CODE
# MULTILIB_WRAPPED_HEADERS=(
#	/usr/include/foobar/config.h
# )
# @CODE

# @ECLASS-VARIABLE: MULTILIB_CHOST_TOOLS
# @DESCRIPTION:
# A list of tool executables to preserve for each multilib ABI.
# The listed executables will be renamed to ${CHOST}-${basename},
# and the native variant will be symlinked to the generic name.
#
# This variable has to be a bash array. Paths shall be relative to
# installation root (${ED}), and name regular files or symbolic
# links to regular files. Recursive wrapping is not supported.
#
# If symbolic link is passed, both symlink path and symlink target
# will be changed. As a result, the symlink target is expected
# to be wrapped as well (either by listing in MULTILIB_CHOST_TOOLS
# or externally).
#
# Please note that tool wrapping is *discouraged*. It is preferred to
# install pkg-config files for each ABI, and require reverse
# dependencies to use that.
#
# Packages that search for tools properly (e.g. using AC_PATH_TOOL
# macro) will find the wrapper executables automatically. Other packages
# will need explicit override of tool paths.
#
# Example:
# @CODE
# MULTILIB_CHOST_TOOLS=(
#	/usr/bin/foo-config
# )

# @CODE
# @FUNCTION: multilib_prepare_wrappers
# @USAGE: [<install-root>]
# @DESCRIPTION:
# Perform the preparation of all kinds of wrappers for the current ABI.
# This function shall be called once per each ABI, after installing
# the files to be wrapped.
#
# Takes an optional custom <install-root> from which files will be
# used. If no root is specified, uses ${ED}.
#
# The files to be wrapped are specified using separate variables,
# e.g. MULTILIB_WRAPPED_HEADERS. Those variables shall not be changed
# between the successive calls to multilib_prepare_wrappers
# and multilib_install_wrappers.
#
# After all wrappers are prepared, multilib_install_wrappers shall
# be called to commit them to the installation tree.
multilib_prepare_wrappers() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -le 1 ]] || die "${FUNCNAME}: too many arguments"

	local root=${1:-${ED}}
	local f

	if [[ ${COMPLETE_MULTILIB} == yes ]]; then
		# symlink '${CHOST}-foo -> foo' to support abi-wrapper while
		# keeping ${CHOST}-foo calls correct.

		for f in "${MULTILIB_CHOST_TOOLS[@]}"; do
			# drop leading slash if it's there
			f=${f#/}

			local dir=${f%/*}
			local fn=${f##*/}

			ln -s "${fn}" "${root}/${dir}/${CHOST}-${fn}" || die
		done

		return
	fi

	for f in "${MULTILIB_CHOST_TOOLS[@]}"; do
		# drop leading slash if it's there
		f=${f#/}

		local dir=${f%/*}
		local fn=${f##*/}

		if [[ -L ${root}/${f} ]]; then
			# rewrite the symlink target
			local target=$(readlink "${root}/${f}")
			local target_dir
			local target_fn=${target##*/}

			[[ ${target} == */* ]] && target_dir=${target%/*}

			ln -f -s "${target_dir+${target_dir}/}${CHOST}-${target_fn}" \
				"${root}/${f}" || die
		fi

		mv "${root}/${f}" "${root}/${dir}/${CHOST}-${fn}" || die

		# symlink the native one back
		if multilib_is_native_abi; then
			ln -s "${CHOST}-${fn}" "${root}/${f}" || die
		fi
	done

	if [[ ${MULTILIB_WRAPPED_HEADERS[@]} ]]; then
		# If abi_flag is unset, then header wrapping is unsupported on
		# this ABI. This means the arch doesn't support multilib at all
		# -- in this case, the headers are not wrapped and everything
		# works as expected.

		if [[ ${MULTILIB_ABI_FLAG} ]]; then
			for f in "${MULTILIB_WRAPPED_HEADERS[@]}"; do
				# drop leading slash if it's there
				f=${f#/}

				if [[ ${f} != usr/include/* ]]; then
					die "Wrapping headers outside of /usr/include is not supported at the moment."
				fi
				# and then usr/include
				f=${f#usr/include}

				local dir=${f%/*}

				# Some ABIs may have install less files than others.
				if [[ -f ${root}/usr/include${f} ]]; then
					local wrapper=${ED}/tmp/multilib-include${f}

					if [[ ! -f ${ED}/tmp/multilib-include${f} ]]; then
						dodir "/tmp/multilib-include${dir}"
						# a generic template
						cat > "${wrapper}" <<_EOF_
/* This file is auto-generated by multilib-build.eclass
 * as a multilib-friendly wrapper. For the original content,
 * please see the files that are #included below.
 */

#if defined(__x86_64__) /* amd64 */
#	if defined(__ILP32__) /* x32 ABI */
#		error "abi_x86_x32 not supported by the package."
#	else /* 64-bit ABI */
#		error "abi_x86_64 not supported by the package."
#	endif
#elif defined(__i386__) /* plain x86 */
#	error "abi_x86_32 not supported by the package."
#elif defined(__mips__)
#   if(_MIPS_SIM == _ABIN32) /* n32 */
#       error "abi_mips_n32 not supported by the package."
#   elif(_MIPS_SIM == _ABI64) /* n64 */
#       error "abi_mips_n64 not supported by the package."
#   elif(_MIPS_SIM == _ABIO32) /* o32 */
#       error "abi_mips_o32 not supported by the package."
#   endif
#elif defined(__sparc__)
#	if defined(__arch64__)
#       error "abi_sparc_64 not supported by the package."
#	else
#       error "abi_sparc_32 not supported by the package."
#	endif
#elif defined(__s390__)
#	if defined(__s390x__)
#       error "abi_s390_64 not supported by the package."
#	else
#       error "abi_s390_32 not supported by the package."
#	endif
#elif defined(__powerpc__)
#	if defined(__powerpc64__)
#       error "abi_ppc_64 not supported by the package."
#	else
#       error "abi_ppc_32 not supported by the package."
#	endif
#elif defined(SWIG) /* https://sourceforge.net/p/swig/bugs/799/ */
#	error "Native ABI not supported by the package."
#else
#	error "No ABI matched, please report a bug to bugs.gentoo.org"
#endif
_EOF_
					fi

					if ! grep -q "${MULTILIB_ABI_FLAG} " "${wrapper}"
					then
						die "Flag ${MULTILIB_ABI_FLAG} not listed in wrapper template. Please report a bug to https://bugs.gentoo.org."
					fi

					# $CHOST shall be set by multilib_toolchain_setup
					dodir "/tmp/multilib-include/${CHOST}${dir}"
					mv "${root}/usr/include${f}" "${ED}/tmp/multilib-include/${CHOST}${dir}/" || die

					# Note: match a space afterwards to avoid collision potential.
					sed -e "/${MULTILIB_ABI_FLAG} /s&error.*&include <${CHOST}${f}>&" \
						-i "${wrapper}" || die

					# Needed for swig.
					if multilib_is_native_abi; then
						sed -e "/Native ABI/s&error.*&include <${CHOST}${f}>&" \
							-i "${wrapper}" || die
					fi
				fi
			done
		fi
	fi
}

# @FUNCTION: multilib_install_wrappers
# @USAGE: [<install-root>]
# @DESCRIPTION:
# Install the previously-prepared wrappers. This function shall
# be called once, after all wrappers were prepared.
#
# Takes an optional custom <install-root> to which the wrappers will be
# installed. If no root is specified, uses ${ED}. There is no need to
# use the same root as when preparing the wrappers.
#
# The files to be wrapped are specified using separate variables,
# e.g. MULTILIB_WRAPPED_HEADERS. Those variables shall not be changed
# between the calls to multilib_prepare_wrappers
# and multilib_install_wrappers.
multilib_install_wrappers() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -le 1 ]] || die "${FUNCNAME}: too many arguments"

	[[ ${COMPLETE_MULTILIB} == yes ]] && return

	local root=${1:-${ED}}

	if [[ -d "${ED}"/tmp/multilib-include ]]; then
		multibuild_merge_root \
			"${ED}"/tmp/multilib-include "${root}"/usr/include
		# it can fail if something else uses /tmp
		rmdir "${ED}"/tmp &>/dev/null
	fi
}

# @FUNCTION: multilib_is_native_abi
# @DESCRIPTION:
# Determine whether the currently built ABI is the profile native.
# Return true status (0) if that is true, otherwise false (1).
multilib_is_native_abi() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${#} -eq 0 ]] || die "${FUNCNAME}: too many arguments"

	[[ ${COMPLETE_MULTILIB} == yes || ${ABI} == ${DEFAULT_ABI} ]]
}

# @FUNCTION: multilib_build_binaries
# @DESCRIPTION:
# Deprecated synonym for multilib_is_native_abi
multilib_build_binaries() {
	debug-print-function ${FUNCNAME} "${@}"

	eqawarn "QA warning: multilib_build_binaries is deprecated. Please use the equivalent"
	eqawarn "multilib_is_native_abi function instead."

	multilib_is_native_abi "${@}"
}

# @FUNCTION: multilib_native_use_with
# @USAGE: <flag> [<opt-name> [<opt-value>]]
# @DESCRIPTION:
# Output --with configure option alike use_with if USE <flag> is enabled
# and executables are being built (multilib_is_native_abi is true).
# Otherwise, outputs --without configure option. Arguments are the same
# as for use_with in the EAPI.
multilib_native_use_with() {
	if multilib_is_native_abi; then
		use_with "${@}"
	else
		echo "--without-${2:-${1}}"
	fi
}

# @FUNCTION: multilib_native_use_enable
# @USAGE: <flag> [<opt-name> [<opt-value>]]
# @DESCRIPTION:
# Output --enable configure option alike use_enable if USE <flag>
# is enabled and executables are being built (multilib_is_native_abi
# is true). Otherwise, outputs --disable configure option. Arguments are
# the same as for use_enable in the EAPI.
multilib_native_use_enable() {
	if multilib_is_native_abi; then
		use_enable "${@}"
	else
		echo "--disable-${2:-${1}}"
	fi
}

# @FUNCTION: multilib_native_enable
# @USAGE: <opt-name> [<opt-value>]
# @DESCRIPTION:
# Output --enable configure option if executables are being built
# (multilib_is_native_abi is true). Otherwise, output --disable configure
# option.
multilib_native_enable() {
	if multilib_is_native_abi; then
		echo "--enable-${1}${2+=${2}}"
	else
		echo "--disable-${1}"
	fi
}

# @FUNCTION: multilib_native_with
# @USAGE: <opt-name> [<opt-value>]
# @DESCRIPTION:
# Output --with configure option if executables are being built
# (multilib_is_native_abi is true). Otherwise, output --without configure
# option.
multilib_native_with() {
	if multilib_is_native_abi; then
		echo "--with-${1}${2+=${2}}"
	else
		echo "--without-${1}"
	fi
}

# @FUNCTION: multilib_native_usex
# @USAGE: <flag> [<true1> [<false1> [<true2> [<false2>]]]]
# @DESCRIPTION:
# Output the concatenation of <true1> (or 'yes' if unspecified)
# and <true2> if USE <flag> is enabled and executables are being built
# (multilib_is_native_abi is true). Otherwise, output the concatenation
# of <false1> (or 'no' if unspecified) and <false2>. Arguments
# are the same as for usex in the EAPI.
#
# Note: in EAPI 4 you need to inherit eutils to use this function.
multilib_native_usex() {
	if multilib_is_native_abi; then
		usex "${@}"
	else
		echo "${3-no}${5}"
	fi
}

_MULTILIB_BUILD=1
fi
