#!/bin/bash
# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh

inherit multilib

# Run 'multilib_env' and check what variables it expands to
test-multilib_env() {
	local target=$1 exp_abi=$2 exp_vars=" $3"
	tbegin "expand-target $1"

	# Reset default
	unset MULTILIB_ABIS
	unset DEFAULT_ABI
	CFLAGS_default=
	LDFLAGS_default=
	LIBDIR_default=lib
	CHOST_default=${target}
	CTARGET_default=${CHOST_default}
	LIBDIR_default=lib

	multilib_env ${target}

	local actual_abi="${DEFAULT_ABI}:${MULTILIB_ABIS}"

	local actual_vars=""
	local abi var v
	for abi in ${MULTILIB_ABIS}; do
		actual_vars+=" ${abi}? ("
		for var in CHOST LIBDIR CFLAGS LDFLAGS; do
			v=${var}_${abi}
			actual_vars+=" ${var}=${!v}"
		done
		actual_vars+=" )"
	done

	[[ "${exp_abi}" == "${actual_abi}" && "${exp_vars}" == "${actual_vars}" ]]

	if ! tend $? ; then
		printf '### EXPECTED ABI: %s\n' "${exp_abi}"
		printf '### ACTUAL   ABI: %s\n' "${actual_abi}"
		printf '### EXPECTED VARS: %s\n' "${exp_vars}"
		printf '### ACTUAL   VARS: %s\n' "${actual_vars}"
	fi
}

# Pick a few interesting targets from:
# $ grep -h -o -R 'CHOST=.*' ../../profiles/ | sort -u

test-multilib_env \
	"x86_64-pc-linux-gnu" \
	"amd64:amd64 x86" \
	"amd64? ( CHOST=x86_64-pc-linux-gnu LIBDIR=lib64 CFLAGS=-m64 LDFLAGS= ) x86? ( CHOST=i686-pc-linux-gnu LIBDIR=lib CFLAGS=-m32 LDFLAGS= )"
test-multilib_env \
	"x86_64-pc-linux-gnux32" \
	"x32:x32 amd64 x86" \
	"x32? ( CHOST=x86_64-pc-linux-gnux32 LIBDIR=libx32 CFLAGS=-mx32 LDFLAGS= ) amd64? ( CHOST=x86_64-pc-linux-gnu LIBDIR=lib64 CFLAGS=-m64 LDFLAGS= ) x86? ( CHOST=i686-pc-linux-gnu LIBDIR=lib CFLAGS=-m32 LDFLAGS= )"
test-multilib_env \
	"x86_64-gentoo-linux-musl" \
	"default:default" \
	"default? ( CHOST=x86_64-gentoo-linux-musl LIBDIR=lib CFLAGS= LDFLAGS= )"

texit
