#!/bin/bash
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
source tests-common.sh

test_var() {
	local var=${1}
	local impl=${2}
	local expect=${3}

	tbegin "${var} for ${impl}"

	local ${var}
	_python_export ${impl} PYTHON ${var}
	[[ ${!var} == ${expect} ]] || eerror "(${impl}: ${var}: ${!var} != ${expect}"

	tend ${?}
}

test_is() {
	local func=${1}
	local expect=${2}

	tbegin "${func} (expecting: ${expect})"

	${func}
	[[ ${?} == ${expect} ]]

	tend ${?}
}

test_fix_shebang() {
	local from=${1}
	local to=${2}
	local expect=${3}
	local args=( "${@:4}" )

	tbegin "python_fix_shebang${args[@]+ ${args[*]}} from ${from} to ${to} (exp: ${expect})"

	echo "${from}" > "${tmpfile}"
	output=$( EPYTHON=${to} python_fix_shebang "${args[@]}" -q "${tmpfile}" 2>&1 )

	if [[ ${?} != 0 ]]; then
		if [[ ${expect} != FAIL ]]; then
			echo "${output}"
			tend 1
		else
			tend 0
		fi
	else
		[[ $(<"${tmpfile}") == ${expect} ]] \
			|| eerror "${from} -> ${to}: $(<"${tmpfile}") != ${expect}"
		tend ${?}
	fi
}

tmpfile=$(mktemp)

inherit python-utils-r1

test_var EPYTHON python2_7 python2.7
test_var PYTHON python2_7 /usr/bin/python2.7
if [[ -x /usr/bin/python2.7 ]]; then
	test_var PYTHON_SITEDIR python2_7 "/usr/lib*/python2.7/site-packages"
	test_var PYTHON_INCLUDEDIR python2_7 /usr/include/python2.7
	test_var PYTHON_LIBPATH python2_7 "/usr/lib*/libpython2.7$(get_libname)"
	test_var PYTHON_CONFIG python2_7 /usr/bin/python2.7-config
	test_var PYTHON_CFLAGS python2_7 "*-I/usr/include/python2.7*"
	test_var PYTHON_LIBS python2_7 "*-lpython2.7*"
fi
test_var PYTHON_PKG_DEP python2_7 '*dev-lang/python*:2.7'
test_var PYTHON_SCRIPTDIR python2_7 /usr/lib/python-exec/python2.7

test_var EPYTHON python3_6 python3.6
test_var PYTHON python3_6 /usr/bin/python3.6
if [[ -x /usr/bin/python3.6 ]]; then
	abiflags=$(/usr/bin/python3.6 -c 'import sysconfig; print(sysconfig.get_config_var("ABIFLAGS"))')
	test_var PYTHON_SITEDIR python3_6 "/usr/lib*/python3.6/site-packages"
	test_var PYTHON_INCLUDEDIR python3_6 "/usr/include/python3.6${abiflags}"
	test_var PYTHON_LIBPATH python3_6 "/usr/lib*/libpython3.6${abiflags}$(get_libname)"
	test_var PYTHON_CONFIG python3_6 "/usr/bin/python3.6${abiflags}-config"
	test_var PYTHON_CFLAGS python3_6 "*-I/usr/include/python3.6*"
	test_var PYTHON_LIBS python3_6 "*-lpython3.6*"
fi
test_var PYTHON_PKG_DEP python3_6 '*dev-lang/python*:3.6'
test_var PYTHON_SCRIPTDIR python3_6 /usr/lib/python-exec/python3.6

test_var EPYTHON python3_7 python3.7
test_var PYTHON python3_7 /usr/bin/python3.7
if [[ -x /usr/bin/python3.7 ]]; then
	abiflags=$(/usr/bin/python3.7 -c 'import sysconfig; print(sysconfig.get_config_var("ABIFLAGS"))')
	test_var PYTHON_SITEDIR python3_7 "/usr/lib/python3.7/site-packages"
	test_var PYTHON_INCLUDEDIR python3_7 "/usr/include/python3.7${abiflags}"
	test_var PYTHON_LIBPATH python3_7 "/usr/lib*/libpython3.7${abiflags}$(get_libname)"
	test_var PYTHON_CONFIG python3_7 "/usr/bin/python3.7${abiflags}-config"
	test_var PYTHON_CFLAGS python3_7 "*-I/usr/include/python3.7*"
	test_var PYTHON_LIBS python3_7 "*-lpython3.7*"
