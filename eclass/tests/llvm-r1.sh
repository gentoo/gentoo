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
		eerror "llvm_gen_dep ${arg}"
		eerror "gave:"
		eerror "  ${value}"
		eerror "expected:"
		eerror "  ${expected}"
	fi
	tend ${?}
}

# full range
test_globals '14 15 16 17 18 19' \
	"+llvm_slot_19 llvm_slot_15 llvm_slot_16 llvm_slot_17 llvm_slot_18" \
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
test_globals '15 20' \
	"+llvm_slot_15 llvm_slot_20" \
	"^^ ( llvm_slot_15 llvm_slot_20 )" \
	"llvm_slot_15(-)?,llvm_slot_20(-)?"
# newer than current stable
test_globals '19' \
	"+llvm_slot_19" \
	"^^ ( llvm_slot_19 )" \
	"llvm_slot_19(-)?"

LLVM_COMPAT=( {14..18} )
inherit llvm-r1

test_gen_dep 'llvm-core/llvm:${LLVM_SLOT} llvm-core/clang:${LLVM_SLOT}' <<-EOF
	llvm_slot_15? ( llvm-core/llvm:15 llvm-core/clang:15 )
	llvm_slot_16? ( llvm-core/llvm:16 llvm-core/clang:16 )
	llvm_slot_17? ( llvm-core/llvm:17 llvm-core/clang:17 )
	llvm_slot_18? ( llvm-core/llvm:18 llvm-core/clang:18 )
EOF

texit
