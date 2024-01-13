# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python interface to Frank Lübeck's Conway polynomial database"
HOMEPAGE="
	https://github.com/sagemath/conway-polynomials/
	https://pypi.org/project/conway-polynomials/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
