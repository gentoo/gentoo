#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/versionator_version_compare.sh,v 1.2 2015/05/10 16:38:08 ulm Exp $

source tests-common.sh

inherit versionator

eshopts_push -s extglob
ver=( "" "lt" "eq" "gt" )
lt=1 eq=2 gt=3

test_version_compare() {
	tbegin "version_compare ${1} -${ver[${2}]} ${3}"
	version_compare "${1}" "${3}"
	local r=$?
	[[ ${r} -eq ${2} ]]
	tend $? "FAIL: ${@} (got ${r} exp ${2})"
}

echo "
	0             $lt 1
	1             $lt 2
	2             $gt 1
	2             $eq 2
	0             $eq 0
	10            $lt 20
	68            $eq 068
	068           $gt 67
	068           $lt 69

	1.0           $lt 2.0
	2.0           $eq 2.0
	2.0           $gt 1.0

	1.0           $gt 0.0
	0.0           $eq 0.0
	0.0           $lt 1.0

	0.1           $lt 0.2
	0.2           $eq 0.2
	0.3           $gt 0.2

	1.2           $lt 2.1
	2.1           $gt 1.2

	1.2.3         $lt 1.2.4
	1.2.4         $gt 1.2.3

	1.2.0         $gt 1.2
	1.2.1         $gt 1.2
	1.2           $lt 1.2.1

	1.2b          $eq 1.2b
	1.2b          $lt 1.2c
	1.2b          $gt 1.2a
	1.2b          $gt 1.2
	1.2           $lt 1.2a

	1.3           $gt 1.2a
	1.3           $lt 1.3a

	1.0_alpha7    $lt 1.0_beta7
	1.0_beta      $lt 1.0_pre
	1.0_pre5      $lt 1.0_rc2
	1.0_rc2       $lt 1.0

	1.0_p1        $gt 1.0
	1.0_p1-r1     $gt 1.0_p1

	1.0_alpha6-r1 $gt 1.0_alpha6
	1.0_beta6-r1  $gt 1.0_alpha6-r2

	1.0_pre1      $lt 1.0_p1

	1.0p          $gt 1.0_p1
	1.0r          $gt 1.0-r1
	1.6.15        $gt 1.6.10-r2
	1.6.10-r2     $lt 1.6.15

" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	test_version_compare "${a}" "${b}" "${c}"
done


