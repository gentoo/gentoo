# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: zig-toolchain.eclass
# @MAINTAINER:
# Eric Joldasov <bratishkaerik@landless-city.net>
# @AUTHOR:
# Eric Joldasov <bratishkaerik@landless-city.net>
# @SUPPORTED_EAPIS: 8
# @BLURB: Prepare Zig toolchain and set environment variables.
# @DESCRIPTION:
# Prepare Zig toolchain and set environment variables. Supports Zig 0.13+.
# Does not set any default function, ebuilds must call them manually.
# Generally, only "zig-toolchain_populate_env_vars" is needed.
#
# Intended to be used by ebuilds that call "zig build-exe/lib/obj"
# or "zig test" directly and by "dev-lang/zig".
# For ebuilds with ZBS (Zig Build System), it's usually better
# to inherit zig-build instead, as it has default phases-functions.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_ZIG_TOOLCHAIN_ECLASS} ]]; then
_ZIG_TOOLCHAIN_ECLASS=1

inherit edo flag-o-matic

# @ECLASS_VARIABLE: ZIG_SLOT
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# Zig slot that will be used in "ezig" function. Also, if ZIG_OPTIONAL is
# empty, adds dev-lang/zig and dev-lang/zig-bin dependency to BDEPEND.
# Must be >= "0.13".
#
# Example:
# @CODE
# 0.13
# @CODE
#
# When a new Zig release occurs, it is advisable for maintainers to
# check whether their ebuild supports that new version. If yes, they
# they should bump ZIG_SLOT to the latest version; if not supported,
# they need to patch any issues with new version and again bump ZIG_SLOT.
# This helps to reduce dependencies on outdated Zig versions.
#
# This policy of "1 exclusive Zig slot" will work until it
# stabilizes enough (probably near 1.0), then it will be re-evaluated
# and most likely changed to more common in other eclasses ZIG_MIN/
# ZIG_MAX form.

# @ECLASS_VARIABLE: ZIG_OPTIONAL
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-empty value, all logic in zig-toolchain and zig-build
# eclasses will be considered optional. No dependencies will be added and
# no phase functions will be exported.
#
# For zig-toolchain.eclass users:
# You have to add Zig dependency in your BDEPEND manually and call
# at least "zig-toolchain_populate_env_vars" before using "ezig".
#
# For zig-build.eclass users: see documentation in zig-build.eclass instead.
if [[ ! ${ZIG_OPTIONAL} ]]; then
	BDEPEND+=" || (
		dev-lang/zig:${ZIG_SLOT}
		dev-lang/zig-bin:${ZIG_SLOT}
	)"
fi

# @ECLASS_VARIABLE: ZIG_TARGET
# @DESCRIPTION:
# Zig target triple to use. Has the following format:
# arch-os[.os_version_range]-abi[.abi_version]
# Can be passed as:
# * "-target " option in "zig test" or "zig build-exe/lib/obj",
# * "-Dtarget=" option in "zig build" (if project uses "std.Build.standardTargetOptions").
#
# Can be overriden by user. If not overriden, then set by "zig-toolchain_populate_env_vars".
#
# Example:
# @CODE
# native # autodetected by Zig
# x86_64-linux-gnu # Machine running Linux x86_64 system, with glibc
# x86_64-linux.6.1.12...6.6.16-gnu.2.38 # Similar to above, but versions are passed explicitly
# powerpc64le-linux-musl # Machine running Linux 64-bit little-endian PowerPC system, with musl
# @CODE
#

# @ECLASS_VARIABLE: ZIG_CPU
# @DESCRIPTION:
# Zig target CPU and features to use. Has the following format:
# family_name(\+enable_feature|\-disable_feature)*
# Can be passed as:
# * "-mcpu " option in "zig test" or "zig build-exe/lib/obj",
# * "-Dcpu=" option in "zig build" (if project uses "std.Build.standardTargetOptions").
#
# Can be overriden by user. If not overriden, then set by "zig-toolchain_populate_env_vars".
#
# Example:
# @CODE
# native # autodetected by Zig
# znver2 # AMD Zen 2 processor
# x86_64+x87-sse2" # x86_64 processor, X87 support enabled, SSE2 support disabled
# @CODE

