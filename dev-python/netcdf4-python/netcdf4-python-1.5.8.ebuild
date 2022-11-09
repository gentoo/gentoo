# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 optfeature

MY_PN="netCDF4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python/numpy interface to the netCDF C library"
HOMEPAGE="https://unidata.github.io/netcdf4-python/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	sci-libs/hdf5
	sci-libs/netcdf:=[hdf5]"
RDEPEND="${DEPEND}
	dev-python/cftime[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		sci-libs/hdf5
		sci-libs/netcdf[hdf5,tools]
		dev-python/cftime[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

python_test() {
	local -x NO_NET=1
	cd test || die
	"${EPYTHON}" run_all.py || die
}

pkg_postinst() {
	optfeature "HDF4 support" sci-libs/hdf "sci-libs/netcdf[hdf]"
	optfeature "MPI parallel IO support" "sci-libs/hdf5[mpi]" "sci-libs/netcdf[mpi]"
	optfeature "OPeNDAP support" net-misc/curl "sci-libs/netcdf[dap]"
}
