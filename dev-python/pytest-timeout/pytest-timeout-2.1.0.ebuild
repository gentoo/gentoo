# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin to abort hanging tests"
HOMEPAGE="https://pypi.org/project/pytest-timeout/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

# do not rdepend on pytest, it won't be used without it anyway
# pytest-cov used to test compatibility
BDEPEND="
	test? (
		dev-python/pexpect[${PYTHON_USEDEP}]
		!hppa? (
			$(python_gen_cond_dep '
				dev-python/pytest-cov[${PYTHON_USEDEP}]
			' python3_{8..10} pypy3)
		)
	)"

distutils_enable_tests pytest
