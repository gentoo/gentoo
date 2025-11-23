#!/bin/bash
# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit zig-utils

# Set ZIG_TEST_COMPILATION env-var to "1" if you want to test binary
# compilation and running under QEMU. Assumes "zig" is present in PATH
# and qemu binfmt is enabled.
#
# If CPU is marked with ":no-run", it means program compiled for it
# successfully but crashed when running under QEMU.
if [[ "${ZIG_TEST_COMPILATION:-0}" -eq 1 ]]; then
	MY_WORKDIR="$(mktemp -d)"
	my_cleanup() {
		popd > /dev/null
		rm -rf "${MY_WORKDIR}"
	}
	trap 'my_cleanup' EXIT

	pushd "${MY_WORKDIR}" > /dev/null || die
	cat <<- _EOF_ > main.zig || die
		const std = @import("std");

		pub fn main() !void {
			const stdout = std.io.getStdOut();
			try stdout.writeAll("Hello, Gentoo!\n");
		}
	_EOF_

	zig_test_compile_and_run() {
		eindent
		einfo "${1}: ${2}"
		eoutdent

		if [[ "${2}" == native* ]]; then
			return 0
		fi

		if [[ "${1}" == arm* ]]; then
			# Bunch of unimplemented Zig
			# routines for more "bare-bone" arm.
			case "${2}" in
				# Some errors in inline assembly, likely too low baseline
				generic-soft_float | generic+soft_float) return 0;;
				# undefined symbol: __sync_fetch_and_add_1
				# compiler-rt not implemented in upstream for it yet:
				# https://github.com/ziglang/zig/issues/4959
				generic+v5te-soft_float) return 0;;
				*) ;;
			esac
		fi

		local ret=0

		local args=(
			-target "${1}"
			-mcpu "${2//:no-run/}"
			main.zig
		)
		if ! zig build-exe "${args[@]}" > /dev/null; then
			eerror "Failed to compile for: ${1}, ${2}"
			((++ret))
			return ${ret}
		fi

		# Can't run macOS binaries in Linux user-mode QEMU emulators
		if [[ "${1}" == *macos* || "${2}" == *":no-run" ]]; then
			return ${ret}
		fi

		if ! ./main > /dev/null; then
			eerror "Failed to run for: ${1}, ${2}"
			((++ret))
		fi

		return ${ret}
	}
else
	zig_test_compile_and_run() { :; }
fi

test-convert_c_env_to_zig_tuple() {
	local ret=0

	local -n map=${1}

	local c_tuple
	for key in "${!map[@]}"; do
		local expected="${map["${key}"]}"

		local c_tuple
		local c_flags
		if [[ "${key}" == *:* ]]; then
			c_tuple="${key%%:*}"
			c_flags="${key##*:}"
		else
			c_tuple="${key}"
			c_flags=""
		fi

		local actual="$(zig-utils_c_env_to_zig_target "${c_tuple}" "${c_flags}")"
		if [[ "${expected}" != "${actual}" ]]; then
			eerror "Translating ${c_tuple}: expected ${expected}, found ${actual}"
			((++ret))
			continue
		fi

		local zig_cpu="$(zig-utils_c_env_to_zig_cpu "${c_tuple}" "${c_flags}")"
		if ! zig_test_compile_and_run "${expected}" "${zig_cpu}"; then
			((++ret))
			continue
		fi
	done

	return ${ret}
}

test-convert_c_env_to_zig_cpu() {
	local ret=0

	local -n map=${1}
	local chost=${2}

	local c_flags
	for c_flags in "${!map[@]}"; do
		local expected="${map["${c_flags}"]}"
		local actual="$(zig-utils_c_env_to_zig_cpu "${chost}" "${c_flags}")"
		if [[ "${expected//:no-run/}" != "${actual}" ]]; then
			eerror "Translating ${c_flags}: expected ${expected//:no-run/}, found ${actual}"
			((++ret))
			continue
		fi

		local zig_target="$(zig-utils_c_env_to_zig_target "${chost}" "${c_flags}")"
		if ! zig_test_compile_and_run "${zig_target}" "${expected}"; then
			((++ret))
			continue
		fi
	done

	return ${ret}
}

tbegin '"C tuple to Zig tuple"'
declare -A c_to_zig_map=(
	# Just remove "vendor" field
	[aarch64-unknown-linux-gnu]=aarch64-linux-gnu
	[arm-unknown-linux-musleabi]=arm-linux-musleabi
	[x86_64-pc-linux-gnu]=x86_64-linux-gnu
	[loongarch64-unknown-linux-gnu]=loongarch64-linux-gnu
	[powerpc64le-unknown-linux-gnu]=powerpc64le-linux-gnu

	# ARM big-endian
	[armeb-unknown-linux-gnueabi]=armeb-linux-gnueabi

	# https://bugs.gentoo.org/924920
	[armv7a-unknown-linux-gnueabihf]=arm-linux-gnueabihf

	# ARM to Thumb
	[arm-unknown-linux-musleabi:"-march=armv7e-m"]=thumb-linux-musleabi

	# ARM families
	[armv6j-unknown-linux-gnueabihf]=arm-linux-gnueabihf
	[armv6j-linux-gnueabihf]=arm-linux-gnueabihf
	[armv7a-softfp-linux-gnueabi]=arm-linux-gnueabi
	[armv7a-linux-gnueabi]=arm-linux-gnueabi

	# X86 (32-bit) families
	[i486-pc-linux-gnu]=x86-linux-gnu
	[i686-linux-gnu]=x86-linux-gnu

	# MacOS
	[x86_64-apple-darwin15]=x86_64-macos-none
	[arm64-apple-darwin24]=aarch64-macos-none
)
test-convert_c_env_to_zig_tuple c_to_zig_map
tend ${?}

