#!/bin/bash
# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

export LC_ALL=C

ITERATIONS=1000
RUNS=3

doit() {
	local i
	for (( i = 0; i < ITERATIONS; i++ )); do
		_pypi_set_globals
	done
}

timeit() {
	einfo "Timing PYPI_PN=\"${PYPI_PN}\" PV=\"${PV}\" PYPI_NO_NORMALIZE=${PYPI_NO_NORMALIZE}"

	local real=()
	local user=()
	local x vr avg

	for (( x = 0; x < RUNS; x++ )); do
		while read tt tv; do
			case ${tt} in
				real) real+=( ${tv} );;
				user) user+=( ${tv} );;
			esac
		done < <( ( time -p doit ) 2>&1 )
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

PN=foo-bar
PYPI_PN=Foo.Bar
PV=1.2.3_beta2
WORKDIR='<WORKDIR>'

inherit pypi
timeit

PV=1.2.3
timeit
PYPI_NO_NORMALIZE=1 timeit

PN=foobar
PYPI_PN=FooBar
timeit
PYPI_NO_NORMALIZE=1 timeit

PYPI_PN=foobar
timeit
PYPI_NO_NORMALIZE=1 timeit

texit
