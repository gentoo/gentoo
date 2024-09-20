# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin to re-run tests to eliminate flaky failures"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-rerunfailures/
	https://pypi.org/project/pytest-rerunfailures/
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/packaging-17.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()
	if has_version ">=dev-python/pytest-8.2[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			# https://github.com/pytest-dev/pytest-rerunfailures/issues/267
			tests/test_pytest_rerunfailures.py::test_exception_match_only_rerun_in_dual_query
			tests/test_pytest_rerunfailures.py::test_exception_matches_only_rerun_query
			tests/test_pytest_rerunfailures.py::test_exception_matches_rerun_except_query
			tests/test_pytest_rerunfailures.py::test_exception_not_match_rerun_except_query
			tests/test_pytest_rerunfailures.py::test_run_session_teardown_once_after_reruns
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_rerunfailures
	epytest
}
