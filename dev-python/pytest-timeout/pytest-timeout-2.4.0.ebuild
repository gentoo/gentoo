# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin to abort hanging tests"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-timeout/
	https://pypi.org/project/pytest-timeout/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

# do not rdepend on pytest, it won't be used without it anyway
# pytest-cov used to test compatibility
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		!hppa? (
			$(python_gen_cond_dep '
				dev-python/pytest-cov[${PYTHON_USEDEP}]
			' python3_{11..13} 'pypy3*')
		)
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	if has_version "dev-python/pytest-cov[${PYTHON_USEDEP}]"; then
		local EPYTEST_PLUGINS=( "${EPYTEST_PLUGINS[@]}" pytest-cov )
	else
		EPYTEST_DESELECT+=(
			test_pytest_timeout.py::test_cov
		)
	fi

	epytest
}
