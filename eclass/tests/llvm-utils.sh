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

test_prepend_path() {
	local slot=${1}
	local -x PATH=${2}
	local expected=${3}

	tbegin "llvm_prepend_path ${slot} to PATH=${PATH}"
	llvm_prepend_path "${slot}"
	if [[ ${PATH} != ${expected} ]]; then
		eerror "llvm_prepend_path ${var}"
		eerror "    gave: ${PATH}"
		eerror "expected: ${expected}"
	fi
	tend ${?}
}

TMPDIR=$(mktemp -d)
trap 'rm -r "${TMPDIR}"' EXIT

for x in clang-19 clang-17 clang++-17 x86_64-pc-linux-gnu-clang-17; do
	> "${TMPDIR}/${x}" || die
done
chmod +x "${TMPDIR}"/* || die
export PATH=${TMPDIR}:${PATH}

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

ESYSROOT=
einfo "Testing with ESYSROOT=${ESYSROOT}"
eindent
test_prepend_path 17 /usr/bin /usr/bin:/usr/lib/llvm/17/bin
test_prepend_path 17 /usr/lib/llvm/17/bin:/usr/bin /usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 17 /usr/bin:/usr/lib/llvm/17/bin /usr/bin:/usr/lib/llvm/17/bin
test_prepend_path 17 /usr/lib/llvm/17/bin:/usr/bin:/usr/lib/llvm/17/bin \
	/usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 17 /usr/lib/llvm/17/bin:/usr/lib/llvm/17/bin:/usr/bin \
	/usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 17 /usr/bin:/usr/lib/llvm/17/bin:/usr/lib/llvm/17/bin \
	/usr/bin:/usr/lib/llvm/17/bin
test_prepend_path 18 /usr/lib/llvm/17/bin:/usr/bin \
	/usr/lib/llvm/18/bin:/usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 18 /usr/bin:/usr/lib/llvm/17/bin \
	/usr/bin:/usr/lib/llvm/18/bin:/usr/lib/llvm/17/bin
test_prepend_path 18 /usr/lib/llvm/17/bin:/usr/lib/llvm/16/bin:/usr/bin \
	/usr/lib/llvm/18/bin:/usr/lib/llvm/17/bin:/usr/lib/llvm/16/bin:/usr/bin
test_prepend_path 18 /usr/bin:/usr/lib/llvm/17/bin:/usr/lib/llvm/16/bin \
	/usr/bin:/usr/lib/llvm/18/bin:/usr/lib/llvm/17/bin:/usr/lib/llvm/16/bin
test_prepend_path 18 /usr/lib/llvm/17/bin:/usr/bin:/usr/lib/llvm/16/bin \
	/usr/lib/llvm/18/bin:/usr/lib/llvm/17/bin:/usr/bin:/usr/lib/llvm/16/bin
eoutdent

ESYSROOT=/foo
einfo "Testing with ESYSROOT=${ESYSROOT}"
eindent
test_prepend_path 17 /usr/bin /usr/bin:/foo/usr/lib/llvm/17/bin
test_prepend_path 17 /usr/lib/llvm/17/bin:/usr/bin \
	/foo/usr/lib/llvm/17/bin:/usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 17 /usr/bin:/usr/lib/llvm/17/bin: \
	/usr/bin:/foo/usr/lib/llvm/17/bin:/usr/lib/llvm/17/bin
test_prepend_path 17 /foo/usr/lib/llvm/17/bin:/usr/bin \
	/foo/usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 17 /usr/bin:/foo/usr/lib/llvm/17/bin: \
	/usr/bin:/foo/usr/lib/llvm/17/bin
test_prepend_path 18 /usr/lib/llvm/17/bin:/usr/bin \
	/foo/usr/lib/llvm/18/bin:/usr/lib/llvm/17/bin:/usr/bin
test_prepend_path 18 /foo/usr/lib/llvm/17/bin:/usr/bin \
	/foo/usr/lib/llvm/18/bin:/foo/usr/lib/llvm/17/bin:/usr/bin
eoutdent

texit
