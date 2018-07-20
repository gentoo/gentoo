#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh

inherit multiprocessing

test-makeopts_loadavg() {
	local exp=$1; shift
	tbegin "makeopts_loadavg($1${2+; inf=${2}}) == ${exp}"
	local indirect=$(MAKEOPTS="$*" makeopts_loadavg)
	local direct=$(makeopts_loadavg "$@")
	if [[ "${direct}" != "${indirect}" ]] ; then
		tend 1 "Mismatch between MAKEOPTS/cli: '${indirect}' != '${direct}'"
	else
		[[ ${direct} == "${exp}" ]]
		tend $? "Got back: ${direct}"
	fi
}

tests=(
	999 "-j"
	999 "-l"
	999 ""
	9 "-l9 -w"
	9 "-l 9 -w-j4"
	3 "-l3 -j 4 -w"
	5 "--load-average=5"
	6 "--load-average 6"
	7 "-l3 --load-average 7 -w"
	4 "-j1 -j 2 --load-average 3 --load-average=4"
	3 " --max-load=3 -x"
	8 "     -l        			8     "
	999 "-kl"
	4 "-kl4"
	5 "-kl 5"
	2.3 "-l 2.3"
	999 "-l 2.3.4"
)
for (( i = 0; i < ${#tests[@]}; i += 2 )) ; do
	test-makeopts_loadavg "${tests[i]}" "${tests[i+1]}"
done

# test custom inf value
test-makeopts_loadavg 645 "-l" 645

texit
