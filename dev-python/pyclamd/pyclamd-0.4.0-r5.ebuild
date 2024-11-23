# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=pyClamd
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python interface to Clamd (ClamAV daemon)"
HOMEPAGE="https://xael.org/pages/pyclamd-en.html"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# Tests need clamd running and we cannot rely on that being
# true during build
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-remove-obsolete-bugtrack_url.diff" )
