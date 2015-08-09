# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="${PN}-${PV:0:3}-${PV:4:1}"

DESCRIPTION="Python interface to scientific netCDF library"
HOMEPAGE="http://pysclint.sourceforge.net/pycdf/"
SRC_URI="mirror://sourceforge/pysclint/${MY_P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/netcdf-3.6.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	use doc && dohtml doc/pycdf.html
	dodoc CHANGES doc/pycdf.txt
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