fi
test_var PYTHON_PKG_DEP python3_7 '*dev-lang/python*:3.7'
test_var PYTHON_SCRIPTDIR python3_7 /usr/lib/python-exec/python3.7

test_var EPYTHON python3_8 python3.8
test_var PYTHON python3_8 /usr/bin/python3.8
if [[ -x /usr/bin/python3.8 ]]; then
	abiflags=$(/usr/bin/python3.8 -c 'import sysconfig; print(sysconfig.get_config_var("ABIFLAGS"))')
	test_var PYTHON_SITEDIR python3_8 "/usr/lib/python3.8/site-packages"
	test_var PYTHON_INCLUDEDIR python3_8 "/usr/include/python3.8${abiflags}"
	test_var PYTHON_LIBPATH python3_8 "/usr/lib*/libpython3.8${abiflags}$(get_libname)"
	test_var PYTHON_CONFIG python3_8 "/usr/bin/python3.8${abiflags}-config"
	test_var PYTHON_CFLAGS python3_8 "*-I/usr/include/python3.8*"
	test_var PYTHON_LIBS python3_8 "*-lpython3.8*"
fi
test_var PYTHON_PKG_DEP python3_8 '*dev-lang/python*:3.8'
test_var PYTHON_SCRIPTDIR python3_8 /usr/lib/python-exec/python3.8

test_var EPYTHON python3_9 python3.9
test_var PYTHON python3_9 /usr/bin/python3.9
if [[ -x /usr/bin/python3.9 ]]; then
	abiflags=$(/usr/bin/python3.9 -c 'import sysconfig; print(sysconfig.get_config_var("ABIFLAGS"))')
	test_var PYTHON_SITEDIR python3_9 "/usr/lib/python3.9/site-packages"
	test_var PYTHON_INCLUDEDIR python3_9 "/usr/include/python3.9${abiflags}"
	test_var PYTHON_LIBPATH python3_9 "/usr/lib*/libpython3.9${abiflags}$(get_libname)"
	test_var PYTHON_CONFIG python3_9 "/usr/bin/python3.9${abiflags}-config"
	test_var PYTHON_CFLAGS python3_9 "*-I/usr/include/python3.9*"
	test_var PYTHON_LIBS python3_9 "*-lpython3.9*"
fi
test_var PYTHON_PKG_DEP python3_9 '*dev-lang/python*:3.9'
test_var PYTHON_SCRIPTDIR python3_9 /usr/lib/python-exec/python3.9

test_var EPYTHON pypy3 pypy3
test_var PYTHON pypy3 /usr/bin/pypy3
if [[ -x /usr/bin/pypy3 ]]; then
	test_var PYTHON_SITEDIR pypy3 "/usr/lib*/pypy3.?/site-packages"
	test_var PYTHON_INCLUDEDIR pypy3 "/usr/lib*/pypy3.?/include"
fi
test_var PYTHON_PKG_DEP pypy3 '*dev-python/pypy3*:0='
test_var PYTHON_SCRIPTDIR pypy3 /usr/lib/python-exec/pypy3

test_is "python_is_python3 python2.7" 1
test_is "python_is_python3 python3.2" 0
test_is "python_is_python3 pypy" 1
test_is "python_is_python3 pypy3" 0

# generic shebangs
test_fix_shebang '#!/usr/bin/python' python2.7 '#!/usr/bin/python2.7'
test_fix_shebang '#!/usr/bin/python' python3.6 '#!/usr/bin/python3.6'
test_fix_shebang '#!/usr/bin/python' pypy3 '#!/usr/bin/pypy3'

# python2/python3 matching
test_fix_shebang '#!/usr/bin/python2' python2.7 '#!/usr/bin/python2.7'
test_fix_shebang '#!/usr/bin/python3' python2.7 FAIL
test_fix_shebang '#!/usr/bin/python3' python2.7 '#!/usr/bin/python2.7' --force
test_fix_shebang '#!/usr/bin/python3' python3.6 '#!/usr/bin/python3.6'
test_fix_shebang '#!/usr/bin/python2' python3.6 FAIL
test_fix_shebang '#!/usr/bin/python2' python3.6 '#!/usr/bin/python3.6' --force

