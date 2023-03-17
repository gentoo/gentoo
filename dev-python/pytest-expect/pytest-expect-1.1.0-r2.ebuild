# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin that stores test expectations by saving the set of failing tests"
HOMEPAGE="
	https://github.com/gsnedders/pytest-expect/
	https://pypi.org/project/pytest-expect/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
# no tests
RESTRICT="test"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/u-msgpack-python[${PYTHON_USEDEP}]
"
