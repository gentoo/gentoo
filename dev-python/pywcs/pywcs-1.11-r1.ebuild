# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

WCS_V=4.8.2
MYP=${P}-${WCS_V}

DESCRIPTION="Python routines for handling the FITS World Coordinate System"
HOMEPAGE="https://trac6.assembla.com/astrolib/wiki"
SRC_URI="http://stsdas.stsci.edu/astrolib/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=sci-astronomy/wcslib-${WCS_V}
	virtual/pkgconfig"
RDEPEND="
	>=sci-astronomy/wcslib-${WCS_V}
	virtual/pyfits
	!<dev-python/astropy-0.3"

# missing data to run tests
RESTRICT=test
S="${WORKDIR}/${MYP}"

python_prepare_all(){
	epatch "${FILESDIR}"/${P}-wcslib.patch
}

python_test() {
	nosetests -w "${BUILD_DIR}"/lib || die "Tests fail with ${EPYTHON}"
}
