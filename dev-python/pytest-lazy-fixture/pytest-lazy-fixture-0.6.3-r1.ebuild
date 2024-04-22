# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="It helps to use fixtures in pytest.mark.parametrize"
HOMEPAGE="
	https://github.com/tvorog/pytest-lazy-fixture/
	https://pypi.org/project/pytest-lazy-fixture/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/pytest-8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
