# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Python wrapper for healpix"
HOMEPAGE="https://github.com/healpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-astronomy/healpix:=[cxx]
	sci-libs/cfitsio:="
DEPEND="${RDEPEND}
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( README.rst CHANGELOG.rst CITATION )

python_test() {
	echo "backend: Agg" > matplotlibrc || die
	MPLCONFIGDIR=. esetup.py test || die
	rm matplotlibrc || die
}
