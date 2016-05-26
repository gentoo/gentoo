#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

source tests-common.sh

EAPI=6

inherit cmake-utils

# --------------------------------------------------------------------------------------------------

estack_pop() {
	[[ $# -eq 0 || $# -gt 2 ]] && die "estack_pop: incorrect # of arguments"

	# We use the fugly _estack_xxx var names to avoid collision with
	# passing back the return value.  If we used "local i" and the
	# caller ran `estack_pop ... i`, we'd end up setting the local
	# copy of "i" rather than the caller's copy.  The _estack_xxx
	# garbage is preferable to using $1/$2 everywhere as that is a
	# bit harder to read.
	local _estack_name="_ESTACK_$1_" ; shift
	local _estack_retvar=$1 ; shift
	eval local _estack_i=\${#${_estack_name}\[@\]}
	# Don't warn -- let the caller interpret this as a failure
	# or as normal behavior (akin to `shift`)
	[[ $(( --_estack_i )) -eq -1 ]] && return 1

	if [[ -n ${_estack_retvar} ]] ; then
		eval ${_estack_retvar}=\"\${${_estack_name}\[${_estack_i}\]}\"
	fi
	eval unset \"${_estack_name}\[${_estack_i}\]\"
}

estack_push() {
	[[ $# -eq 0 ]] && die "estack_push: incorrect # of arguments"
	local stack_name="_ESTACK_$1_" ; shift
	eval ${stack_name}+=\( \"\$@\" \)
}

eshopts_push() {
	if [[ $1 == -[su] ]] ; then
		estack_push eshopts "$(shopt -p)"
		[[ $# -eq 0 ]] && return 0
		shopt "$@" || die "${FUNCNAME}: bad options to shopt: $*"
	else
		estack_push eshopts $-
		[[ $# -eq 0 ]] && return 0
		set "$@" || die "${FUNCNAME}: bad options to set: $*"
	fi
}

eshopts_pop() {
	local s
	estack_pop eshopts s || die "${FUNCNAME}: unbalanced push"
	if [[ ${s} == "shopt -"* ]] ; then
		eval "${s}" || die "${FUNCNAME}: sanity: invalid shopt options: ${s}"
	else
		set +$-     || die "${FUNCNAME}: sanity: invalid shell settings: $-"
		set -${s}   || die "${FUNCNAME}: sanity: unable to restore saved shell settings: ${s}"
	fi
}

# --------------------------------------------------------------------------------------------------

test-ninjaopts() {
	local expect="${1}" given="${2}"
	tbegin "'${given}'"
	local ret=0

	local out="$(
		NINJAOPTS=
		_ninjaopts_from_makeopts "${given}"
		printf '%s\n' "${NINJAOPTS}"
	)"
	if [[ ${out} != ${expect} ]] ; then
		eerror "Self-test failed:"
		eindent
		eerror "MAKEOPTS: '${given}'"
		eerror "Expected: '${expect}'"
		eerror "Actual:   '${out}'"
		eoutdent
		ret=1
	fi

	tend ${ret}
	return ${ret}
}

section() {
	local args=( "${@:1:((${#}-1))}" ) flag="${!#}"
	if [[ ${flag} == '{' ]] ; then
		einfo "'${args[*]}'"
		eindent
	elif [[ ${flag} == '}' ]] ; then
		eoutdent
	else
		eerror "Bad flag: '${flag}'"
	fi
}

section Empty {
	test-ninjaopts ''	''
	test-ninjaopts ''	'        '
section }

section Jobs only {
	test-ninjaopts '-j 1'	'-j 1'
	test-ninjaopts '-j 2'	'-j2'
	test-ninjaopts '-j 3'	'--jobs=3'
	test-ninjaopts '-j 4'	'--jobs 4'

	section Unlimited jobs {
		test-ninjaopts '-j 99'	'-j'
		test-ninjaopts '-j 99'	'--jobs'
	section }
section }

section Keep only {
	test-ninjaopts '-k 0'	'-k'
	test-ninjaopts '-k 0'	'--keep-going'
section }

section Keep/stop only {
	test-ninjaopts ''	'-S'
	test-ninjaopts ''	'--no-keep-going'
	test-ninjaopts ''	'--stop'

	section Keep before stop {
		test-ninjaopts ''	'-k -S'
		test-ninjaopts ''	'-k --no-keep-going'
		test-ninjaopts ''	'-k --stop'
	section }
	section Keep after stop {
		test-ninjaopts '-k 0'	'-S -k'
		test-ninjaopts '-k 0'	'--no-keep-going -k'
		test-ninjaopts '-k 0'	'--stop -k'
	section }
section }

section Load only {
	test-ninjaopts '-l 1'	'-l 1'
	test-ninjaopts '-l 2'	'-l2'
	test-ninjaopts '-l 3'	'--load-average=3'
	test-ninjaopts '-l 4'	'--load-average 4'

	section Floating point numbers {
		test-ninjaopts '-l 1.12345'	'-l 1.12345'
		test-ninjaopts '-l 2.12345'	'-l2.12345'
		test-ninjaopts '-l 3.12345'	'--load-average=3.12345'
		test-ninjaopts '-l 4.12345'	'--load-average 4.12345'
	section }

	section No argument {
		test-ninjaopts ''	'-l 5 -l'
		test-ninjaopts ''	'--load-average=5 --load-average'
	section }
section }

section Some mixups {
	test-ninjaopts '-j 2 -k 0'			'-k -j 2'
	test-ninjaopts '-j 18 -k 0'			'-k -l -j -j 99 -k -j18 -l17 -l -k'
	test-ninjaopts '-j 99 -k 0'			'-k -l -j -j 75 -k -j18 -l17 -l -k -j'
	test-ninjaopts '-j 18 -k 0 -l 1'	'-k -l -j -j 99 -k -j18 -l17 -l -k -l1'
	test-ninjaopts '-j 18 -k 0 -l 1'	'-k -l -j -j 99 -k -j18 -l17 -l -k -l 1'
section }

texit