# @ECLASS_VARIABLE: ZIG_EXE
# @DESCRIPTION:
# Absolute path to the used Zig executable.
#
# Please note that when passing one flag several times with different values:
# * to "zig build" in "-Dbar=false -Dbar" form: errors due to conflict of flags,
# * to "zig build" in "-Dbar=false -Dbar=true" form: "bar" becomes a list, which is likely not what you (or upstream) want,
# * to "zig test" or "zig build-exe/lib/obj" in "-fbar -fno-bar" form: latest value overwrites values before.
# Similar situation with other types of options (enums, "std.SemanticVersion", integers, strings, etc.)
#
# Can be overriden by user. If not overriden, then set by "zig-toolchain_populate_env_vars".

# @ECLASS_VARIABLE: ZIG_VER
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Zig version found during "zig-toolchain_find_installation", as reported in dev-lang/zig-${PV} PV part.
#
# Example:
# @CODE
# 0.13.0
# @CODE

# @FUNCTION: zig-toolchain_get_target
# @USAGE: <C-style target triple>
# @DESCRIPTION:
# Translates C-style target triple (like CHOST or CBUILD)
# to Zig-style target triple. Some information (like ARM features)
# is handled by "zig-toolchain_get_cpu". Mostly used during cross-compiling
# if user does not set ZIG_TARGET variable.
#
# See ZIG_TARGET description for more information.
zig-toolchain_get_target() {
	[[ ${#} -eq 1 ]] || die "${FUNCNAME[0]}: exactly one argument must be passed"
	local c_target=${1}
	local c_target_prefix=${c_target%%-*}
	local c_target_suffix=${c_target##*-}

	local arch os abi

	case ${c_target_prefix} in
		i?86)	arch=x86;;
		arm64)	arch=aarch64;;
		arm*)	arch=arm;;
		*)	arch=${c_target_prefix};;
	esac

	case ${c_target} in
		*linux*)	os=linux;;
		*apple*)	os=macos;;
	esac

	case ${c_target_suffix} in
		solaris*)	os=solaris abi=none;;
		darwin*)	abi=none;;
		*)		abi=${c_target_suffix};;
	esac

	[[ ${arch} == arm && ${abi} == gnu ]] && die "${FUNCNAME[0]}: Zig does not support old ARM ABI"

	echo ${arch}-${os}-${abi}
}



# @FUNCTION: zig-toolchain_get_cpu
# @USAGE: <C-style target triple>
# @DESCRIPTION:
# Translates C-style target triple (like CHOST or CBUILD)
# to Zig-style target CPU and features. Mostly used to get generic target CPU
# during cross-compiling if user does not set ZIG_CPU variable.
#
# See ZIG_CPU description for more information.
zig-toolchain_get_cpu() {
	[[ ${#} -eq 1 ]] || die "${FUNCNAME[0]}: exactly one argument must be passed"
	local c_target=${1}
	local c_target_prefix=${c_target%%-*}

	local base_cpu features=""

	case ${c_target_prefix} in
		i?86)					base_cpu=${c_target_prefix};;
		loongarch64)			base_cpu=generic_la64;;
		powerpc | powerpcle)	base_cpu=ppc;;
		powerpc64)				base_cpu=ppc64;;
		powerpc64le)			base_cpu=ppc64le;;
		riscv32)				base_cpu=generic_rv32;;
		riscv64)				base_cpu=generic_rv64;;
		*)						base_cpu=generic;;
	esac

	case ${c_target_prefix} in
		armv5tel)	features+="+v5te";;
		armv*)		features+="+${c_target_prefix##armv}";;
	esac

	case ${c_target_prefix} in
		arm64)	;;
		arm*)
			local is_softfloat=$(CTARGET=${c_target} tc-tuple-is-softfloat)
			case ${is_softfloat} in
				only | yes) features+="+soft_float";;
				softfp | no) features+="-soft_float";;
				*) die "${FUNCNAME[0]}: tc-tuple-is-softfloat returned unexpected value"
			esac
		;;
	esac

	echo ${base_cpu}${features}
}

