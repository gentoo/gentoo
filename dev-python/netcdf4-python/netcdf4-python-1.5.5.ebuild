# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 optfeature

MY_PN="netCDF4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python/numpy interface to the netCDF C library"
HOMEPAGE="https://unidata.github.io/netcdf4-python/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/cftime[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/hdf5
	sci-libs/netcdf:=[hdf5]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

S="${WORKDIR}"/${MY_P}

python_test() {
	cd test || die
	"${EPYTHON}" run_all.py || die
}

pkg_postinst() {
	optfeature "HDF4 support" sci-libs/hdf sci-libs/netcdf[hdf]
	optfeature "MPI parallel IO support" sci-libs/hdf5[mpi] sci-libs/netcdf[mpi]
	optfeature "OPeNDAP support" net-misc/curl sci-libs/netcdf[dap]
}
