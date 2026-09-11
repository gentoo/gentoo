#!/bin/bash
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

test_set_wheels() {
	local whl
	for whl in "${DISTUTILS_WHEELS[@]}"; do
		DISTUTILS_WHEEL_PATHS[${whl}]=${PWD}
	done
}

test_best_wheel() {
	local impl=${1}
	local expect=${2}

	tbegin "${impl} (expected: ${expect:-[none]})"

	local got=$(
		die() {
			echo ERROR
			exit 0
		}

		EPYTHON=${impl}
		_distutils-r1_find_best_wheel
	)
	[[ ${got} == ${expect} ]] || eerror "${impl}: ${got} != ${expect}"

	tend ${?}
}

DISTUTILS_ALLOW_WHEEL_REUSE=1
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1

einfo "Testing _distutils-r1_find_best_wheel ..."
eindent

einfo "empty wheel list"
eindent
test_best_wheel python3.12 ""
test_best_wheel python3.15 ""
test_best_wheel python3.15t ""
eoutdent

DISTUTILS_WHEELS=( /tmp/test-0-py3-none-any.whl )
test_set_wheels
einfo "py3-none-any with no extensions"
eindent
test_best_wheel python3.12 "${DISTUTILS_WHEELS[0]}"
test_best_wheel python3.15 "${DISTUTILS_WHEELS[0]}"
test_best_wheel python3.15t "${DISTUTILS_WHEELS[0]}"
eoutdent

DISTUTILS_EXT=1
einfo "py3-none-any with C extensions"
eindent
test_best_wheel python3.12 ""
test_best_wheel python3.15 ""
test_best_wheel python3.15t ""
eoutdent

DISTUTILS_WHEELS=( /tmp/test-0-{cp312-cp312,cp313-cp313}-linux.whl )
test_set_wheels
einfo "cp312-cp312 and cp313-cp313 wheels"
eindent
test_best_wheel python3.12 ERROR
test_best_wheel python3.13 ""
test_best_wheel python3.15 ""
test_best_wheel python3.15t ""
eoutdent

DISTUTILS_WHEELS=( /tmp/test-0-cp312-abi3-linux.whl )
test_set_wheels
einfo "cp312-abi3 wheel"
eindent
test_best_wheel python3.12 "${DISTUTILS_WHEELS[0]}"
test_best_wheel python3.13 "${DISTUTILS_WHEELS[0]}"
test_best_wheel python3.15 "${DISTUTILS_WHEELS[0]}"
test_best_wheel python3.15t ""
eoutdent

DISTUTILS_WHEELS=( /tmp/test-0-{cp312,cp313}-abi3-linux.whl )
test_set_wheels
einfo "cp312-abi3 and cp313-abi3 wheel"
eindent
test_best_wheel python3.12 ERROR
test_best_wheel python3.13 "${DISTUTILS_WHEELS[1]}"
test_best_wheel python3.15 "${DISTUTILS_WHEELS[1]}"
test_best_wheel python3.15t ""
eoutdent

DISTUTILS_WHEELS=( /tmp/test-0-{cp312-abi3,cp315-abi3.abi3t}-linux.whl )
test_set_wheels
einfo "cp312-abi3 and cp315-abi3.abi3t wheel"
eindent
test_best_wheel python3.13 ERROR
test_best_wheel python3.15 "${DISTUTILS_WHEELS[1]}"
test_best_wheel python3.15t "${DISTUTILS_WHEELS[1]}"
eoutdent

DISTUTILS_WHEELS=( /tmp/test-0-{cp312-abi3,cp315-abi3t}-linux.whl )
test_set_wheels
einfo "cp312-abi3 and cp315-abi3t wheel (weird but technically valid)"
eindent
test_best_wheel python3.13 ERROR
test_best_wheel python3.15 "${DISTUTILS_WHEELS[0]}"
test_best_wheel python3.15t "${DISTUTILS_WHEELS[1]}"
eoutdent

eoutdent

texit
