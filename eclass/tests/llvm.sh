#!/bin/bash
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
source tests-common.sh

inherit llvm

# llvm_check_deps override to disable has_version use.
# in: ${LLVM_SLOT}
# returns 0 if installed (i.e. == LLVM_INSTALLED_SLOT), 1 otherwise
llvm_check_deps() {
	[[ ${LLVM_SLOT} == ${LLVM_INSTALLED_SLOT} ]]
}

# check_prefix <expected> [<args>...]
# Check output of `get_llvm_prefix <args>...`.
check_prefix() {
	local expected=${1}
	shift

	tbegin "get_llvm_prefix ${*}; inst=${LLVM_INSTALLED_SLOT} -> ${expected}"
	prefix=$(get_llvm_prefix "${@}")
	[[ ${prefix} == ${expected} ]] ||
		eerror "got: ${prefix} != exp: ${expected}"
	tend ${?}
}

# check_setup_path <expected>
# Check PATH after pkg_setup.
check_setup_path() {
	local expected=${1}
	shift

	tbegin "pkg_setup; max=${LLVM_MAX_SLOT}; inst=${LLVM_INSTALLED_SLOT} -> PATH=${expected}"
	path=$(llvm_pkg_setup; echo "${PATH}")
	[[ ${path} == ${expected} ]] ||
		eerror "got: ${path} != exp: ${expected}"
	tend ${?}
}


EAPI=7
BROOT=/broot
SYSROOT=/sysroot
ESYSROOT=/sysroot/eprefix
ROOT=/root
EROOT=/root/eprefix

ebegin "Testing check_setup_path without max slot"
eindent
	LLVM_INSTALLED_SLOT=11 \
	check_prefix /sysroot/eprefix/usr/lib/llvm/11
	LLVM_INSTALLED_SLOT=10 \
	check_prefix /sysroot/eprefix/usr/lib/llvm/10
eoutdent

ebegin "Testing check_setup_path with max slot"
eindent
	LLVM_INSTALLED_SLOT=1* \
	check_prefix /sysroot/eprefix/usr/lib/llvm/11 11
	LLVM_INSTALLED_SLOT=1* \
	check_prefix /sysroot/eprefix/usr/lib/llvm/10 10
	LLVM_INSTALLED_SLOT=10 \
	check_prefix /sysroot/eprefix/usr/lib/llvm/10 11
eoutdent

ebegin "Testing check_setup_path option switches"
eindent
	LLVM_INSTALLED_SLOT=11 \
	check_prefix /broot/usr/lib/llvm/11 -b
	LLVM_INSTALLED_SLOT=11 \
	check_prefix /sysroot/eprefix/usr/lib/llvm/11 -d
eoutdent

ebegin "Testing check_setup_path EAPI 6 API"
eindent
	EAPI=6 \
	LLVM_INSTALLED_SLOT=11 \
	check_prefix /usr/lib/llvm/11 -d
eoutdent

BASEPATH=/usr/lib/ccache/bin:/usr/bin:/usr/sbin:/bin:/sbin

# TODO: cross support?
ESYSROOT=

ebegin "Testing pkg_setup with all installed LLVM versions in PATH"
eindent
	LLVM_MAX_SLOT=11 \
	LLVM_INSTALLED_SLOT=1* \
	PATH=${BASEPATH}:/usr/lib/llvm/11/bin \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/11/bin"

	LLVM_MAX_SLOT=10 \
	LLVM_INSTALLED_SLOT=1* \
	PATH=${BASEPATH}:/usr/lib/llvm/11/bin:/usr/lib/llvm/10/bin \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/10/bin:/usr/lib/llvm/11/bin"

	LLVM_MAX_SLOT=11 \
	LLVM_INSTALLED_SLOT=10 \
	PATH=${BASEPATH}:/usr/lib/llvm/10/bin \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/10/bin"
eoutdent

ebegin "Testing pkg_setup with the other LLVM version in PATH"
eindent
	LLVM_MAX_SLOT=11 \
	LLVM_INSTALLED_SLOT=1* \
	PATH=${BASEPATH}:/usr/lib/llvm/10/bin \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/11/bin:/usr/lib/llvm/10/bin"

	LLVM_MAX_SLOT=10 \
	LLVM_INSTALLED_SLOT=1* \
	PATH=${BASEPATH}:/usr/lib/llvm/11/bin \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/10/bin:/usr/lib/llvm/11/bin"
eoutdent

ebegin "Testing pkg_setup with LLVM missing from PATH"
eindent
	LLVM_MAX_SLOT=11 \
	LLVM_INSTALLED_SLOT=1* \
	PATH=${BASEPATH} \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/11/bin"

	LLVM_MAX_SLOT=10 \
	LLVM_INSTALLED_SLOT=1* \
	PATH=${BASEPATH} \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/10/bin"

	LLVM_MAX_SLOT=11 \
	LLVM_INSTALLED_SLOT=10 \
	PATH=${BASEPATH} \
	check_setup_path "${BASEPATH}:/usr/lib/llvm/10/bin"
eoutdent

texit
