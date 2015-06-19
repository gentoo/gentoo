#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/multiprocessing_makeopts_jobs.sh,v 1.2 2015/05/10 16:38:08 ulm Exp $

source tests-common.sh

inherit multiprocessing

test-makeopts_jobs() {
	local exp=$1; shift
	tbegin "makeopts_jobs($*) == ${exp}"
	local act=$(makeopts_jobs "$@")
	[[ ${act} == "${exp}" ]]
	tend $? "Got back: ${act}"
}

tests=(
	999 "-j"
	999 "--jobs"
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
)
for (( i = 0; i < ${#tests[@]}; i += 2 )) ; do
	test-makeopts_jobs "${tests[i]}" "${tests[i+1]}"
done

texit
