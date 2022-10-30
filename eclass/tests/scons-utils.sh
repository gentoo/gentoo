#!/bin/bash
# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
_PYTHON_R1=1
source tests-common.sh || exit

inherit scons-utils

test-scons_clean_makeopts() {
	tbegin "scons_clean_makeopts() for ${1}"

	local SCONSOPTS ret=0
	_scons_clean_makeopts ${1}

	if [[ ${SCONSOPTS} != ${2-${1}} ]]; then
		eerror "Self-test failed:"
		eindent
		eerror "MAKEOPTS: ${1}"
		eerror "Expected: ${2-${1}}"
		eerror "Actual: ${SCONSOPTS}"
		eoutdent
		ret=1
	fi

	tend ${ret}
	return ${ret}
}

# jobcount expected for non-specified state
jc=$(( $(get_nproc) + 1 ))
# failed test counter
failed=0

# sane MAKEOPTS
test-scons_clean_makeopts '--jobs=14 -k'
test-scons_clean_makeopts '--jobs=14 -k'
test-scons_clean_makeopts '--jobs 15 -k'
test-scons_clean_makeopts '--jobs=16 --keep-going'
test-scons_clean_makeopts '-j17 --keep-going'
test-scons_clean_makeopts '-j 18 --keep-going'

# needing cleaning
test-scons_clean_makeopts '--jobs -k' "--jobs=${jc} -k"
test-scons_clean_makeopts '--jobs --keep-going' "--jobs=${jc} --keep-going"
test-scons_clean_makeopts '-kj' "-kj ${jc}"

# broken by definition (but passed as it breaks make as well)
test-scons_clean_makeopts '-jk'
test-scons_clean_makeopts '--jobs=randum'
test-scons_clean_makeopts '-kjrandum'

# needing stripping
test-scons_clean_makeopts '--load-average=25 -kj16' '-kj16'
test-scons_clean_makeopts '--load-average 25 -k -j17' '-k -j17'
test-scons_clean_makeopts '-j2 HOME=/tmp' '-j2'
test-scons_clean_makeopts '--jobs funnystuff -k' "--jobs=${jc} -k"

# bug #388961
test-scons_clean_makeopts '--jobs -l3' "--jobs=${jc}"
test-scons_clean_makeopts '-j -l3' "-j ${jc}"

texit
