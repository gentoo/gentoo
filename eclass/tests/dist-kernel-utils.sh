#!/usr/bin/env bash
# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

source tests-common.sh || exit
# TODO: hack because tests-common don't implement ver_cut
source version-funcs.sh || exit

inherit dist-kernel-utils

test_PV_to_KV() {
	local kv=${1}
	local exp_PV=${2}

	tbegin "dist-kernel_PV_to_KV ${kv} -> ${exp_PV}"
	local val=$(dist-kernel_PV_to_KV "${kv}")
	[[ ${val} == ${exp_PV} ]]
	tend $?
}

test_PV_to_KV 6.0_rc1 6.0.0-rc1
test_PV_to_KV 6.0 6.0.0
test_PV_to_KV 6.0.1_rc1 6.0.1-rc1
test_PV_to_KV 6.0.1 6.0.1

texit
