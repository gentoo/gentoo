# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://github.com/Unidata/netcdf-c/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/11"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+dap examples hdf +hdf5 mpi static-libs szip test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	dap? ( net-misc/curl:0= )
	hdf? ( sci-libs/hdf:0= sci-libs/hdf5:0= )
	hdf5? ( sci-libs/hdf5:0=[hl(+),mpi=,szip=,zlib] )"
DEPEND="${RDEPEND}"
# doc generation is missing many doxygen files in tar ball
#	doc? ( app-doc/doxygen[dot] )"

REQUIRED_USE="test? ( tools ) szip? ( hdf5 ) mpi? ( hdf5 )"

S="${WORKDIR}/${PN}-c-${PV}"

src_configure() {
	local myconf
	if use mpi; then
		export CC=mpicc
	fi
	econf "${myconf}" \
		--disable-examples \
		--disable-dap-remote-tests \
		$(use_enable dap) \
		$(use_enable hdf hdf4) \
		$(use_enable hdf5 netcdf-4) \
		$(use_enable static-libs static) \
		$(use_enable tools utilities)
}

src_test() {
	# fails parallel tests: bug #621486
	emake check -j1
}

src_install() {
	default
	use examples && dodoc -r examples
	prune_libtool_files
}
