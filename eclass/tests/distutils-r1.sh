#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
source tests-common.sh

test-phase_name_free() {
	local ph=${1}

	if declare -f "${ph}"; then
		die "${ph} function declared while name reserved for phase!"
	fi
	if declare -f "${ph}_all"; then
		die "${ph}_all function declared while name reserved for phase!"
	fi
}

test-distutils_enable_tests() {
	local runner=${1}
	local exp_IUSE=${2}
	local exp_RESTRICT=${3}
	local exp_DEPEND=${4}

	local IUSE=${IUSE}
	local RESTRICT=${RESTRICT}
	local DEPEND=${DEPEND}

	tbegin "${runner}"

	distutils_enable_tests "${runner}"

	local ret var
	for var in IUSE RESTRICT DEPEND; do
		local exp_var=exp_${var}
		if [[ ${!var} != "${!exp_var}" ]]; then
			eindent
			eerror "${var} expected: ${!exp_var}"
			eerror "${var}   actual: ${!var}"
			eoutdent
			ret=1
			tret=1
		fi
	done

	tend ${ret}
}

DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

tbegin "sane function names"

test-phase_name_free python_prepare
test-phase_name_free python_configure
test-phase_name_free python_compile
test-phase_name_free python_test
test-phase_name_free python_install

tend

einfo distutils_enable_tests
eindent
BASE_IUSE="python_targets_python2_7"
BASE_DEPS="python_targets_python2_7? ( >=dev-lang/python-2.7.5-r2:2.7 ) >=dev-lang/python-exec-2:=[python_targets_python2_7(-)?,-python_single_target_python2_7(-)]"
TEST_RESTRICT=" !test? ( test )"

einfo "empty RDEPEND"
eindent
RDEPEND=""
test-distutils_enable_tests pytest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( dev-python/pytest[${PYTHON_USEDEP}]  )"
test-distutils_enable_tests nose \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( dev-python/nose[${PYTHON_USEDEP}]  )"
test-distutils_enable_tests unittest \
	"${BASE_IUSE}" "" "${BASE_DEPS}"
test-distutils_enable_tests setup.py \
	"${BASE_IUSE}" "" "${BASE_DEPS}"
eoutdent

einfo "non-empty RDEPEND"
eindent
BASE_RDEPEND="dev-python/foo[${PYTHON_USEDEP}]"
RDEPEND=${BASE_RDEPEND}
test-distutils_enable_tests pytest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( dev-python/pytest[${PYTHON_USEDEP}] ${BASE_RDEPEND} )"
test-distutils_enable_tests nose \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( dev-python/nose[${PYTHON_USEDEP}] ${BASE_RDEPEND} )"
test-distutils_enable_tests unittest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? (  ${BASE_RDEPEND} )"
test-distutils_enable_tests setup.py \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? (  ${BASE_RDEPEND} )"
eoutdent

eoutdent

texit