# @FUNCTION: zig-toolchain_find_installation
# @DESCRIPTION:
# Detects suitable Zig installation and sets ZIG_VER and ZIG_EXE variables.
#
# See ZIG_EXE and ZIG_VER descriptions for more information.
zig-toolchain_find_installation() {
	# Adapted from https://github.com/gentoo/gentoo/pull/28986
	# Many thanks to Florian Schmaus (Flowdalic)!

	[[ -n ${ZIG_SLOT} ]] || die "${FUNCNAME[0]}: ZIG_SLOT must be set"
	if ver_test "${ZIG_SLOT}" -lt "0.13"; then
		die "${ECLASS}: ZIG_SLOT must be >= 0.13, found ${ZIG_SLOT}"
	fi

	einfo "Searching Zig ${ZIG_SLOT}..."

	local zig_supported_versions=(
		"9999"
		"0.13.1"
		"0.13.0"
	)

	local selected_path selected_version
	for selected_version in "${zig_supported_versions[@]}"; do
		# Compare with ZIG_SLOT (like 0.13)
		local candidate_slot=$(ver_cut 1-2 ${selected_version})
		if ver_test "${candidate_slot}" -ne ${ZIG_SLOT}; then
			# Candidate does not satisfy ZIG_SLOT condition.
			continue
		fi

		# Prefer "dev-lang/zig" over "dev-lang/zig-bin"
		local candidate_path="${BROOT}/usr/bin/zig-${selected_version}"
		if [[ -x "${candidate_path}" ]]; then
			selected_path="${candidate_path}"
			break;
		fi

		candidate_path="${BROOT}/usr/bin/zig-bin-${selected_version}"
		if [[ -x "${candidate_path}" ]]; then
			selected_path="${candidate_path}"
			break;
		fi
	done

	if [[ -z "${selected_path}" ]]; then
		die "Could not find (suitable) Zig installation in \"${BROOT}/usr/bin/\""
	fi

	export ZIG_EXE="${selected_path}"
	export ZIG_VER="${selected_version}"
	# Sanity check, from upstream:
	# // Check libc++ linkage to make sure Zig was built correctly, but only
	# // for "env" and "version" to avoid affecting the startup time for
	# // build-critical commands (check takes about ~10 μs)
	"${ZIG_EXE}" version > /dev/null || die "Sanity check failed for \"${ZIG_EXE}\""
}

# @FUNCTION: zig-toolchain_populate_env_vars
# @DESCRIPTION:
# Populates ZIG_TARGET, ZIG_CPU, ZIG_EXE and ZIG_VER environment
# variables with detected values, or, if user set them already,
# leaves as-is.
zig-toolchain_populate_env_vars() {
	# Should be first because it sets ZIG_VER which might be used in the future
	# when setting ZIG_TARGET and ZIG_CPU variables for incompatible versions.
	if [[ -z "${ZIG_EXE}" ]]; then
		zig-toolchain_find_installation
	fi

	if [[ -z ${ZIG_TARGET} ]]; then
		if tc-is-cross-compiler; then
			export ZIG_TARGET=$(zig-toolchain_get_target ${CHOST})
		else
			export ZIG_TARGET=native
		fi
	fi

	if [[ -z ${ZIG_CPU} ]]; then
		if tc-is-cross-compiler; then
			export ZIG_CPU=$(zig-toolchain_get_cpu ${CHOST})
		else
			export ZIG_CPU=native
		fi
	fi

	einfo "ZIG_EXE:    \"${ZIG_EXE}\""
	einfo "ZIG_VER:     ${ZIG_VER}"
	einfo "ZIG_TARGET:  ${ZIG_TARGET}"
	einfo "ZIG_CPU:     ${ZIG_CPU}"
}

# @FUNCTION: ezig
# @USAGE: [<args>...]
# @DESCRIPTION:
# Runs ZIG_EXE with supplied arguments. Dies if ZIG_EXE is not set.
#
# Always disables progress bar (tree in 0.13+).
# By default enables ANSI escape codes (colours, etc.), set NO_COLOR
# environment variable to disable them.
ezig() {
	# Sync description above and comments below with "std.io.tty.detectConfig".
        debug-print-function "${FUNCNAME[0]}" "${@}"

	if [[ -z "${ZIG_EXE}" ]] ; then
		die "${FUNCNAME[0]}: ZIG_EXE is not set. Was 'zig-toolchain_populate_env_vars' called before using ezig?"
	fi

	# Progress bar (tree in newer versions) are helpful indicators in
	# TTY, but unfortunately they make Portage logs harder to read in plaintext.
	# We pass "TERM=dumb" here to have clean logs, and CLICOLOR_FORCE (or YES_COLOR
	# until 0.13) to preserve colors.
	# User's NO_COLOR takes precendence over this.
	TERM=dumb YES_COLOR=1 CLICOLOR_FORCE=1 "${ZIG_EXE}" "${@}"
}
fi
