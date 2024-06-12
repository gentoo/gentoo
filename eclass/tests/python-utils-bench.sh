#!/bin/bash
# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

export LC_ALL=C

ITERATIONS=10000
RUNS=3

doit() {
	local i
	for (( i = 0; i < ITERATIONS; i++ )); do
		"${@}"
	done
}

timeit() {
	local real=()
	local user=()
	local x vr avg

	einfo "Timing ${*}"
	for (( x = 0; x < RUNS; x++ )); do
		while read tt tv; do
			case ${tt} in
				real) real+=( ${tv} );;
				user) user+=( ${tv} );;
			esac
		done < <( ( time -p doit "${@}" ) 2>&1 )
	done

	[[ ${#real[@]} == ${RUNS} ]] || die "Did not get ${RUNS} real times"
	[[ ${#user[@]} == ${RUNS} ]] || die "Did not get ${RUNS} user times"

	local xr avg
	for x in real user; do
		xr="${x}[*]"
		avg=$(dc -e "3 k ${ITERATIONS} ${RUNS} * ${!xr} + + / p")

		printf '%s %4.0f it/s\n' "${x}" "${avg}"
	done
}

PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit python-utils-r1

timeit _python_set_impls

texit
