#!/bin/bash
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh || exit

EAPI=8

inherit llvm-utils

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

test_fix_clang_version CC clang 19.0.0git78b4e7c5 clang-19
test_fix_clang_version CC clang 17.0.6 clang-17
test_fix_clang_version CXX clang++ 17.0.6 clang++-17
test_fix_clang_version CC x86_64-pc-linux-gnu-clang 17.0.6 \
	x86_64-pc-linux-gnu-clang-17
test_fix_clang_version CC clang-17 n/a clang-17
test_fix_clang_version CC gcc n/a gcc

test_fix_tool_path AR llvm-ar 1
test_fix_tool_path RANLIB llvm-ranlib 1
test_fix_tool_path AR ar 1
test_fix_tool_path AR ar 0

texit
