#!/bin/bash
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

source tests-common.sh

inherit eapi7-ver

cutting() {
	local x
	for x in {1..1000}; do
		version_cut 1-2 1.2.3
		version_cut 2- 1.2.3
		version_cut 1- 1.2.3
		version_cut 3-4 1.2.3b_alpha4
		version_cut 5 1.2.3b_alpha4
		version_cut 1-2 .1.2.3
		version_cut 0-2 .1.2.3
		version_cut 2-3 1.2.3.
		version_cut 2- 1.2.3.
		version_cut 2-4 1.2.3.
	done >/dev/null
}

replacing() {
	local x
	for x in {1..1000}; do
		version_rs 2 - 1.2.3
		version_rs 2 . 1.2-3
		version_rs 3 . 1.2.3a
		version_rs 2-3 - 1.2_alpha4
		version_rs 3 - 2 "" 1.2.3b_alpha4
		version_rs 3-5 _ 4-6 - a1b2c3d4e5
		version_rs 1 - .1.2.3
		version_rs 0 - .1.2.3
		version_rs 3 . 1.2.3
	done >/dev/null
}

get_times() {
	echo "${*}"
	local real=()
	local user=()

	for x in {1..5}; do
		while read tt tv; do
			case ${tt} in
				real) real+=( ${tv} );;
				user) user+=( ${tv} );;
			esac
		done < <( ( time -p "${@}" ) 2>&1 )
	done

	[[ ${#real[@]} == 5 ]] || die "Did not get 5 real times"
	[[ ${#user[@]} == 5 ]] || die "Did not get 5 user times"

	local sum
	for v in real user; do
		vr="${v}[*]"
		sum=$(dc -e "${!vr} + + + + 3 k 5 / p")

		vr="${v}[@]"
		printf '%s %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f\n' \
			"${v}" "${!vr}" "${sum}"
	done
}

export LC_ALL=C

get_times cutting
get_times replacing
