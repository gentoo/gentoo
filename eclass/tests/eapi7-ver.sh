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

teqr() {
	local expected=$1; shift
	tbegin "$* -> ${expected}"
	"$@"
	local ret=$?
	[[ ${ret} -eq ${expected} ]]
	tend $? "returned: ${ret}"
}

txf() {
	tbegin "XFAIL: ${*}"
	local got=$("${@}" 2>&1)
	[[ ${got} == die:* ]]
	tend ${?} "function did not die"
}

teq 1 ver_cut 1 1.2.3
teq 1 ver_cut 1-1 1.2.3
teq 1.2 ver_cut 1-2 1.2.3
teq 2.3 ver_cut 2- 1.2.3
teq 1.2.3 ver_cut 1- 1.2.3
teq 3b ver_cut 3-4 1.2.3b_alpha4
teq alpha ver_cut 5 1.2.3b_alpha4
teq 1.2 ver_cut 1-2 .1.2.3
teq .1.2 ver_cut 0-2 .1.2.3
teq 2.3 ver_cut 2-3 1.2.3.
teq 2.3. ver_cut 2- 1.2.3.
teq 2.3. ver_cut 2-4 1.2.3.

teq 1-2.3 ver_rs 1 - 1.2.3
teq 1.2-3 ver_rs 2 - 1.2.3
teq 1-2-3.4 ver_rs 1-2 - 1.2.3.4
teq 1.2-3-4 ver_rs 2- - 1.2.3.4
teq 1.2.3 ver_rs 2 . 1.2-3
teq 1.2.3.a ver_rs 3 . 1.2.3a
teq 1.2-alpha-4 ver_rs 2-3 - 1.2_alpha4
teq 1.23-b_alpha4 ver_rs 3 - 2 "" 1.2.3b_alpha4
teq a1b_2-c-3-d4e5 ver_rs 3-5 _ 4-6 - a1b2c3d4e5
teq .1-2.3 ver_rs 1 - .1.2.3
teq -1.2.3 ver_rs 0 - .1.2.3

# truncating range
teq 1.2 ver_cut 0-2 1.2.3
teq 2.3 ver_cut 2-5 1.2.3
teq "" ver_cut 4 1.2.3
teq "" ver_cut 0 1.2.3
teq "" ver_cut 4- 1.2.3
teq 1.2.3 ver_rs 0 - 1.2.3
teq 1.2.3 ver_rs 3 . 1.2.3
teq 1.2.3 ver_rs 3- . 1.2.3
teq 1.2.3 ver_rs 3-5 . 1.2.3

txf ver_cut foo 1.2.3
txf ver_rs -3 _ a1b2c3d4e5
txf ver_rs 5-3 _ a1b2c3d4e5