for q in "alpha beta pre rc=${lt};${gt}" "p=${gt};${lt}" ; do
	for p in ${q%%=*} ; do
		c=${q##*=}
		alt=${c%%;*} agt=${c##*;}
		test_version_compare "1.0" $agt "1.0_${p}"
		test_version_compare "1.0" $agt "1.0_${p}1"
		test_version_compare "1.0" $agt "1.0_${p}068"

		test_version_compare "2.0_${p}"    $alt "2.0"
		test_version_compare "2.0_${p}1"   $alt "2.0"
		test_version_compare "2.0_${p}068" $alt "2.0"

		test_version_compare "1.0_${p}"  $eq "1.0_${p}"
		test_version_compare "0.0_${p}"  $lt "0.0_${p}1"
		test_version_compare "666_${p}3" $gt "666_${p}"

		test_version_compare "1_${p}7"  $lt "1_${p}8"
		test_version_compare "1_${p}7"  $eq "1_${p}7"
		test_version_compare "1_${p}7"  $gt "1_${p}6"
		test_version_compare "1_${p}09" $eq "1_${p}9"

		test_version_compare "1_${p}7-r0"  $eq "1_${p}7"
		test_version_compare "1_${p}7-r0"  $lt "1_${p}7-r1"
		test_version_compare "1_${p}7-r0"  $lt "1_${p}7-r01"
		test_version_compare "1_${p}7-r01" $eq "1_${p}7-r1"
		test_version_compare "1_${p}8-r1"  $gt "1_${p}7-r100"

		test_version_compare "1_${p}_alpha" $lt "1_${p}_beta"
	done
done

for p in "-r" "_p" ; do
	test_version_compare "7.2${p}1" $lt "7.2${p}2"
	test_version_compare "7.2${p}2" $gt "7.2${p}1"
	test_version_compare "7.2${p}3" $gt "7.2${p}2"
	test_version_compare "7.2${p}2" $lt "7.2${p}3"
done

# The following tests all come from portage's test cases:
test_version_compare "6.0" $gt "5.0"
test_version_compare "5.0" $gt "5"
test_version_compare "1.0-r1" $gt "1.0-r0"
test_version_compare "1.0-r1" $gt "1.0"
test_version_compare "999999999999999999999999999999" $gt "999999999999999999999999999998"
test_version_compare "1.0.0" $gt "1.0"
test_version_compare "1.0.0" $gt "1.0b"
test_version_compare "1b" $gt "1"
test_version_compare "1b_p1" $gt "1_p1"
test_version_compare "1.1b" $gt "1.1"
test_version_compare "12.2.5" $gt "12.2b"

test_version_compare "4.0" $lt "5.0"
test_version_compare "5" $lt "5.0"
test_version_compare "1.0_pre2" $lt "1.0_p2"
test_version_compare "1.0_alpha2" $lt "1.0_p2"
test_version_compare "1.0_alpha1" $lt "1.0_beta1"
test_version_compare "1.0_beta3" $lt "1.0_rc3"
test_version_compare "1.001000000000000000001" $lt "1.001000000000000000002"
test_version_compare "1.00100000000" $lt "1.0010000000000000001"
test_version_compare "999999999999999999999999999998" $lt "999999999999999999999999999999"
test_version_compare "1.01" $lt "1.1"
test_version_compare "1.0-r0" $lt "1.0-r1"
test_version_compare "1.0" $lt "1.0-r1"
test_version_compare "1.0" $lt "1.0.0"
test_version_compare "1.0b" $lt "1.0.0"
test_version_compare "1_p1" $lt "1b_p1"
test_version_compare "1" $lt "1b"
test_version_compare "1.1" $lt "1.1b"
test_version_compare "12.2b" $lt "12.2.5"

test_version_compare "4.0" $eq "4.0"
test_version_compare "1.0" $eq "1.0"
test_version_compare "1.0-r0" $eq "1.0"
test_version_compare "1.0" $eq "1.0-r0"
test_version_compare "1.0-r0" $eq "1.0-r0"
test_version_compare "1.0-r1" $eq "1.0-r1"

# The following were just tests for != in portage, we need something a bit
# more precise
test_version_compare "1" $lt "2"
test_version_compare "1.0_alpha" $lt "1.0_pre"
test_version_compare "1.0_beta" $gt "1.0_alpha"
test_version_compare "0" $lt "0.0"
test_version_compare "1.0-r0" $lt "1.0-r1"
test_version_compare "1.0-r1" $gt "1.0-r0"
test_version_compare "1.0" $lt "1.0-r1"
test_version_compare "1.0-r1" $gt "1.0"
test_version_compare "1_p1" $lt "1b_p1"
test_version_compare "1b" $gt "1"
test_version_compare "1.1b" $gt "1.1"
test_version_compare "12.2b" $gt "12.2"

# The following tests all come from paludis's test cases:
test_version_compare "1.0" $gt "1"
test_version_compare "1" $lt "1.0"
test_version_compare "1.0_alpha" $gt "1_alpha"
test_version_compare "1.0_alpha" $gt "1"
test_version_compare "1.0_alpha" $lt "1.0"
test_version_compare "1.2.0.0_alpha7-r4" $gt "1.2_alpha7-r4"

test_version_compare "0001" $eq "1"
test_version_compare "01" $eq "001"
test_version_compare "0001.1" $eq "1.1"
test_version_compare "01.01" $eq "1.01"
test_version_compare "1.010" $eq "1.01"
test_version_compare "1.00" $eq "1.0"
test_version_compare "1.0100" $eq "1.010"
test_version_compare "1" $eq "1-r0"
test_version_compare "1-r00" $eq "1-r0"

eshopts_pop

texit
