# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: zig.eclass
# @MAINTAINER:
# Eric Joldasov <bratishkaerik@landless-city.net>
# @AUTHOR:
# Alfred Wingate <parona@protonmail.com>
# Violet Purcell <vimproved@inventati.org>
# Eric Joldasov <bratishkaerik@landless-city.net>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: zig-utils
# @BLURB: Functions for working with ZBS (Zig Build System)
# @DESCRIPTION:
# Functions for working with Zig build system and package manager.
# Supports Zig 0.13+.  Exports default functions for convenience.
#
# Note that zig.eclass is mostly tailored for projects that:
# 1) Install something in build.zig steps: "artifacts" (executable,
# libraries, objects), source codes, assets, tests, scripts etc.   But
# many authors also use it to write Zig "modules", build logic
# and/or bindings/wrappers for C/C++ libraries.  They install nothing
# and are only used at build-time, so it's unneccessary and mostly
# useless to make ebuilds for them.
# 2) Have required `target`, `cpu` and optional `optimize` options in
# build.zig that accept standard Zig-style target and optimize mode.
# They are usually created by calling `b.standardTargetOptions` and
# `b.standardOptimizeOption` functions.
#
# For end-user executables, usually it's recommended to patch to call
# these options and upstream it, but in some cases authors have good
# reasons to not have them, f.e. if it is built only for WASM
# platform with ReleaseSmall, and is not intended to run in /usr/bin/.
# In this case, declare dummy options using `b.option` and  ignore
# their values, or else eclass wouldn't work.
#
# Another case is when upstream has `target` option but it has
# custom format and does not accept usual Zig targets, but rather
# something specific to the project like "linux-baseline-lts", or
# combine CPU and target in one option.
# In this case, it's best to rename that option to something like
# `target-custom`, then declare `target` option and make converter
# from one value to other.
#
# For non-executable binaries like C libraries, objects etc. our
# policy is stricter, all 3 options are required and should not
# be ignored, with no exceptions.

if [[ -z ${_ZIG_ECLASS} ]]; then
_ZIG_ECLASS=1

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit multiprocessing zig-utils

# @ECLASS_VARIABLE: ZIG_OPTIONAL
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value, all logic in zig-utils and
# zig eclasses will be considered optional.  No dependencies
# will be added and no phase functions will be exported.
#
# For zig.eclass users:
# You need to add Zig and pkgconfig dependencies in your BDEPEND, set
# QA_FLAGS_IGNORED and call all phase functions manually.  If you want
# to use "ezig build" directly, call "zig_pkg_setup" before it.
#
# For zig-utils.eclass users: see documentation in
# zig-utils.eclass instead.
if [[ ! ${ZIG_OPTIONAL} ]]; then
	BDEPEND="virtual/pkgconfig"

	# See https://github.com/ziglang/zig/issues/3382
	# Zig Build System does not support CFLAGS/LDFLAGS/etc.
	QA_FLAGS_IGNORED=".*"
fi

# @ECLASS_VARIABLE: ZBS_DEPENDENCIES
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Bash associative array with all tarballs that will be fetched by
# "ezig fetch" in zig_src_unpack phase.  Value is URL where
# tarball is located, key is name under which it would be downloaded
# and renamed.  So generally it has effect of "value -> key".
#
# Note: if Zig Build System dependency can't be represented in SRC_URI
# (like direct Git commit URIs), you should do the following
# (zig-ebuilder does archiving automatically for you):
#   1. Archive each folder with dependency content in some tarball,
#      so f.e. if you have 2 Git dependencies, create 2 tarballs.
#   2. Archive all previous tarballs into one combined tarball (also
#      called tarball-tarball from now on), no subdirs, so that eclass
#      can firstly unpack this tarball with "unpack",
#      and secondly unpack its content with "zig fetch".
#   3. (zig-ebuilder can't do this) Host this tarball somewhere
#      and put URL of this tarball in SRC_URI, and archives in
#      ZBS_DEPENDENCIES, keys must be names of archives, values empty.
#
# Example:
# @CODE
# declare -r -A ZBS_DEPENDENCIES=(
# 	[tarball_a-<long-hash>.tar.gz]='URL_A'
# 	[tarball_b-<long-hash>.tar.gz]='URL_B'
#
# 	# If there are Git dependencies:
# 	[git_c-<long-hash>.tar.gz]=''
# 	# Tarball-tarball should contain inside above tarball flatly.
# )
# @CODE

