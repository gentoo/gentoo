# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: zig-build.eclass
# @MAINTAINER:
# Eric Joldasov <bratishkaerik@landless-city.net>
# @AUTHOR:
# Alfred Wingate <parona@protonmail.com>
# Violet Purcell <vimproved@inventati.org>
# Eric Joldasov <bratishkaerik@landless-city.net>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: zig-toolchain
# @BLURB: Functions for working with ZBS (Zig Build System).
# @DESCRIPTION:
# Functions for working with Zig build system and package manager.
# Supports Zig 0.13+. Exports default functions for convenience.
#
# Note that zig-build.eclass is mostly tailored for projects that:
# 1) Install something in build.zig steps: "artifacts" (executable,
# libraries, objects), source codes, assets, tests, scripts etc. But many authors
# also use it to write Zig "modules", build logic and/or bindings/wrappers
# for C/C++ libraries. They install nothing and are only used at build-time,
# so it's unneccessary and mostly useless to make ebuilds for them.
# 2) Have required `target`, `cpu` and optional `optimize` options
# in build.zig that accept standard Zig-style target and optimize mode.
# They are usually created by `standardTargetOptions` and `standardOptimizeOption`.
#
# For end-user executables, usually it's recommended to fix calling these options by patch
# and upstream it, but in some cases they have good reasons
# to not have this option, f.e. if it is built only for WASM
# platform with ReleaseSmall, and is not intended to run in your /usr/bin/.
# In this case, declare dummy options using `standardTargetOptions` and
# ignore their values, or else eclass wouldn't work.
#
# Another case is when upstream has `target` option but it is customized
# and does not accept usual targets, but something specific to the project
# like "linux-baseline-lts" or combine CPU and target in one option.
# In this case, it's best to rename that option to something like `target-custom`,
# then declare `target` option and make converter from one value to other.
#
# For non-executable binaries like C shared/static libraries, objects etc.
# our policy is stricter, all 3 options are required and should not
# be ignored, with no exceptions.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ZIG_BUILD_ECLASS} ]]; then
_ZIG_BUILD_ECLASS=1

inherit multiprocessing zig-toolchain

# @ECLASS_VARIABLE: ZIG_OPTIONAL
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value, all logic in zig-toolchain and zig-build
# eclasses will be considered optional. No dependencies will be added and
# no phase functions will be exported.
#
# For zig-build.eclass users:
# You need to add Zig and pkgconfig dependency in your BDEPEND, set QA_FLAGS_IGNORED
# and call all phase functions manually, or, if you want to call "ezig" directly,
# at least call "zig-build_pkg_setup" before it.
#
# For zig-toolchain.eclass users: see documentation in zig-toolchain.eclass instead.
if [[ ! ${ZIG_OPTIONAL} ]]; then
	BDEPEND+="virtual/pkgconfig"

	# See https://github.com/ziglang/zig/issues/3382
	# Zig Build System does not support CFLAGS/LDFLAGS/etc.
	QA_FLAGS_IGNORED=".*"
fi

# @ECLASS_VARIABLE: ZBS_DEPENDENCIES
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Bash associative array with all tarballs that will be fetched by
# "ezig fetch" in zig-build_src_unpack phase. Value is URL where
# tarball is located, key is name under which it would be downloaded
# and renamed. So generally it has effect of "value -> key".
#
# Note: if Zig Build System dependency can't be represented in SRC_URI
# (like direct Git commit URIs), you should do the following (zig-ebuilder
# does archiving automatically for you):
#   1. Archive each folder with dependency content in some tarball,
#      so f.e. if you have 2 Git dependencies, create 2 tarballs.
#   2. Archive all previous tarballs into one combined tarball (also
#      called tarball-tarball from now on), no subdirs, so that eclass
#      can firstly unpack this tarball with "unpack",
#      and secondly unpack its content with "zig fetch".
#   3. (zig-ebuilder can't do this) Host this tarball somewhere
#      and put URL of this tarball in SRC_URI, and archives in ZBS_DEPENDENCIES,
#      keys must be names of archives, leave values empty.
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
# Content of ZBS_DEPENDENCIES converted at inherit-time, to be used in SRC_URI.
# Note that elements with empty keys will be skipped.
# Example:
# @CODE
# SRC_URI="
# 	<URL to archive of project sources, patches, other non-Zig resources etc.>
#
# 	# If there are Git dependencies:
# 	# <URL to tarball-tarball>
#
# 	${ZBS_DEPENDENCIES_SRC_URI}
# "
# @CODE

