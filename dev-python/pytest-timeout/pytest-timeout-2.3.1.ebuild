# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin to abort hanging tests"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-timeout/
	https://pypi.org/project/pytest-timeout/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

# do not rdepend on pytest, it won't be used without it anyway
# pytest-cov used to test compatibility
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		!hppa? (
			dev-python/pytest-cov[${PYTHON_USEDEP}]
		)
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_timeout

	if has_version dev-python/pytest-cov; then
		PYTEST_PLUGINS+=,pytest_cov.plugin
	else
		EPYTEST_DESELECT+=(
			test_pytest_timeout.py::test_cov
		)
	fi

	epytest
}