# @ECLASS_VARIABLE: ZBS_DEPENDENCIES_SRC_URI
# @OUTPUT_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Content of ZBS_DEPENDENCIES converted at inherit-time, to be used in
# SRC_URI.  Note that elements with empty keys will be skipped.
# Example:
# @CODE
# SRC_URI="
# 	<URL to project sources, patches, non-Zig resources etc.>
#
# 	# If there are Git dependencies:
# 	# <URL to tarball-tarball>
#
# 	${ZBS_DEPENDENCIES_SRC_URI}
# "
# @CODE

# @FUNCTION: _zig_set_zbs_uris
# @INTERNAL
# @DESCRIPTION:
# Sets ZBS_DEPENDENCIES_SRC_URI variable based on ZBS_DEPENDENCIES.
_zig_set_zbs_uris() {
	# Thanks to Alfred Wingate "parona" for inspiration here:
	# https://gitlab.com/Parona/parona-overlay/-/blob/874dcfe03116574a33ed51f469cc993e98db1fa2/eclass/zig.eclass

	ZBS_DEPENDENCIES_SRC_URI=

	local dependency
	for dependency in "${!ZBS_DEPENDENCIES[@]}"; do
		local uri="${ZBS_DEPENDENCIES[${dependency}]}"
		if [[ -n "${uri}" ]]; then
			ZBS_DEPENDENCIES_SRC_URI+=" ${uri} -> ${dependency}"
		fi
	done
}
_zig_set_zbs_uris

# @ECLASS_VARIABLE: my_zbs_args
# @DEFAULT_UNSET
# @DESCRIPTION:
# Bash array with ebuild-specified arguments to pass to the
# "zig build" after "src_configure".
# It's appended to the ZBS_ARGS during "src_configure".  Note: if you
# need to override default optimize mode of this eclass (ReleaseSafe)
# with your default, please use "--release=small" etc. syntax so that
# user can still override it in ZBS_ARGS_EXTRA.
#
# Example:
# @CODE
# src_configure() {
# 	local my_zbs_args=(
# 		-Dpie=true
# 	)
#
# 	zig_src_configure
# }
# @CODE

# @ECLASS_VARIABLE: ZBS_ARGS_EXTRA
# @USER_VARIABLE
# @DESCRIPTION:
# Bash string with user-specified arguments to pass to the "zig build"
# after "src_configure".
# It's appended to the ZBS_ARGS during "zig_src_configure".
#
# If this does not have amount of jobs, eclass will try to take amount
# of jobs from MAKEOPTS, and if it also does not have them, it will
# default to $(nproc).
#
# Example:
# @CODE
# ZBS_ARGS_EXTRA="-j8 --release=small"
# @CODE
: "${ZBS_ARGS_EXTRA:=}"

# @ECLASS_VARIABLE: ZBS_VERBOSE
# @USER_VARIABLE
# @DESCRIPTION:
# If enabled, eclass will add "--summary all --verbose" options to
# "ezig build", so that it prints every command before executing,
# and summarry tree at the end of step.  If not, will do nothing.
# Enabled by default.  Set to OFF to disable these verbose messages.
#
# Note: this variable does not control other options starting with
# "--verbose-", such as "--verbose-link" or "--verbose-cimport".  If
# you need them, add them manually to ZBS_ARGS_EXTRA.
: "${ZBS_VERBOSE:=ON}"

# @ECLASS_VARIABLE: BUILD_DIR
# @DESCRIPTION:
# Directory where all "ezig build" calls will be proceeded.
# Defaults to "${WORKDIR}/${P}-build" if not set.
: "${BUILD_DIR:=${WORKDIR}/${P}-build}"

# @ECLASS_VARIABLE: ZBS_ECLASS_DIR
# @DESCRIPTION:
# Directory where various files used by this eclass are stored.
# They can be supplied by the ebuild or by eclass.
# Currently, it's used only for Zig packages, which are stored in "p/"
# subdirectory.
# Defaults to "${WORKDIR}/zig-eclass" if not set.
# Should be set before calling "zig_src_unpack" or
# "zig_live_fetch".
: "${ZBS_ECLASS_DIR:=${WORKDIR}/zig-eclass}"

