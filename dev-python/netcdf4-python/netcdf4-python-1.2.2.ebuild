# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

MY_PN="netCDF4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python/numpy interface to the netCDF C library"
HOMEPAGE="http://unidata.github.io/netcdf4-python"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy
	sci-libs/hdf5
	sci-libs/netcdf:=[hdf,hdf5]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

python_test() {
	cd test || die
	${PYTHON} run_all.py || die
}
