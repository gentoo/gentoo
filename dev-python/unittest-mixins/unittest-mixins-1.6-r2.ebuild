# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A set of mixin classes and other helpers for unittest test case classes"
HOMEPAGE="
	https://github.com/nedbat/unittest-mixins/
	https://pypi.org/project/unittest-mixins/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
