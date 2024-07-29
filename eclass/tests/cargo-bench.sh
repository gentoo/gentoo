#!/bin/bash
# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

export LC_ALL=C

ITERATIONS=1000
RUNS=3

doit() {
	for (( i = 0; i < ITERATIONS; i++ )); do
		_cargo_set_crate_uris "${CRATES}"
		SRC_URI="
			${CARGO_CRATE_URIS}
		"
	done
}

timeit() {
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

# taken from cryptograpy-41.0.1
CRATES="
	Inflector@0.11.4
	aliasable@0.1.3
	asn1@0.15.2
	asn1_derive@0.15.2
	autocfg@1.1.0
	base64@0.13.1
	bitflags@1.3.2
	cc@1.0.79
	cfg-if@1.0.0
	foreign-types@0.3.2
	foreign-types-shared@0.1.1
	indoc@1.0.9
	libc@0.2.144
	lock_api@0.4.9
	memoffset@0.8.0
	once_cell@1.17.2
	openssl@0.10.54
	openssl-macros@0.1.1
	openssl-sys@0.9.88
	ouroboros@0.15.6
	ouroboros_macro@0.15.6
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	pem@1.1.1
	pkg-config@0.3.27
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.59
	pyo3@0.18.3
	pyo3-build-config@0.18.3
	pyo3-ffi@0.18.3
	pyo3-macros@0.18.3
	pyo3-macros-backend@0.18.3
	quote@1.0.28
	redox_syscall@0.2.16
	scopeguard@1.1.0
	smallvec@1.10.0
	syn@1.0.109
	syn@2.0.18
	target-lexicon@0.12.7
	unicode-ident@1.0.9
	unindent@0.1.11
	vcpkg@0.2.15
	version_check@0.9.4
	windows-sys@0.45.0
	windows-targets@0.42.2
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_msvc@0.42.2
	windows_i686_gnu@0.42.2
	windows_i686_msvc@0.42.2
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_msvc@0.42.2
"

inherit cargo

einfo "CRATES with '@' separator"
timeit

einfo "CRATES with '-' separator"
CRATES=${CRATES//@/-}
timeit

texit
