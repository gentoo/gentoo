# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Code specific for Read the Docs and Sphinx"
HOMEPAGE="
	https://github.com/readthedocs/readthedocs-sphinx-ext/
	https://pypi.org/project/readthedocs-sphinx-ext/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/jinja-2.9[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

# unittest should be sufficient but tests are very verbose, so pytest's
# output capture is most welcome
distutils_enable_tests pytest
