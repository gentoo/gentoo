# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Reading and writing of data on regular grids in Python"
HOMEPAGE="
	https://pypi.org/project/GridDataFormats/
	https://github.com/MDAnalysis/GridDataFormats/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/mrcfile[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.0.3[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
