#!/bin/bash
# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

export LC_ALL=C

doit() {
	for (( i = 0; i < 1000; i++ )); do
		_pypi_set_globals
	done
}

timeit() {
	einfo "Timing PYPI_PN=\"${PYPI_PN}\" PV=\"${PV}\" PYPI_NO_NORMALIZE=${PYPI_NO_NORMALIZE}"

	local real=()
	local user=()
	local x vr avg

	for x in {1..3}; do
		while read tt tv; do
			case ${tt} in
				real) real+=( ${tv} );;
				user) user+=( ${tv} );;
			esac
		done < <( ( time -p doit ) 2>&1 )
	done

	[[ ${#real[@]} == 3 ]] || die "Did not get 3 real times"
	[[ ${#user[@]} == 3 ]] || die "Did not get 3 user times"

	local xr avg
	for x in real user; do
		xr="${x}[*]"
		avg=$(dc -S 3 -e "3000 ${!xr} + + / p")

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