# pythonX.Y matching (those mostly test the patterns)
test_fix_shebang '#!/usr/bin/python2.7' python2.7 '#!/usr/bin/python2.7'
test_fix_shebang '#!/usr/bin/python2.7' python3.2 FAIL
test_fix_shebang '#!/usr/bin/python2.7' python3.2 '#!/usr/bin/python3.2' --force
test_fix_shebang '#!/usr/bin/python3.2' python3.2 '#!/usr/bin/python3.2'
test_fix_shebang '#!/usr/bin/python3.2' python2.7 FAIL
test_fix_shebang '#!/usr/bin/python3.2' python2.7 '#!/usr/bin/python2.7' --force
test_fix_shebang '#!/usr/bin/pypy' python2.7 FAIL
test_fix_shebang '#!/usr/bin/pypy' python2.7 '#!/usr/bin/python2.7' --force

# fancy path handling
test_fix_shebang '#!/mnt/python2/usr/bin/python' python3.6 \
	'#!/mnt/python2/usr/bin/python3.6'
test_fix_shebang '#!/mnt/python2/usr/bin/python2' python2.7 \
	'#!/mnt/python2/usr/bin/python2.7'
test_fix_shebang '#!/mnt/python2/usr/bin/env python' python2.7 \
	'#!/mnt/python2/usr/bin/env python2.7'
test_fix_shebang '#!/mnt/python2/usr/bin/python2 python2' python2.7 \
	'#!/mnt/python2/usr/bin/python2.7 python2'
test_fix_shebang '#!/mnt/python2/usr/bin/python3 python2' python2.7 FAIL
test_fix_shebang '#!/mnt/python2/usr/bin/python3 python2' python2.7 \
	'#!/mnt/python2/usr/bin/python2.7 python2' --force
test_fix_shebang '#!/usr/bin/foo' python2.7 FAIL

# regression test for bug #522080
test_fix_shebang '#!/usr/bin/python ' python2.7 '#!/usr/bin/python2.7 '

# make sure we don't break pattern matching
test_is "_python_impl_supported python2_5" 1
test_is "_python_impl_supported python2_6" 1
test_is "_python_impl_supported python2_7" 0
test_is "_python_impl_supported python3_1" 1
test_is "_python_impl_supported python3_2" 1
test_is "_python_impl_supported python3_3" 1
test_is "_python_impl_supported python3_4" 1
test_is "_python_impl_supported python3_5" 1
test_is "_python_impl_supported python3_6" 0
test_is "_python_impl_supported python3_7" 0
test_is "_python_impl_supported python3_8" 0
test_is "_python_impl_supported pypy1_8" 1
test_is "_python_impl_supported pypy1_9" 1
test_is "_python_impl_supported pypy2_0" 1
test_is "_python_impl_supported pypy" 1
test_is "_python_impl_supported pypy3" 0

# check _python_impl_matches behavior
test_is "_python_impl_matches python2_7 -2" 0
test_is "_python_impl_matches python3_6 -2" 1
test_is "_python_impl_matches python3_7 -2" 1
test_is "_python_impl_matches pypy3 -2" 1
test_is "_python_impl_matches python2_7 -3" 1
test_is "_python_impl_matches python3_6 -3" 0
test_is "_python_impl_matches python3_7 -3" 0
test_is "_python_impl_matches pypy3 -3" 0
test_is "_python_impl_matches python2_7 -2 python3_6" 0
test_is "_python_impl_matches python3_6 -2 python3_6" 0
test_is "_python_impl_matches python3_7 -2 python3_6" 1
test_is "_python_impl_matches pypy3 -2 python3_6" 1
test_is "_python_impl_matches python2_7 pypy3 -2 python3_6" 0
test_is "_python_impl_matches python3_6 pypy3 -2 python3_6" 0
test_is "_python_impl_matches python3_7 pypy3 -2 python3_6" 1
test_is "_python_impl_matches pypy3 pypy3 -2 python3_6" 0
set -f
test_is "_python_impl_matches python2_7 pypy*" 1
test_is "_python_impl_matches python3_6 pypy*" 1
test_is "_python_impl_matches python3_7 pypy*" 1
test_is "_python_impl_matches pypy3 pypy*" 0
test_is "_python_impl_matches python2_7 python*" 0
test_is "_python_impl_matches python3_6 python*" 0
test_is "_python_impl_matches python3_7 python*" 0
test_is "_python_impl_matches pypy3 python*" 1
set +f

rm "${tmpfile}"

texit
