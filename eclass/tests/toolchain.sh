#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# apply exlass globals to test version parsing
TOOLCHAIN_GCC_PV=7.3.0
PR=r0

source tests-common.sh

inherit toolchain

test_downgrade_arch_flags() {
	local exp msg ret=0 ver

	ver=${1}
	exp=${2}
	shift 2
	CFLAGS=${@}

	tbegin "downgrade_arch_flags: ${ver} ${CFLAGS} => ${exp}"

	CHOST=x86_64 # needed for tc-arch
	downgrade_arch_flags ${ver}

	if [[ ${CFLAGS} != ${exp} ]]; then
		msg="Failure - Expected: \"${exp}\" Got: \"${CFLAGS}\""
		ret=1
	fi
	tend ${ret} ${msg}
}

#                         ver  expected            given
test_downgrade_arch_flags 4.9 "-march=haswell"    "-march=haswell"
test_downgrade_arch_flags 4.8 "-march=core-avx2"  "-march=haswell"
test_downgrade_arch_flags 4.7 "-march=core-avx2"  "-march=haswell"
test_downgrade_arch_flags 4.6 "-march=core-avx-i" "-march=haswell"
test_downgrade_arch_flags 4.5 "-march=core2"      "-march=haswell"
test_downgrade_arch_flags 4.4 "-march=core2"      "-march=haswell"
test_downgrade_arch_flags 4.3 "-march=core2"      "-march=haswell"
test_downgrade_arch_flags 4.2 "-march=nocona"     "-march=haswell"
test_downgrade_arch_flags 4.1 "-march=nocona"     "-march=haswell"
test_downgrade_arch_flags 4.0 "-march=nocona"     "-march=haswell"
test_downgrade_arch_flags 3.4 "-march=nocona"     "-march=haswell"
test_downgrade_arch_flags 3.3 "-march=nocona"     "-march=haswell"

test_downgrade_arch_flags 4.9 "-march=bdver4"     "-march=bdver4"
test_downgrade_arch_flags 4.8 "-march=bdver3"     "-march=bdver4"
test_downgrade_arch_flags 4.7 "-march=bdver2"     "-march=bdver4"
test_downgrade_arch_flags 4.6 "-march=bdver1"     "-march=bdver4"
test_downgrade_arch_flags 4.5 "-march=amdfam10"   "-march=bdver4"
test_downgrade_arch_flags 4.4 "-march=amdfam10"   "-march=bdver4"
test_downgrade_arch_flags 4.3 "-march=amdfam10"   "-march=bdver4"
test_downgrade_arch_flags 4.2 "-march=k8"         "-march=bdver4"
test_downgrade_arch_flags 4.1 "-march=k8"         "-march=bdver4"
test_downgrade_arch_flags 4.0 "-march=k8"         "-march=bdver4"
test_downgrade_arch_flags 3.4 "-march=k8"         "-march=bdver4"
test_downgrade_arch_flags 3.3 "-march=x86-64"     "-march=bdver4"

test_downgrade_arch_flags 3.4 "-march=c3-2"       "-march=c3-2"
test_downgrade_arch_flags 3.3 "-march=c3"         "-march=c3-2"

test_downgrade_arch_flags 4.5 "-march=garbage"    "-march=garbage"

test_downgrade_arch_flags 4.9 "-mtune=intel"      "-mtune=intel"
test_downgrade_arch_flags 4.8 "-mtune=generic"    "-mtune=intel"
test_downgrade_arch_flags 3.4 ""                  "-mtune=generic"
test_downgrade_arch_flags 3.4 ""                  "-mtune=x86-64"
test_downgrade_arch_flags 3.3 ""                  "-mtune=anything"

test_downgrade_arch_flags 4.5 "-march=amdfam10 -mtune=generic" "-march=btver2 -mtune=generic"
test_downgrade_arch_flags 3.3 "-march=k6-2"       "-march=geode -mtune=barcelona"
test_downgrade_arch_flags 3.4 "-march=k8"         "-march=btver2 -mtune=generic"

