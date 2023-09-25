# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Run tests in isolated forked subprocesses"
HOMEPAGE="
	https://pypi.org/project/pytest-forked/
	https://github.com/pytest-dev/pytest-forked/
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# Please do not RDEPEND on pytest; this package won't do anything
# without pytest installed, and there is no reason to force older
# implementations on pytest.
RDEPEND="
	dev-python/py[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	[[ ${PV} != 1.6.0 ]] && die "Recheck the deselect, please"
	local EPYTEST_DESELECT=()
	if [[ ${EPYTHON} == python3.12 ]]; then
		EPYTEST_DESELECT+=(
			# failing due to warnings coming from pytest
			# https://github.com/gentoo/gentoo/pull/31151
			testing/test_xfail_behavior.py::test_xfail
		)
	fi

	epytest -p no:flaky
}
