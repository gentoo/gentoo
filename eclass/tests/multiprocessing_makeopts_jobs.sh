#!/bin/bash
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
source tests-common.sh || exit

inherit multiprocessing

test-makeopts_jobs() {
	local exp=$1; shift
	local targs
	if [[ -v 1 ]]; then
		targs="$1${2+; inf=${2}}"
	else
		targs="MAKEOPTS=\"${MAKEOPTS}\" GNUMAKEFLAGS=\"${GNUMAKEFLAGS}\" MAKEFLAGS=\"${MAKEFLAGS}\""
	fi
	tbegin "makeopts_jobs(${targs}) == ${exp}"
	local indirect=$(MAKEOPTS="$*" makeopts_jobs)
	local direct=$(makeopts_jobs "$@")
	if [[ "${direct}" != "${indirect}" ]] ; then
		tend 1 "Mismatch between MAKEOPTS/cli: '${indirect}' != '${direct}'"
	else
		[[ ${direct} == "${exp}" ]]
		tend $? "Got back: ${direct}"
	fi
}

# override to avoid relying on a specific value
get_nproc() {
	echo 41
}

tests=(
	42 "-j"
	42 "--jobs"
	42 "-j -l9"
	1 ""
	1 "-l9 -w"
	1 "-l9 -w-j4"
	1 "-l9--jobs=3"
	1 "-l9--jobs=8"
	2 "-j2"
	3 "-j 3"
	4 "-l3 -j 4 -w"
	5 "--jobs=5"
	6 "--jobs 6"
	7 "-l3 --jobs 7 -w"
	4 "-j1 -j 2 --jobs 3 --jobs=4"
	8 "     -j        			8     "
	42 "-kj"
	4 "-kj4"
	5 "-kj 5"
)
for (( i = 0; i < ${#tests[@]}; i += 2 )) ; do
	test-makeopts_jobs "${tests[i]}" "${tests[i+1]}"
done

tests=(
	7 "" "--jobs 7" ""
	# MAKEFLAGS override GNUMAKEFLAGS
	8 "" "--jobs 7" "--jobs 8"
)

for (( i = 0; i < ${#tests[@]}; i += 4 )) ; do
	MAKEOPTS="${tests[i+1]}"
	GNUMAKEFLAGS="${tests[i+2]}"
	MAKEFLAGS="${tests[i+3]}"
	test-makeopts_jobs "${tests[i]}"
	unset MAKEOPTS GNUMAKEFLAGS MAKEFLAGS
done

# test custom inf value
test-makeopts_jobs 645 "-j" 645

texit