# Tests from Portage's test_vercmp.py
teqr 0 ver_test 6.0 -gt 5.0
teqr 0 ver_test 5.0 -gt 5
teqr 0 ver_test 1.0-r1 -gt 1.0-r0
teqr 0 ver_test 999999999999999999 -gt 999999999999999998 # 18 digits
teqr 0 ver_test 1.0.0 -gt 1.0
teqr 0 ver_test 1.0.0 -gt 1.0b
teqr 0 ver_test 1b -gt 1
teqr 0 ver_test 1b_p1 -gt 1_p1
teqr 0 ver_test 1.1b -gt 1.1
teqr 0 ver_test 12.2.5 -gt 12.2b
teqr 0 ver_test 4.0 -lt 5.0
teqr 0 ver_test 5 -lt 5.0
teqr 0 ver_test 1.0_pre2 -lt 1.0_p2
teqr 0 ver_test 1.0_alpha2 -lt 1.0_p2
teqr 0 ver_test 1.0_alpha1 -lt 1.0_beta1
teqr 0 ver_test 1.0_beta3 -lt 1.0_rc3
teqr 0 ver_test 1.001000000000000001 -lt 1.001000000000000002
teqr 0 ver_test 1.00100000000 -lt 1.001000000000000001
teqr 0 ver_test 999999999999999998 -lt 999999999999999999
teqr 0 ver_test 1.01 -lt 1.1
teqr 0 ver_test 1.0-r0 -lt 1.0-r1
teqr 0 ver_test 1.0 -lt 1.0-r1
teqr 0 ver_test 1.0 -lt 1.0.0
teqr 0 ver_test 1.0b -lt 1.0.0
teqr 0 ver_test 1_p1 -lt 1b_p1
teqr 0 ver_test 1 -lt 1b
teqr 0 ver_test 1.1 -lt 1.1b
teqr 0 ver_test 12.2b -lt 12.2.5
teqr 0 ver_test 4.0 -eq 4.0
teqr 0 ver_test 1.0 -eq 1.0
teqr 0 ver_test 1.0-r0 -eq 1.0
teqr 0 ver_test 1.0 -eq 1.0-r0
teqr 0 ver_test 1.0-r0 -eq 1.0-r0
teqr 0 ver_test 1.0-r1 -eq 1.0-r1
teqr 1 ver_test 1 -eq 2
teqr 1 ver_test 1.0_alpha -eq 1.0_pre
teqr 1 ver_test 1.0_beta -eq 1.0_alpha
teqr 1 ver_test 1 -eq 0.0
teqr 1 ver_test 1.0-r0 -eq 1.0-r1
teqr 1 ver_test 1.0-r1 -eq 1.0-r0
teqr 1 ver_test 1.0 -eq 1.0-r1
teqr 1 ver_test 1.0-r1 -eq 1.0
teqr 1 ver_test 1.0 -eq 1.0.0
teqr 1 ver_test 1_p1 -eq 1b_p1
teqr 1 ver_test 1b -eq 1
teqr 1 ver_test 1.1b -eq 1.1
teqr 1 ver_test 12.2b -eq 12.2

# A subset of tests from Paludis
teqr 0 ver_test 1.0_alpha -gt 1_alpha
teqr 0 ver_test 1.0_alpha -gt 1
teqr 0 ver_test 1.0_alpha -lt 1.0
teqr 0 ver_test 1.2.0.0_alpha7-r4 -gt 1.2_alpha7-r4
teqr 0 ver_test 0001 -eq 1
teqr 0 ver_test 01 -eq 001
teqr 0 ver_test 0001.1 -eq 1.1
teqr 0 ver_test 01.01 -eq 1.01
teqr 0 ver_test 1.010 -eq 1.01
teqr 0 ver_test 1.00 -eq 1.0
teqr 0 ver_test 1.0100 -eq 1.010
teqr 0 ver_test 1-r00 -eq 1-r0

# Additional tests
teqr 0 ver_test 0_rc99 -lt 0
teqr 0 ver_test 011 -eq 11
teqr 0 ver_test 019 -eq 19
teqr 0 ver_test 1.2 -eq 001.2
teqr 0 ver_test 1.2 -gt 1.02
teqr 0 ver_test 1.2a -lt 1.2b
teqr 0 ver_test 1.2_pre1 -gt 1.2_pre1_beta2
teqr 0 ver_test 1.2_pre1 -lt 1.2_pre1_p2
teqr 0 ver_test 1.00 -lt 1.0.0
teqr 0 ver_test 1.010 -eq 1.01
teqr 0 ver_test 1.01 -lt 1.1
teqr 0 ver_test 1.2_pre08-r09 -eq 1.2_pre8-r9
teqr 0 ver_test 0 -lt 576460752303423488 # 2**59
teqr 0 ver_test 0 -lt 9223372036854775808 # 2**63

# Bad number or ordering of arguments
txf ver_test 1
txf ver_test 1 -lt 2 3
txf ver_test -lt 1 2

# Bad operators
txf ver_test 1 "<" 2
txf ver_test 1 lt 2
txf ver_test 1 -foo 2

# Malformed versions
txf ver_test "" -ne 1
txf ver_test 1. -ne 1
txf ver_test 1ab -ne 1
txf ver_test b -ne 1
txf ver_test 1-r1_pre -ne 1
txf ver_test 1-pre1 -ne 1
txf ver_test 1_foo -ne 1
txf ver_test 1_pre1.1 -ne 1
txf ver_test 1-r1.0 -ne 1
txf ver_test cvs.9999 -ne 9999

texit