# @FUNCTION: zig_get_jobs
# @DESCRIPTION:
# Returns number of jobs from ZBS_ARGS_EXTRA or MAKEOPTS.
# If there is none, defaults to number of available processing units.
zig_get_jobs() {
	local all_args="${MAKEOPTS} ${ZBS_ARGS_EXTRA}"
	local default_jobs="$(get_nproc)"
	local jobs="$(makeopts_jobs "${all_args}" "${default_jobs}")"

	if [[ "${jobs}" == "0" ]]; then
		# Zig build system does not allow "-j0", and does not have
		# option for unlimited parallelism. Pass our default number
		# of jobs here.
		echo "${default_jobs}"
	else
		echo "${jobs}"
	fi
}

# @FUNCTION: zig_init_base_args
# @DESCRIPTION:
# Stores basic args for future "ezig build" calls in ZBS_ARGS_BASE.
# Package manager option is managed by "zig_src_prepare",
# ebuild and user options are added by "zig_src_configure".
#
# This function is used by "zig_pkg_setup", and it is neccessary
# that args are available as early as possible, so that ebuilds
# could use them in steps like "src_unpack" if neccessary, while
# still having verbosity and amount of jobs from user respected.
#
#
# TODO: currently this function enables "--search-prefix" (1) and
# "--sysroot" (2) only when cross-compiling, should be fixed to
# unconditionally enabling it.
#
# For solving (1) this patch should be reworked and upstreamed:
# https://paste.sr.ht/~bratishkaerik/2ddffe2bf0f8f9d6dfb60403c2e9560334edaa88
#
# (2)
# "--sysroot" should be passed together with "--search-prefix" above,
# if we pass only "--sysroot" it gives these errors:
# @CODE
# error: unable to find dynamic system library 'zstd' using strategy 'paths_first'. searched paths: none
# @CODE
zig_init_base_args() {
	[[ "${ZBS_ARGS_BASE}" ]] && return

	# Sync with the output format of `zig libc`.
	# TODO maybe add to upstream to use ZON format instead...
	# Will also help "https://github.com/ziglang/zig/issues/20327",
	# and hopefully will respect our settings too.
	cat <<- _EOF_ > "${T}/zig_libc.txt" || die "Failed to provide Zig libc info"
		# Note: they are not prepended by "--sysroot" value,
		# so repeat it here.
		# Also, no quotes here, they are interpreted verbatim.
		include_dir=${ESYSROOT}/usr/include/
		sys_include_dir=${ESYSROOT}/usr/include/
		crt_dir=${ESYSROOT}/usr/$(get_libdir)/
		# Windows with MSVC only.
		msvc_lib_dir=
		# Windows with MSVC only.
		kernel32_lib_dir=
		# Haiku only.
		gcc_dir=
	_EOF_

	declare -g -a ZBS_ARGS_BASE=(
		-j$(zig_get_jobs)

		-Dtarget="${ZIG_TARGET}"
		-Dcpu="${ZIG_CPU}"
		--release=safe

		--prefix-exe-dir bin/
		--prefix-lib-dir "$(get_libdir)/"
		--prefix-include-dir include/

		# Should be relative path to make other calls easier,
		# so remove leading slash here.
		--prefix "${EPREFIX:+${EPREFIX#/}/}usr/"

		--libc "${T}/zig_libc.txt"
	)
	if [[ "${ZBS_VERBOSE}" != OFF ]]; then
		ZBS_ARGS_BASE+=( --summary all --verbose )
	fi

	if tc-is-cross-compiler; then
		ZBS_ARGS_BASE+=(
			--search-prefix "${ESYSROOT}/usr/"
			--sysroot "${ESYSROOT}/"
		)
	fi
}