test_downgrade_arch_flags 4.2 "-march=native"     "-march=native"
test_downgrade_arch_flags 4.1 "-march=nocona"     "-march=native"

test_downgrade_arch_flags 4.9 "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1" "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1"
test_downgrade_arch_flags 4.8 "-march=foo -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1" "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1"
test_downgrade_arch_flags 4.7 "-march=foo -mno-avx2 -mno-avx -mno-sse4.1" "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1"
test_downgrade_arch_flags 4.6 "-march=foo -mno-avx -mno-sse4.1" "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1"
test_downgrade_arch_flags 4.3 "-march=foo -mno-sse4.1" "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1"
test_downgrade_arch_flags 4.2 "-march=foo" "-march=foo -mno-sha -mno-rtm -mno-avx2 -mno-avx -mno-sse4.1"

test_downgrade_arch_flags 4.4 "-O2 -march=core2 -ffoo -fblah" "-O2 -march=atom -mno-sha -ffoo -mno-rtm -fblah"

# basic version parsing tests in preparation to eapi7-ver switch

test_tc_version_is_at_least() {
	local exp msg ret=0 want mine res

	want=${1}
	mine=${2}
	exp=${3}

	tbegin "tc_version_is_at_least: ${want} ${mine} => ${exp}"

	tc_version_is_at_least ${want} ${mine}
	res=$?

	if [[ ${res} -ne ${exp} ]]; then
		msg="Failure - Expected: \"${exp}\" Got: \"${res}\""
		ret=1
	fi
	tend ${ret} ${msg}
}

#                           want                mine expect
test_tc_version_is_at_least 8                   ''   1
test_tc_version_is_at_least 8.0                 ''   1
test_tc_version_is_at_least 7                   ''   0
test_tc_version_is_at_least 7.0                 ''   0
test_tc_version_is_at_least ${TOOLCHAIN_GCC_PV} ''   0
test_tc_version_is_at_least 5.0                 6.0  0

test_tc_version_is_between() {
	local exp msg ret=0 lo hi res

	lo=${1}
	hi=${2}
	exp=${3}

	tbegin "tc_version_is_between: ${lo} ${hi} => ${exp}"

	tc_version_is_between ${lo} ${hi}
	res=$?

	if [[ ${res} -ne ${exp} ]]; then
		msg="Failure - Expected: \"${exp}\" Got: \"${res}\""
		ret=1
	fi
	tend ${ret} ${msg}
}

#                          lo                  hi                  expect
test_tc_version_is_between 1                   0                   1
test_tc_version_is_between 1                   2                   1
test_tc_version_is_between 7                   8                   0
test_tc_version_is_between ${TOOLCHAIN_GCC_PV} 8                   0
test_tc_version_is_between ${TOOLCHAIN_GCC_PV} ${TOOLCHAIN_GCC_PV} 1
test_tc_version_is_between 7                   ${TOOLCHAIN_GCC_PV} 1
test_tc_version_is_between 8                   9                   1

# eclass has a few critical global variables worth not breaking
test_var_assert() {
	local var_name exp

	var_name=${1}
	exp=${2}

	tbegin "assert variable value: ${var_name} => ${exp}"

	if [[ ${!var_name} != ${exp} ]]; then
		msg="Failure - Expected: \"${exp}\" Got: \"${!var_name}\""
		ret=1
	fi
	tend ${ret} ${msg}
}

# TODO: convert these globals to helpers to ease testing against multiple
# ${TOOLCHAIN_GCC_PV} vaues.
test_var_assert GCC_PV          7.3.0
test_var_assert GCC_PVR         7.3.0
test_var_assert GCC_RELEASE_VER 7.3.0
test_var_assert GCC_BRANCH_VER  7.3
test_var_assert GCCMAJOR        7
test_var_assert GCCMINOR        3
test_var_assert GCCMICRO        0
test_var_assert GCC_CONFIG_VER  7.3.0
test_var_assert PREFIX          /usr

texit
