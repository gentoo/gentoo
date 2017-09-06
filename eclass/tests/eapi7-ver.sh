#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

source tests-common.sh

inherit eapi7-ver

teq() {
	local expected=${1}; shift

	tbegin "${*} -> ${expected}"
	local got=$("${@}")
	[[ ${got} == ${expected} ]]
	tend ${?} "returned: ${got}"
}

txf() {
	tbegin "XFAIL: ${*}"
	local got=$("${@}" 2>&1)
	[[ ${got} == die:* ]]
	tend ${?} "function did not die"
}

teq 1.2 version_cut 1-2 1.2.3
teq 2.3 version_cut 2- 1.2.3
teq 1.2.3 version_cut 1- 1.2.3
teq 3b version_cut 3-4 1.2.3b_alpha4
teq alpha version_cut 5 1.2.3b_alpha4
teq 1.2 version_cut 1-2 .1.2.3
teq .1.2 version_cut 0-2 .1.2.3
teq 2.3 version_cut 2-3 1.2.3.
teq 2.3. version_cut 2- 1.2.3.

teq 1.23-b_alpha4 version_rs 3 - 2 "" 1.2.3b_alpha4
teq a1b_2-c-3-d4e5 version_rs 3-5 _ 4-6 - a1b2c3d4e5
teq .1-2.3 version_rs 1 - .1.2.3
teq -1.2.3 version_rs 0 - .1.2.3

txf version_cut foo 1.2.3
txf version_rs -3 _ a1b2c3d4e5
txf version_rs 5-3 _ a1b2c3d4e5
