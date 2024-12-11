#!/bin/bash
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh || exit

EAPI=8

test_globals() {
	local compat=${1}
	local expected_iuse=${2}
	local expected_required_use=${3}
	local expected_usedep=${4}
	local x

	tbegin "LLVM_COMPAT=( ${compat} )"

	(
		local fail=0
		local LLVM_COMPAT=( ${compat} )

		inherit llvm-r1

		if [[ ${IUSE%% } != ${expected_iuse} ]]; then
			eerror "          IUSE: ${IUSE%% }"
			eerror "does not match: ${expected_iuse}"
			fail=1
		fi

		if [[ ${REQUIRED_USE} != ${expected_required_use} ]]; then
			eerror "  REQUIRED_USE: ${REQUIRED_USE}"
			eerror "does not match: ${expected_required_use}"
			fail=1
		fi

		if [[ ${LLVM_USEDEP} != ${expected_usedep} ]]; then
			eerror "   LLVM_USEDEP: ${LLVM_USEDEP}"
			eerror "does not match: ${expected_usedep}"
			fail=1
		fi

		exit "${fail}"
	)

	tend "${?}"
}

test_gen_dep() {
	local arg=${1}
	local expected
	read -r -d '' expected

	tbegin "llvm_gen_dep ${arg}"
	local value=$(llvm_gen_dep "${arg}")

	if [[ ${value} != ${expected} ]]; then
		eerror "python_get_usedep ${arg}"
		eerror "gave:"
		eerror "  ${value}"
		eerror "expected:"
		eerror "  ${expected}"
	fi
	tend ${?}
}

test_fix_clang_version() {
	local var=${1}
	local tool=${2}
	local version=${3}
	local expected=${4}

	eval "${tool}() {
		cat <<-EOF
			clang version ${version}
			Target: x86_64-pc-linux-gnu
			Thread model: posix
			InstalledDir: /usr/lib/llvm/17/bin
			Configuration file: /etc/clang/x86_64-pc-linux-gnu-clang.cfg
		EOF
	}"

	declare -g ${var}=${tool}
	tbegin "llvm_fix_clang_version ${var}=${tool} for ${version}"
	llvm_fix_clang_version "${var}"
	if [[ ${!var} != ${expected} ]]; then
		eerror "llvm_fix_clang_version ${var}"
		eerror "    gave: ${!var}"
		eerror "expected: ${expected}"
	fi
	tend ${?}
}

test_fix_tool_path() {
	local var=${1}
	local tool=${2}
	local expected_subst=${3}
	local expected=${tool}

	tbegin "llvm_fix_tool_path ${1}=${2} (from llvm? ${expected_subst})"

	local matches=( "${BROOT}"/usr/lib/llvm/*/bin/"${tool}" )
	if [[ ${expected_subst} == 1 ]]; then
		if [[ ! -x ${matches[0]} ]]; then
			ewarn "- skipping, test requires ${tool}"
			return
		fi

		expected=${matches[0]}
		local -x PATH=${matches[0]%/*}
	else
		local -x PATH=
	fi

	declare -g ${var}=${tool}
	llvm_fix_tool_path "${var}"
	if [[ ${!var} != ${expected} ]]; then
		eerror "llvm_fix_tool_path ${var}"
		eerror "    gave: ${!var}"
		eerror "expected: ${expected}"
	fi
	tend ${?}
}

# full range
test_globals '14 15 16 17 18 19' \
	"+llvm_slot_18 llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_19" \
	"^^ ( llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_18 llvm_slot_19 )" \
	"llvm_slot_15(-)?,llvm_slot_16(-)?,llvm_slot_17(-)?,llvm_slot_18(-)?,llvm_slot_19(-)?"
test_globals '14 15 16 17 18' \
	"+llvm_slot_18 llvm_slot_15 llvm_slot_16 llvm_slot_17" \
	"^^ ( llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_18 )" \
	"llvm_slot_15(-)?,llvm_slot_16(-)?,llvm_slot_17(-)?,llvm_slot_18(-)?"
# older than stable
test_globals '14 15 16' \
	"+llvm_slot_16 llvm_slot_15" \
	"^^ ( llvm_slot_15 llvm_slot_16 )" \
	"llvm_slot_15(-)?,llvm_slot_16(-)?"
# old + newer than current stable
test_globals '15 19' \
	"+llvm_slot_15 llvm_slot_19" \
	"^^ ( llvm_slot_15 llvm_slot_19 )" \
	"llvm_slot_15(-)?,llvm_slot_19(-)?"
# newer than current stable
test_globals '19' \
	"+llvm_slot_19" \
	"^^ ( llvm_slot_19 )" \
	"llvm_slot_19(-)?"

LLVM_COMPAT=( {14..18} )
inherit llvm-r1

test_gen_dep 'sys-devel/llvm:${LLVM_SLOT} llvm-core/clang:${LLVM_SLOT}' <<-EOF
	llvm_slot_15? ( sys-devel/llvm:15 llvm-core/clang:15 )
	llvm_slot_16? ( sys-devel/llvm:16 llvm-core/clang:16 )
	llvm_slot_17? ( sys-devel/llvm:17 llvm-core/clang:17 )
	llvm_slot_18? ( sys-devel/llvm:18 llvm-core/clang:18 )
EOF

texit
