#!/bin/bash
# Copyright 1999-2026 Gentoo Authors
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

texit
