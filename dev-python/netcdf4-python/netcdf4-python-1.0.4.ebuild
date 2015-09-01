# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="netCDF4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python/numpy interface to netCDF"
HOMEPAGE="https://github.com/Unidata/netcdf4-python"
SRC_URI="https://netcdf4-python.googlecode.com/files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	sci-libs/hdf5
	sci-libs/netcdf:=[hdf]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

python_test() {
	cd test || die
	${PYTHON} run_all.py || die
}
