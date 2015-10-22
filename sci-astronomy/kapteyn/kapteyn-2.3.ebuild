# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Collection of python tools for astronomy"
HOMEPAGE="http://www.astro.rug.nl/software/kapteyn"
SRC_URI="http://www.astro.rug.nl/software/kapteyn/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	sci-astronomy/wcslib
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]"

DOCS=( CHANGES.txt README.txt doc/${PN}.pdf )

PATCHES=( "${FILESDIR}"/${PN}-2.2-debundle_wcs.patch )

python_prepare_all() {
	rm -r src/wcslib-4.* || die
	distutils-r1_python_prepare_all
}
