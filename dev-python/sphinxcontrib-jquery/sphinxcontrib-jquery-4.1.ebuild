# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Extension to include jQuery on newer Sphinx releases"
HOMEPAGE="
	https://github.com/sphinx-contrib/jquery/
	https://pypi.org/project/sphinxcontrib-jquery/
"

# MIT for jQuery
LICENSE="0BSD MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