# @FUNCTION: _zig-build_set_zbs_uris
# @INTERNAL
# @DESCRIPTION:
# Sets ZBS_DEPENDENCIES_SRC_URI variable based on ZBS_DEPENDENCIES.
_zig-build_set_zbs_uris() {
	# Thanks to Alfred Wingate "parona" for inspiration here:
	# https://gitlab.com/Parona/parona-overlay/-/blob/874dcfe03116574a33ed51f469cc993e98db1fa2/eclass/zig.eclass

	ZBS_DEPENDENCIES_SRC_URI=

	for dependency in ${!ZBS_DEPENDENCIES[@]}; do
		local uri="${ZBS_DEPENDENCIES[${dependency}]}"
		if [[ ${#uri} -gt 0 ]]; then
			ZBS_DEPENDENCIES_SRC_URI+=" ${uri} -> ${dependency}"
		else
			# Unrepresentable dependency
			continue
		fi
	done
}
_zig-build_set_zbs_uris

# @ECLASS_VARIABLE: my_zbs_args
# @DESCRIPTION:
# Ebuild-specified arguments to pass to the "zig build" after "src_configure".
# This should be a Bash array. It's appended to the ZBS_ARGS
# during "src_configure". Note: if you need to override default
# optimize mode of this eclass (ReleaseSafe) with your default,
# please use "--release=small" etc. syntax so that user can still
# override it in ZBS_ARGS_EXTRA.
#
# Example:
# @CODE
# src_configure() {
# 	local my_zbs_args=(
# 		-Dpie=true
# 	)
#
# 	zig-build_src_configure
# }
# @CODE
: "${my_zbs_args:=}"

# @ECLASS_VARIABLE: ZBS_ARGS_EXTRA
# @USER_VARIABLE
# @DESCRIPTION:
# User-specified arguments to pass to the "zig build" after "src_configure".
# This is also where amount of jobs for "zig build" is taken from.
# It's appended to the ZBS_ARGS during "zig-build_src_configure".
#
# If this does not have amount of jobs, eclass will try to take amount of jobs
# from MAKEOPTS, and if it also does not have them, it will default to $(nproc).
#
# Example:
# @CODE
# -j8 --release=small
# @CODE
: "${ZBS_ARGS_EXTRA:=}"

# @ECLASS_VARIABLE: ZBS_VERBOSE
# @USER_VARIABLE
# @DESCRIPTION:
# If enabled, eclass will add "--summary all --verbose" options to
# "ezig build", so that it prints every command before executing,
# and summarry tree at the end of step. If not, will do nothing.
# Enabled by default. Set to OFF to disable these verbose messages.
#
# Note: this variable does not control other options starting with "--verbose-",
# such as "--verbose-link" or "--verbose-llvm-cpu-features". If you need them,
# add them manually to ZBS_ARGS_EXTRA.
: "${ZBS_VERBOSE:=ON}"

# @ECLASS_VARIABLE: BUILD_DIR
# @DEFAULT_UNSET
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
# Should be set before calling "zig-build_src_unpack" or "zig-build_live_fetch".
: "${ZBS_ECLASS_DIR:=${WORKDIR}/zig-eclass}"

# @FUNCTION: zig-build_get_jobs
# @DESCRIPTION:
# Returns number of jobs from ZBS_ARGS_EXTRA or MAKEOPTS.
# If there is none, defaults to number of available processing units.
zig-build_get_jobs() {
	local default_jobs="$(get_nproc)"
	local jobs=$(makeopts_jobs "${ZBS_ARGS_EXTRA} ${MAKEOPTS}" "${default_jobs}")

	if [[ ${jobs} == "0" ]]; then
		# Zig build system does not allow jobs count to be less than 1,
		# and does not have option for unlimited parallelism. Pass
		# default number of jobs here.
		echo "${default_jobs}"
	else
		echo "${jobs}"
	fi
}

# @FUNCTION: zig-build_start_base_args
# @DESCRIPTION:
# Stores basic args for future "ezig build" calls in ZBS_ARGS_BASE,
# Package manager option is managed by "zig-build_src_prepare",
# ebuild and user options are added by "zig-build_src_configure".
#
# This function is used by "zig-build_pkg_setup", and it is neccessary
# that args are available as early as possible, so that ebuilds
# could use them in steps like "src_unpack" if neccessary, while
# still having verbosity and amount of jobs from user respected.
zig-build_start_base_args() {
	[[ ${ZBS_ARGS_BASE} ]] && return

	local crt_dir="${ESYSROOT}/usr/"
	if [[ ${ZIG_TARGET} == *musl* ]]; then
		crt_dir+="lib/"
	else
		crt_dir+="$(get_libdir)/"
	fi

	# Sync with the output format of `zig libc`.
	# TODO maybe add to upstream to use ZON format instead...
	# Will also help "https://github.com/ziglang/zig/issues/20327",
	# and hopefully will respect our settings too.
	cat <<- _EOF_ > "${T}/zig_libc.txt" || die "Failed to create Zig libc installation paths file"
		# Note: they are not prepended by "--sysroot" value, so repeat it here.
		include_dir=${ESYSROOT}/usr/include/
		sys_include_dir=${ESYSROOT}/usr/include/
		crt_dir=${crt_dir}
		# Windows with MSVC only.
		msvc_lib_dir=
		# Windows with MSVC only.
		kernel32_lib_dir=
		# Haiku only.
		gcc_dir=
	_EOF_

	declare -g -a ZBS_ARGS_BASE=(
		-j$(zig-build_get_jobs)
		--build-file "${S}/build.zig"

		-Dtarget=${ZIG_TARGET}
		-Dcpu=${ZIG_CPU}
		--release=safe

		--prefix-exe-dir bin/
		--prefix-lib-dir $(get_libdir)/
		--prefix-include-dir include/

		# Should be relative path to make other calls easier,
		# so remove leading slash here.
		--prefix "${EPREFIX:+${EPREFIX#/}/}usr/"

		--libc "${T}/zig_libc.txt"
	)
	[[ "${ZBS_VERBOSE}" != OFF ]] && ZBS_ARGS_BASE+=( --summary all --verbose )

	if tc-is-cross-compiler; then
		ZBS_ARGS_BASE+=(
			# TODO add to upstream some way to add different search prefixes
			# for binaries, include paths and libraries, like existing --prefix-exe-dir etc.
			# Right now std.Build.findProgram will try to search here first, before PATH,
			# but std.Build.run and std.Build.runAllowFail use passed arguments as is and
			# uses std.process.Child under the hood, which itself can use PATH.
			#
			# Passing "--search-prefix" when not cross-compiling gives these errors:
			# install
			# └─ install ncdu
			#    └─ zig build-exe ncdu ReleaseSafe native 5 errors
			# error: ld.lld: /usr/lib64/Scrt1.o is incompatible with elf32-i386
			# error: ld.lld: /usr/lib64/crti.o is incompatible with elf32-i386
			# error: ld.lld: /var/tmp/portage/sys-fs/ncdu-2.6-r1/temp/zig-cache/local/o/21d4a7d4d6563c46cfe08d129805520f/ncdu.o is incompatible with elf32-i386
			# error: ld.lld: /var/tmp/portage/sys-fs/ncdu-2.6-r1/temp/zig-cache/global/o/15ced1ec04eb7a5fc68f8ee7bed8650c/libcompiler_rt.a(/var/tmp/portage/sys-fs/ncdu-2.6-r1/temp/zig-cache/global/o/15ced1ec04eb7a5fc68f8ee7bed8650c/libcompiler_rt.a.o) is incompatible with elf32-i386
			# error: ld.lld: /usr/lib64/crtn.o is incompatible with elf32-i386
			# error: the following command failed with 5 compilation errors:
			# TODO: enable this unconditionnaly
			# after rewriting https://paste.sr.ht/~bratishkaerik/f68273ccde4e8771413098b302f5ee4961521a09
			# to include TODO above, and upstreaming that patch. I really don't want to make
			# different behaviour for 9999 and 0.13 in this place now.
			--search-prefix "${ESYSROOT}/usr/"

			# Note: combined with our other options, it's mostly not used by Zig itself, only by lld linker.
			# Without this option, lld thinks we are not cross-compiling
			# and will complain that dynamic linker like "/lib/ld-linux-aarch64.so.1" does not exist.
			#
			# "--sysroot" should be passed together with "--search-prefix" above, else it gives these errors:
			# install
			# └─ install ncdu
			#   └─ zig build-exe ncdu ReleaseSafe native failure
			# error: error: unable to find dynamic system library 'ncursesw' using strategy 'paths_first'. searched paths: none
			# error: unable to find dynamic system library 'tinfow' using strategy 'paths_first'. searched paths: none
			# error: unable to find dynamic system library 'zstd' using strategy 'paths_first'. searched paths: none

			# error: the following command exited with error code 1:
			--sysroot "${ESYSROOT}/"
		)
	fi
}

# @FUNCTION: zig-build_pkg_setup
# @DESCRIPTION:
# Sets up environmental variables for Zig toolchain
# and basic args for Zig Build System.
zig-build_pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] || return 0

	zig-toolchain_populate_env_vars
	zig-build_start_base_args

	# Used only by 9999 for now, change in upstream did not appear
	# in fixed release yet.
	export PKG_CONFIG="${PKG_CONFIG:-$(tc-getPKG_CONFIG)}"

	mkdir "${T}/zig-cache/" || die
	export ZIG_LOCAL_CACHE_DIR="${T}/zig-cache/local/"
	export ZIG_GLOBAL_CACHE_DIR="${T}/zig-cache/global/"
}

# @FUNCTION: zig-build_live_fetch
# @USAGE: [<args>...]
# @DESCRIPTION:
# Fetches packages, if they exist, to the "ZBS_ECLASS_DIR/p/".
# If you have some lazy dependency which is not triggered in default
# configuration, pass options like you would pass them for regular
# "ezig build". Try to cover all of them before "src_configure".
# **Note**: this function will be deprecated once/if
# https://github.com/ziglang/zig/pull/19975 lands.
#
# Example:
# @CODE
# src_unpack() {
# 	# If there are no lazy dependency:
# 	zig-build_live_fetch
#
# 	# If there are lazy dependencies that can be triggered together:
# 	zig-build_live_fetch -Denable-wayland -Denable-xwayland
#
# 	# If there are 2 lazy dependencies that can't be triggered
# 	# together in one call because they conflict:
# 	zig-build_live_fetch -Dmain-backend=opengl
# 	zig-build_live_fetch -Dmain-backend=vulkan
# }
# @CODE
zig-build_live_fetch() {
	# This function will probably be called before [zig-build_]src_prepare,
	# like in src_unpack, so this directory might not exist yet.
	mkdir -p "${BUILD_DIR}" > /dev/null || die
	pushd "${BUILD_DIR}" > /dev/null || die

	local args=(
		"${ZBS_ARGS_BASE[@]}"

		--global-cache-dir "${ZBS_ECLASS_DIR}/"
		--fetch

		# Function arguments
		"${@}"
	)

	einfo "ZBS: attempting to live-fetch dependencies using the following options: ${args[@]}"
	ezig build "${args[@]}" || die "ZBS: fetching dependencies failed"

	popd > /dev/null || die
}

# @FUNCTION: zig-build_src_unpack
# @DESCRIPTION:
# Unpacks every archive in SRC_URI and ZBS_DEPENDENCIES, in that order.
zig-build_src_unpack() {
	# Thanks to Alfred Wingate "parona" for inspiration here:
	# https://gitlab.com/Parona/parona-overlay/-/blob/874dcfe03116574a33ed51f469cc993e98db1fa2/eclass/zig.eclass

	if [[ "${#ZBS_DEPENDENCIES_SRC_URI}" -eq 0 ]]; then
		default_src_unpack
		return
	fi

	local zig_deps=()
	for dependency in ${!ZBS_DEPENDENCIES[@]}; do
		zig_deps+=("${dependency}")
	done
	# First unpack non-Zig dependencies, so that
	# tarball with all Git dependencies tarballs is unpacked early.
	for dist in ${A}; do
		for zig_dep in "${zig_deps[@]}"; do
			if [[ "${dist}" == "${zig_dep}" ]]; then
				continue 2
			fi
		done

		unpack "${dist}"
	done

	# Now unpack all Zig dependencies, including those that are
	# now unpacked from tarball-tarball.
	for zig_dep in "${zig_deps[@]}"; do
		# Hide now-spammy hash from stdout
		ezig fetch --global-cache-dir "${ZBS_ECLASS_DIR}/" "${DISTDIR}/${zig_dep}" > /dev/null
	done
	einfo "ZBS: ${#zig_deps[@]} dependencies fetched"
}

# @FUNCTION: zig-build_src_prepare
# @DESCRIPTION:
# Calls default "src_prepare" function, creates BUILD_DIR directory
# and enables or disables system mode (by adding to ZBS_BASE_ARGS),
# depending on how many packages there are.
#
# System mode is toggled here and not in "src_unpack" because
# they could have been fetched by "live_fetch" in live ebuilds instead.
zig-build_src_prepare() {
	default_src_prepare

	mkdir -p "${BUILD_DIR}" || die
	einfo "BUILD_DIR: \"${BUILD_DIR}\""

	local system_dir="${ZBS_ECLASS_DIR}/p/"

	# We are using directories count instead of ZBS_DEPENDENCIES.len
	# because author might have fetched packages using live_fetch instead.
	local -a packages=()
	readarray -d '' -t packages < <(find "${system_dir}" -mindepth 1 -maxdepth 1 -type d -print0 2> /dev/null || echo -n "")
	local count="${#packages[@]}"

	if [[ "${count}" -gt 0 ]]; then
		einfo "ZBS: system mode enabled, ${count} packages found"
		ZBS_ARGS_BASE+=( --system "${system_dir}" )
	else
		einfo "ZBS: no packages found, no need to enable system mode"
	fi
}

# @FUNCTION: zig-build_src_configure
# @DESCRIPTION:
# Creates ZBS_ARGS array which can be used in all future phases,
# by combining ZBS_ARGS_BASE set previously, my_zbs_args from ebuild,
# and ZBS_ARGS_EXTRA by user, in this order.
#
# Specific flags currently only add support for the cross-compilation.
# They are likely to be extended in the future.
zig-build_src_configure() {
	# Handle quoted whitespace.
	eval "local -a ZBS_ARGS_EXTRA=( ${ZBS_ARGS_EXTRA} )"

	# Since most arguments in array are also cached by ZBS, we want to
	# reuse array as much as possible, so prevent modification of it.
	declare -g -a -r ZBS_ARGS=(
		# Base arguments from pkg_setup/setup_base_args
		"${ZBS_ARGS_BASE[@]}"

		# Arguments from ebuild
		"${my_zbs_args[@]}"

		# Arguments from user
		"${ZBS_ARGS_EXTRA[@]}"
	)

	einfo "Configured with:"
	einfo "${ZBS_ARGS[@]}"
}

# @FUNCTION: zig-build_src_compile
# @USAGE: [<args>...]
# @DESCRIPTION:
# Calls "ezig build" with previously set ZBS_ARGS.
# Args passed to this function will be passed after ZBS_ARGS.
zig-build_src_compile() {
	pushd "${BUILD_DIR}" > /dev/null || die

	ezig build "${ZBS_ARGS[@]}" "${@}" || die "ZBS: compilation failed"

	popd > /dev/null || die
}

# @FUNCTION: zig-build_src_test
# @USAGE: [<args>...]
# @DESCRIPTION:
# If "test" step exist, calls "ezig build test" with previously set ZBS_ARGS.
# Args passed to this function will be passed after ZBS_ARGS.
# Note: currently step detection might give false positives in
# very rare cases, it will be improved in the future.
zig-build_src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die

	# UPSTREAM std.testing.tmpDir and a lot of other functions
	# do not respect --cache-dir or ZIG_LOCAL_CACHE_DIR:
	# https://github.com/ziglang/zig/issues/19874
	mkdir -p "zig-cache/" ".zig-cache/" || die

	local found_test_step=false

	local -a steps
	readarray steps < <(ezig build --list-steps "${ZBS_ARGS[@]}" || die "ZBS: listing steps failed")

	for step in "${steps[@]}"; do
		# UPSTREAM Currently, step name can have any characters in it,
		# including whitespaces, so splitting names and
		# descriptions by whitespaces is not enough for some cases.
		# We probably need something like "--list-steps names_only".
		# In practice, almost nobody sets such names.
		step_name=$(awk '{print $1}' <<< "${step}")
		if [[ ${step_name} == test ]]; then
			found_test_step=true
			break
		fi
	done

	if [[ ${found_test_step} == true ]]; then
		ezig build test "${ZBS_ARGS[@]}" "${@}" || die "ZBS: tests failed"
	else
		einfo "Test step not found, skipping."
	fi

	popd > /dev/null || die
}

# @FUNCTION: zig-build_src_install
# @USAGE: [<args>...]
# @DESCRIPTION:
# Calls "ezig build install" with DESTDIR and previously set ZBS_ARGS.
# Args passed to this function will be passed after ZBS_ARGS.
# Also installs documentation via "einstalldocs".
zig-build_src_install() {
	pushd "${BUILD_DIR}" > /dev/null || die
	DESTDIR="${D}" ezig build install "${ZBS_ARGS[@]}" "${@}" || die "ZBS: installing failed"
	popd > /dev/null || die

	pushd "${S}" > /dev/null || die
	einstalldocs
	popd > /dev/null || die
}

fi

if [[ ! ${ZIG_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_test src_install
fi