tbegin '"CFLAGS to Zig CPU for ARM"'
CHOST="armv7a-unknown-linux-musleabihf"
c_to_zig_map=(
	[" "]="generic-soft_float"
	["-mcpu=native"]="native-soft_float"
	["-mcpu=cortex-a9"]="cortex_a9-soft_float"

	["-mcpu=cortex-a9 -march=iwmmxt2"]="cortex_a9+iwmmxt2-soft_float"

	["-march=armv7e-m"]="generic+v7em-soft_float"
	["-march=armv5te"]="generic+v5te-soft_float"
	["-march=armv6j -mfpu=vfp"]="generic+v6j+vfp2-soft_float"
	["-march=armv7-a -mfpu=vfpv3-d16"]="generic+v7a+vfp3d16-soft_float"
	["-march=armv7-a -mfpu=crypto-neon-fp-armv8"]="generic+v7a+crypto+neon+fp_armv8-soft_float"

	# https://bugs.gentoo.org/924920
	["-march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard"]=generic+v7a+vfp3d16-soft_float

	["-march=armv7-a -march=unset"]="generic-soft_float"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for AARCH64"'
CHOST="aarch64-unknown-linux-gnu"
c_to_zig_map=(
	[" "]="generic"
	["-mcpu=native"]="native"
	["-mcpu=cortex-a78"]="cortex_a78"

	["-march=armv8.3-a"]="generic+v8_3a"
	["-mcpu=cortex-a78 -march=armv8.3-a"]="cortex_a78+v8_3a"

	["-march=native"]="native"
	["-march=native -mtune=native"]="generic"
	["-mcpu=cortex-a78 -march=native"]="cortex_a78"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for X86"'
CHOST="i686-pc-linux-gnu"
c_to_zig_map=(
	[" "]="i686"
	["-march=native"]="native"

	["-march=i486"]="i486"
	["-march=i586"]="i586"
	["-march=i686"]="i686"
	["-O2 -pipe -march=pentium-m"]="pentium_m"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for X86-64"'
CHOST="x86_64-pc-linux-gnu"
c_to_zig_map=(
	[" "]="x86_64"
	["-march=native"]="native"

	["-march=x86-64-v2"]="x86_64_v2"
	["-march=x86-64"]="x86_64"
	["-march=znver2"]="znver2"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for RISCV32"'
CHOST="riscv32-unknown-linux-gnu"
c_to_zig_map=(
	[" "]="generic_rv32"
	["-mcpu=native"]="native"
	["-mcpu=sifive-e31"]="sifive_e31"

	["-mabi=ilp32d -march=rv32imafdc"]="generic_rv32+i+m+a+f+d+c+d"
	["-mcpu=native -mabi=ilp32 -march=rv32imac"]="native+i+m+a+c"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for RISCV64"'
CHOST="riscv64-unknown-linux-gnu"
c_to_zig_map=(
	[" "]="generic_rv64"
	["-mcpu=native"]="native"
	["-mcpu=sifive-u74"]="sifive_u74"

	["-mabi=lp64 -march=rv64imac"]="generic_rv64+i+m+a+c"
	["-mabi=lp64d -march=rv64gc"]="generic_rv64+i+m+a+f+d+zicsr+zifencei+c+d"
	["-march=rv64gcv"]="generic_rv64+i+m+a+f+d+zicsr+zifencei+c+v"
	["-march=rv64imafdc -mcpu=sifive-u74"]="sifive_u74+i+m+a+f+d+c"
	["-mcpu=native -mabi=lp64 -march=rv64imac"]="native+i+m+a+c"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for LoongArch64"'
CHOST="loongarch64-unknown-linux-gnu"
c_to_zig_map=(
	[" "]="generic_la64"
	["-march=native"]="native"
	["-march=la664"]="la664"

	["-march=loongarch64 -mabi=lp64d"]="loongarch64+d"
	["-mabi=lp64f"]="generic_la64+f"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for PowerPC"'
CHOST="powerpc-unknown-linux-gnu"
c_to_zig_map=(
	[" "]="ppc"
	["-mcpu=native"]="native"

	["-mcpu=G5"]="g5"

	# qemu: uncaught target signal 4 (Illegal instruction) - core dumped
	["-mcpu=power7"]="pwr7:no-run"
	["-mcpu=power8"]="pwr8:no-run"

	["-mcpu=powerpc"]="ppc"
	["-mcpu=powerpcle"]="ppc"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

tbegin '"CFLAGS to Zig CPU for PowerPC64"'
CHOST="powerpc64-unknown-linux-gnu"
c_to_zig_map=(
	[" "]="ppc64"
	["-mcpu=native"]="native"

	# qemu: uncaught target signal 4 (Illegal instruction) - core dumped
	["-mcpu=power10"]="pwr10:no-run"

	["-mcpu=power9"]="pwr9"
	["-mcpu=powerpc64"]="ppc64"
	["-mcpu=powerpc64le"]="ppc64le"
)
test-convert_c_env_to_zig_cpu c_to_zig_map "${CHOST}"
tend ${?}

texit
