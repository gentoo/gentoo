#!/bin/bash
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_8 )
source tests-common.sh || exit

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
	local exp_BDEPEND=${4}

	local IUSE=${IUSE}
	local RESTRICT=${RESTRICT}
	local BDEPEND=${BDEPEND}

	tbegin "${runner}"

	distutils_enable_tests "${runner}"

	local ret var val
	for var in IUSE RESTRICT BDEPEND; do
		local exp_var=exp_${var}
		# (this normalizes whitespace)
		read -d $'\0' -r -a val <<<"${!var}"
		val=${val[*]}
		if [[ ${val} != "${!exp_var}" ]]; then
			eindent
			eerror "${var} expected: ${!exp_var}"
			eerror "${var}   actual: ${val}"
			eoutdent
			ret=1
			tret=1
		fi
	done

	tend ${ret}
}

test-DISTUTILS_USE_SETUPTOOLS() {
	local DISTUTILS_USE_SETUPTOOLS=${1}
	local exp_BDEPEND=${2}
	local exp_RDEPEND=${3}

	tbegin "${1}"

	local BDEPEND=
	local RDEPEND=
	unset _DISTUTILS_R1_ECLASS
	inherit distutils-r1

	local ret var val
	for var in BDEPEND RDEPEND; do
		local exp_var=exp_${var}
		# (this normalizes whitespace)
		read -d $'\0' -r -a val <<<"${!var}"
		val=${val[*]}
		if [[ ${val} != "${!exp_var}" ]]; then
			eindent
			eerror "${var} expected: ${!exp_var}"
			eerror "${var}   actual: ${val}"
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
BASE_IUSE="python_targets_python3_8"
BASE_DEPS="python_targets_python3_8? ( >=dev-lang/python-3.8.12_p1-r1:3.8 )"
TEST_RESTRICT="!test? ( test )"

einfo "empty RDEPEND"
eindent
RDEPEND=""
test-distutils_enable_tests pytest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( >=dev-python/pytest-4.5.0[${PYTHON_USEDEP}] )"
test-distutils_enable_tests nose \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( >=dev-python/nose-1.3.7-r4[${PYTHON_USEDEP}] )"
test-distutils_enable_tests unittest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( dev-python/unittest-or-fail[${PYTHON_USEDEP}] )"
test-distutils_enable_tests setup.py \
	"${BASE_IUSE}" "" "${BASE_DEPS}"
eoutdent

einfo "non-empty RDEPEND"
eindent
BASE_RDEPEND="dev-python/foo[${PYTHON_USEDEP}]"
RDEPEND=${BASE_RDEPEND}
test-distutils_enable_tests pytest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( ${BASE_RDEPEND} >=dev-python/pytest-4.5.0[${PYTHON_USEDEP}] )"
test-distutils_enable_tests nose \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( ${BASE_RDEPEND} >=dev-python/nose-1.3.7-r4[${PYTHON_USEDEP}] )"
test-distutils_enable_tests unittest \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( ${BASE_RDEPEND} dev-python/unittest-or-fail[${PYTHON_USEDEP}] )"
test-distutils_enable_tests setup.py \
	"${BASE_IUSE} test" "${TEST_RESTRICT}" "${BASE_DEPS} test? ( ${BASE_RDEPEND} )"
eoutdent

eoutdent

einfo DISTUTILS_USE_SETUPTOOLS
eindent
SETUPTOOLS_DEP=">=dev-python/setuptools-42.0.2[python_targets_python3_8(-)?]"
test-DISTUTILS_USE_SETUPTOOLS no "${BASE_DEPS}" "${BASE_DEPS}"
test-DISTUTILS_USE_SETUPTOOLS bdepend "${BASE_DEPS} ${SETUPTOOLS_DEP}" "${BASE_DEPS}"
test-DISTUTILS_USE_SETUPTOOLS rdepend "${BASE_DEPS} ${SETUPTOOLS_DEP}" "${BASE_DEPS} ${SETUPTOOLS_DEP}"
test-DISTUTILS_USE_SETUPTOOLS pyproject.toml "${BASE_DEPS} >=dev-python/pyproject2setuppy-22[python_targets_python3_8(-)?]" "${BASE_DEPS}"
test-DISTUTILS_USE_SETUPTOOLS manual "${BASE_DEPS}" "${BASE_DEPS}"
eoutdent

texit
