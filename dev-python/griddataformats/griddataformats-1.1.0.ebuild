# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=GridDataFormats
PYPI_VERIFY_REPO=https://github.com/MDAnalysis/GridDataFormats
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Reading and writing of data on regular grids in Python"
HOMEPAGE="
	https://pypi.org/project/GridDataFormats/
	https://github.com/MDAnalysis/GridDataFormats/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/mrcfile[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.21[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
