#!/bin/bash
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

source tests-common.sh || exit

inherit meson

test_meson_format_array() {
	local expected=$1
	shift
	tbegin meson_format_array "$@"
	local actual=$(meson_format_array "$@")
	[[ "${actual}" = "${expected}" ]]
	tend $?
	#printf '%s\n' "${expected}"
	#printf '%s\n' "${actual}"
}

test_meson_format_array "['--single-quote=\\'']" "--single-quote=\\'"
test_meson_format_array "['--double-quote=\"']" '--double-quote=\"'
test_meson_format_array "['--dollar=\$']" '--dollar=\$'
test_meson_format_array "['--backtick=\`']" '--backtick=\`'
test_meson_format_array "['--backslash=\\\\']" '--backslash=\\'
test_meson_format_array "['--full-word-double=Hello World']" '--full-word-double="Hello World"'
test_meson_format_array "['--full-word-single=Hello World']" "--full-word-single='Hello World'"
test_meson_format_array "['--full-word-backslash=Hello World']" '--full-word-backslash=Hello\ World'
test_meson_format_array "['--simple']" --simple
test_meson_format_array "['--unicode-8=©']" --unicode-8=©
test_meson_format_array "['--unicode-16=𐐷']" --unicode-16=𐐷
test_meson_format_array "['--unicode-32=𐤅']" --unicode-32=𐤅
test_meson_format_array "['--newline="foo\\nbar"']" $'--newline="foo\nbar"'

texit