# @FUNCTION: zig_pkg_setup
# @DESCRIPTION:
# Sets up environmental variables for Zig toolchain
# and basic args for Zig Build System.
zig_pkg_setup() {
	[[ "${MERGE_TYPE}" != binary ]] || return 0

	zig-utils_setup
	zig_init_base_args

	mkdir "${T}/zig-cache/" || die

	# Environment variables set by this eclass.

	# Used by Zig Build System to find `pkg-config`.
	# UPSTREAM Used only by 9999 for now, should land in future
	# 0.14 release.
	export PKG_CONFIG="${PKG_CONFIG:-"$(tc-getPKG_CONFIG)"}"
	# Used by whole Zig toolchain (most of the sub-commands)
	# to find local and global cache directories.
	export ZIG_LOCAL_CACHE_DIR="${T}/zig-cache/local/"
	export ZIG_GLOBAL_CACHE_DIR="${T}/zig-cache/global/"
}

# @FUNCTION: zig_live_fetch
# @USAGE: [<args>...]
# @DESCRIPTION:
# Fetches packages, if they exist, to the "ZBS_ECLASS_DIR/p/".
# Adds build file path to ZBS_BASE_ARGS.
# If you have some lazy dependency which is not triggered in default
# configuration, pass options like you would pass them for regular
# "ezig build".  Try to cover all of them before "src_configure".
# **Note**: this function will be deprecated once/if
# https://github.com/ziglang/zig/pull/19975 lands.
#
# Example:
# @CODE
# src_unpack() {
# 	# If there are no lazy dependency:
# 	zig_live_fetch
#
# 	# If there are lazy dependencies that can be triggered together:
# 	zig_live_fetch -Denable-wayland -Denable-xwayland
#
# 	# If there are 2 lazy dependencies that can't be triggered
# 	# together in one call because they conflict:
# 	zig_live_fetch -Dmain-backend=opengl
# 	zig_live_fetch -Dmain-backend=vulkan
# }
# @CODE
zig_live_fetch() {
	# This function will likely be called in src_unpack,
	# before [zig_]src_prepare, so this directory might not
	# exist yet.
	mkdir -p "${BUILD_DIR}" > /dev/null || die
	pushd "${BUILD_DIR}" > /dev/null || die

	ZBS_ARGS_BASE+=( --build-file "${S}/build.zig" )

	local args=(
		"${ZBS_ARGS_BASE[@]}"

		--global-cache-dir "${ZBS_ECLASS_DIR}/"

		# Function arguments
		"${@}"
	)

	einfo "ZBS: live-fetching with:"
	einfo "${args[@]}"
	ezig build --help "${args[@]}" > /dev/null

	popd > /dev/null || die
}

# @FUNCTION: zig_src_unpack
# @DESCRIPTION:
# Unpacks every archive in SRC_URI and ZBS_DEPENDENCIES,
# in that order.  Adds build file path to ZBS_BASE_ARGS.
zig_src_unpack() {
	# Thanks to Alfred Wingate "parona" for inspiration here:
	# https://gitlab.com/Parona/parona-overlay/-/blob/874dcfe03116574a33ed51f469cc993e98db1fa2/eclass/zig.eclass

	ZBS_ARGS_BASE+=( --build-file "${S}/build.zig" )

	if [[ "${#ZBS_DEPENDENCIES_SRC_URI}" -eq 0 ]]; then
		default_src_unpack
		return
	fi

	local zig_deps=()
	for dependency in "${!ZBS_DEPENDENCIES[@]}"; do
		zig_deps+=("${dependency}")
	done

	# First unpack non-Zig dependencies, so that
	# tarball with all Git dependencies tarballs is unpacked early.
	local dist
	for dist in ${A}; do
		if ! has "${dist}" "${zig_deps[@]}"; then
			unpack "${dist}"
		fi
	done

	# Now unpack all Zig dependencies, including those that are
	# now unpacked from tarball-tarball.
	local zig_dep
	for zig_dep in "${zig_deps[@]}"; do
		# Hide now-spammy hash from stdout
		ezig fetch --global-cache-dir "${ZBS_ECLASS_DIR}/" \
			"${DISTDIR}/${zig_dep}" > /dev/null
	done
	einfo "ZBS: ${#zig_deps[@]} dependencies unpacked"
}

