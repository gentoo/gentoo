# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Manage external processes across test runs"
HOMEPAGE="
	https://pypi.org/project/pytest-xprocess/
	https://github.com/pytest-dev/pytest-xprocess/
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
