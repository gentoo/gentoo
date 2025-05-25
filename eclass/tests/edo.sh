#!/bin/bash
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit edo

make_some_noise() {
	echo "Here is some noise:"
	echo "${1:?Must provide some noise}"
	echo "EoN"
}

test_edo() {
	local exp_ret=${1} exp_out=${2} cmd=("${@:3}")
	local have_ret have_out
	tbegin "edo -> ret: ${exp_ret}, out: ${exp_out}"
	have_out=$(edo "${cmd[@]}" 2>&1)
	have_ret=$?
	have_out=${have_out%%$'\n'*}
	have_out=${have_out# \* }
	[[ ${have_ret} -eq ${exp_ret} && ${have_out} == "${exp_out}" ]]
	tend $? "returned: ${have_ret}, output: ${have_out}"
}

test_edob_simple() {
	tbegin "edob with output test"
	(
		edob make_some_noise foo
		eend $?
	) &> "${T}/edob.out"
	local res=$?
	if [[ $res -ne 0 ]]; then
		tend $res
		return 0
	fi

	local log_file="${T}/make_some_noise.log"
	local second_line="$(sed -n '2p' "${log_file}")"
    [[ "${second_line}" == "foo" ]];
	tend $? "Unexpected output, found \"${second_line}\", expected \"foo\""

	rm "${log_file}" || die
}

test_edob_explicit_log_name() {
	tbegin "edob with explicit logfile name"
	(
		edob -l mylog make_some_noise bar
		eend $?
	) &> "${T}/edob.out"
	local res=$?
	if [[ $res -ne 0 ]]; then
		cat "${T}/edob.out"
		tend $res
		return 0
	fi

	local log_file="${T}/mylog.log"
	local second_line="$(sed -n '2p' "${log_file}")"
    [[ "${second_line}" == "bar" ]];
	tend $? "Unexpected output, found \"${second_line}\", expected \"foo\""

	rm "${log_file}" || die
}

test_edob_explicit_message() {
	tbegin "edob with explicit message"
	(
		edob -m "Making some noise" make_some_noise baz
		eend $?
	) &> "${T}/edob.out"
	local res=$?
	if [[ $res -ne 0 ]]; then
		cat "${T}/edob.out"
		tend $res
		return 0
	fi

	local log_file="${T}/make_some_noise.log"
	local second_line="$(sed -n '2p' "${log_file}")"
    [[ "${second_line}" == "baz" ]];
	tend $? "Unexpected output, found \"${second_line}\", expected \"baz\""

	rm "${log_file}" || die
}

test_edob_failure() {
	make_some_noise_and_fail() {
		make_some_noise "$@"
		return 1
	}

	tbegin "edob with failing command"
	(
		edob -m "Making some noise" make_some_noise_and_fail quz
		eend $?
	) &> "${T}/edob.out"
	local res=$?
	# Now, this time we expect res to be exactly '1'.
	if [[ $res -ne 1 ]]; then
		tend 1
		return 1
	fi

	local log_file="${T}/make_some_noise_and_fail.log"
	local second_line="$(sed -n '2p' "${log_file}")"
    [[ "${second_line}" == "quz" ]];
	tend $? "Unexpected output, found \"${second_line}\", expected \"quz\""

	rm "${log_file}" || die

	local fourth_line_of_edob_out="$(sed -n '4p' "${T}/edob.out")"
	[[ "${fourth_line_of_edob_out}" == "quz" ]];
	tend $? "Unexpected output, found \"${fourth_line_of_edob_out}\", expected \"quz\""
}

test_edo 0 "/bin/true foo"              /bin/true foo
test_edo 1 "/bin/false bar"             /bin/false bar
test_edo 0 "make_some_noise baz"        make_some_noise baz
test_edo 0 ": 'foo bar' 'baz  quux'"    : 'foo bar' 'baz  quux'
test_edo 0 ": @%:+,-=._ '\$'"           : '@%:+,-=._' '$'
test_edo 0 ": 'foo;bar' 'baz*quux'"     : 'foo;bar' 'baz*quux'
test_edo 0 ": '#foo' bar#baz 'qu=~ux'"  : '#foo' 'bar#baz' 'qu=~ux'
test_edo 0 ": '\"' \\' 'foo'\\''bar'"   : '"' "'" "foo'bar"
test_edo 0 ": '' ' ' \$'\\t' \$'\\001'" : '' ' ' $'\t' $'\x01'
test_edo 0 ": äöü"                      : 'äöü'

test_edob_simple
test_edob_explicit_log_name
test_edob_explicit_message
test_edob_failure

texit
