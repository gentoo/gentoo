# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="netCDF4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python/numpy interface to the netCDF C library"
HOMEPAGE="https://unidata.github.io/netcdf4-python/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy
	sci-libs/hdf5
	sci-libs/netcdf:=[hdf,hdf5]"
BDEPEND="${RDEPEND}"

RESTRICT="!test? ( test )"

S="${WORKDIR}"/${MY_P}

python_test() {
	cd test || die
	${PYTHON} run_all.py || die
}
