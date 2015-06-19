#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/toolchain.sh,v 1.3 2015/05/17 20:12:56 ulm Exp $

source tests-common.sh

inherit toolchain

test_downgrade_arch_flags() {
	local exp msg ret=0 ver

	ver=${1}
	exp=${2}
	shift 2
	CFLAGS=${@}

	tbegin "${ver} ${CFLAGS} => ${exp}"

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
texit
