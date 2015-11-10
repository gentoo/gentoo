# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk,xml"
DISTUTILS_IN_SOURCE_BUILD=1
inherit eutils distutils-r1 toolchain-funcs

MY_P=${P/-/_}
MY_P=${MY_P/_rc/rc}

DESCRIPTION="Large suite of open source tools for the management and analysis of climate data"
HOMEPAGE="http://proj.badc.rl.ac.uk/cedaservices/wiki/CdatLite"
SRC_URI="http://ndg.nerc.ac.uk/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=sci-libs/netcdf-4.0.1
	>=sci-libs/hdf5-1.6.4
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	virtual/python-pmw[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	!sci-biology/ncbi-tools"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	tc-export CC FC RANLIB AR
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch
	find "${S}" -type l -delete || die
	distutils-r1_src_prepare
}