# @FUNCTION: zig_src_prepare
# @DESCRIPTION:
# Calls default "src_prepare" function, creates BUILD_DIR directory
# and enables system mode (by adding to ZBS_BASE_ARGS).
#
# System mode is toggled here and not in "src_unpack" because they
# could have been fetched by "live_fetch" in live ebuilds instead.
zig_src_prepare() {
	default_src_prepare

	mkdir -p "${BUILD_DIR}" || die
	einfo "BUILD_DIR: \"${BUILD_DIR}\""

	local system_dir="${ZBS_ECLASS_DIR}/p/"
	mkdir -p "${system_dir}" || die
	ZBS_ARGS_BASE+=(
		# Disable network access after ensuring all dependencies
		# are unpacked (by "src_unpack" or "live_fetch")
		--system "${system_dir}"
	)
}

# @FUNCTION: zig_src_configure
# @DESCRIPTION:
# Creates ZBS_ARGS array which can be used in all future phases,
# by combining ZBS_ARGS_BASE set previously, my_zbs_args from ebuild,
# and ZBS_ARGS_EXTRA by user, in this order.
#
# Specific flags currently only add support for the cross-compilation.
# They are likely to be extended in the future.
zig_src_configure() {
	# Handle quoted whitespace.
	eval "local -a ZBS_ARGS_EXTRA=( ${ZBS_ARGS_EXTRA} )"

	# Since most arguments in array are also cached by ZBS, we
	# want to reuse array as much as possible, so prevent
	# modification of it.
	declare -g -a -r ZBS_ARGS=(
		# Base arguments from pkg_setup/setup_base_args
		"${ZBS_ARGS_BASE[@]}"

		# Arguments from ebuild
		"${my_zbs_args[@]}"

		# Arguments from user
		"${ZBS_ARGS_EXTRA[@]}"
	)

	einfo "ZBS: configured with:"
	einfo "${ZBS_ARGS[@]}"
}

# @FUNCTION: zig_src_compile
# @USAGE: [<args>...]
# @DESCRIPTION:
# Calls "ezig build" with previously set ZBS_ARGS.
# Args passed to this function will be passed after ZBS_ARGS.
zig_src_compile() {
	pushd "${BUILD_DIR}" > /dev/null || die

	local args=( "${ZBS_ARGS[@]}" "${@}" )
	einfo "ZBS: compiling with: ${args[@]}"
	nonfatal ezig build "${args[@]}" || die "ZBS: compilation failed"

	popd > /dev/null || die
}

# @FUNCTION: zig_src_test
# @USAGE: [<args>...]
# @DESCRIPTION:
# If "test" step exist, calls "ezig build test" with previously set
# ZBS_ARGS.
# Args passed to this function will be passed after ZBS_ARGS.
# Note: currently step detection might give false positives in
# very rare cases, it will be improved in the future.
zig_src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die

	local args=( "${ZBS_ARGS[@]}" "${@}" )

	# UPSTREAM std.testing.tmpDir and a lot of other functions
	# do not respect --cache-dir or ZIG_LOCAL_CACHE_DIR:
	# https://github.com/ziglang/zig/issues/19874
	mkdir ".zig-cache/" || die

	# UPSTREAM Currently, step name can have any characters in it,
	# including whitespaces, so splitting names and descriptions
	# by whitespaces is not enough for some cases.
	# We probably need something like  "--list-steps names_only".
	# In practice, almost nobody sets such names.
	# Ignore failures like rare random "error.BrokenPipe" here.
	# If they are real, they would appear in "ezig build test" anyway.
	if grep -q '^[ ]*test[ ]' < <(
		nonfatal ezig build --list-steps "${args[@]}"
	); then
		einfo "ZBS: testing with: ${args[@]}"
		nonfatal ezig build test "${args[@]}" ||
			die "ZBS: tests failed"
	else
		einfo "Test step not found, skipping."
	fi

	popd > /dev/null || die
}

# @FUNCTION: zig_src_install
# @USAGE: [<args>...]
# @DESCRIPTION:
# Calls "ezig build" with DESTDIR and previously set ZBS_ARGS.
# Args passed to this function will be passed after ZBS_ARGS.
# Also installs documentation via "einstalldocs".
zig_src_install() {
	pushd "${BUILD_DIR}" > /dev/null || die
	local args=( "${ZBS_ARGS[@]}" "${@}" )
	einfo "ZBS: installing with: ${args[@]}"
	DESTDIR="${D}" nonfatal ezig build "${args[@]}" ||
		die "ZBS: installing failed"
	popd > /dev/null || die

	einstalldocs
}

fi

if [[ ! ${ZIG_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install
fi
