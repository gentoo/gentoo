# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: llvm-utils.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: Common utility functions for building against installed LLVM
# @DESCRIPTION:
# The utility eclass providing shared functions reused between
# llvm.eclass and llvm-r1.eclass.  It may also be used directly
# in ebuilds.

if [[ -z ${_LLVM_UTILS_ECLASS} ]]; then
_LLVM_UTILS_ECLASS=1

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: llvm_tuple_to_target
# @USAGE: [<tuple>]
# @DESCRIPTION:
# Translate a tuple into a target suitable for LLVM_TARGETS.
# Defaults to ${CHOST} if not specified.
llvm_tuple_to_target() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -gt 1 ]] && die "Usage: ${FUNCNAME} [<tuple>]"

	case ${1:-${CHOST}} in
		aarch64*) echo "AArch64";;
		amdgcn*) echo "AMDGPU";;
		arc*) echo "ARC";;
		arm*) echo "ARM";;
		avr*) echo "AVR";;
		bpf*) echo "BPF";;
		csky*) echo "CSKY";;
		loong*) echo "LoongArch";;
		m68k*) echo "M68k";;
		mips*) echo "Mips";;
		msp430*) echo "MSP430";;
		nvptx*) echo "NVPTX";;
		powerpc*) echo "PowerPC";;
		riscv*) echo "RISCV";;
		sparc*) echo "Sparc";;
		s390*) echo "SystemZ";;
		x86_64*|i?86*) echo "X86";;
		xtensa*) echo "Xtensa";;
		*) die "Unknown LLVM target for tuple ${1:-${CHOST}}"
	esac
}

# @FUNCTION: llvm_fix_clang_version
# @USAGE: <variable-name>...
# @DESCRIPTION:
# Fix the clang compiler name in specified variables to include
# the major version, to prevent PATH alterations from forcing an older
# clang version being used.
llvm_fix_clang_version() {
	debug-print-function ${FUNCNAME} "$@"

	local shopt_save=$(shopt -p -o noglob)
	set -f
	local var
	for var; do
		local split=( ${!var} )
		case ${split[0]} in
			*clang|*clang++|*clang-cpp)
				local version=()
				read -r -a version < <("${split[0]}" --version)
				local major=${version[-1]%%.*}
				if [[ -n ${major//[0-9]} ]]; then
					die "${var}=${!var} produced invalid --version: ${version[*]}"
				fi

				split[0]+=-${major}
				if ! type -P "${split[0]}" &>/dev/null; then
					die "${split[0]} does not seem to exist"
				fi
				declare -g "${var}=${split[*]}"
				;;
		esac
	done
	${shopt_save}
}

# @FUNCTION: llvm_fix_tool_path
# @USAGE: <variable-name>...
# @DESCRIPTION:
# Fix the LLVM tools referenced in the specified variables to their
# current location, to prevent PATH alterations from forcing older
# versions being used.
llvm_fix_tool_path() {
	debug-print-function ${FUNCNAME} "$@"

	local shopt_save=$(shopt -p -o noglob)
	set -f
	local var
	for var; do
		local split=( ${!var} )
		local path=$(type -P ${split[0]} 2>/dev/null)
		# if it resides in one of the LLVM prefixes, it's an LLVM tool!
		if [[ ${path} == "${BROOT}/usr/lib/llvm"* ]]; then
			split[0]=${path}
			declare -g "${var}=${split[*]}"
		fi
	done
	${shopt_save}
}

# @FUNCTION: llvm_prepend_path
# @USAGE: [-b|-d] <slot>
# @DESCRIPTION:
# Prepend the path to the specified LLVM slot to PATH variable,
# and reexport it.
#
# With no option or "-d", the path is prefixed by ESYSROOT.  LLVM
# dependencies should be in DEPEND then.
#
# With "-b" option, the path is prefixed by BROOT. LLVM dependencies
# should be in BDEPEND then.
llvm_prepend_path() {
	debug-print-function ${FUNCNAME} "$@"

	local prefix=${ESYSROOT}
	case ${1} in
		-d)
			shift
			;;
		-b)
			prefix=${BROOT}
			shift
			;;
		-*)
			die "${FUNCNAME}: invalid option: ${1}"
			;;
	esac

	[[ ${#} -ne 1 ]] && die "Usage: ${FUNCNAME} [-b|-d] <slot>"
	local slot=${1}

	local llvm_path=${prefix}/usr/lib/llvm/${slot}/bin
	local IFS=:
	local split_path=( ${PATH} )
	local new_path=()
	local x added=

	for x in "${split_path[@]}"; do
		if [[ ${x} == */usr/lib/llvm/*/bin ]]; then
			# prepend new path in front of the first LLVM version found
			if [[ ! ${added} ]]; then
				new_path+=( "${llvm_path}" )
				added=1
			fi
			# remove duplicate copies of the same path
			if [[ ${x} == ${llvm_path} ]]; then
				# deduplicate
				continue
			fi
		fi
		new_path+=( "${x}" )
	done
	# ...or to the end of PATH
	[[ ${added} ]] || new_path+=( "${llvm_path}" )

	export PATH=${new_path[*]}
}

# @FUNCTION: llvm_cmake_use_musl
# @DESCRIPTION:
# Determine whether the given LLVM project should be built with musl
# support. That should be the case if the CTARGET (or CHOST) is a musl
# environment.
#
# If musl should be used, echo "ON", otherwise echo "OFF".
llvm_cmake_use_musl() {
	if [[ "${CTARGET:-${CHOST}}" == *-*-*-musl* ]]; then
		echo "ON"
	else
		echo "OFF"
	fi
}

fi
