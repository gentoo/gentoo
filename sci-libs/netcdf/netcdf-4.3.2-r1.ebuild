# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/netcdf/netcdf-4.3.2-r1.ebuild,v 1.3 2015/02/22 10:58:10 pacho Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="http://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/netcdf/${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/7"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+dap examples hdf +hdf5 mpi static-libs szip test tools"

RDEPEND="
	dap? ( net-misc/curl:0= )
	hdf? ( sci-libs/hdf:0= sci-libs/hdf5:0= )
	hdf5? ( sci-libs/hdf5:0=[mpi=,szip=,zlib] )"
DEPEND="${RDEPEND}"
# doc generation is missing many doxygen files in tar ball
#	doc? ( app-doc/doxygen[dot] )"

REQUIRED_USE="test? ( tools ) szip? ( hdf5 ) mpi? ( hdf5 )"

PATCHES=( "${FILESDIR}/${P}-HDF5-1.8.13+-compat.patch" )

src_configure() {
	#	--docdir="${EPREFIX}"/usr/share/doc/${PF}
	#	$(use_enable doc doxygen)
	local myeconfargs=(
		--disable-examples
		--disable-dap-remote-tests
		$(use_enable dap)
		$(use_enable hdf hdf4)
		$(use_enable hdf5 netcdf-4)
		$(use_enable tools utilities)
	)
	if use mpi; then
		export CC=mpicc
		myeconfargs+=( --enable-parallel )
		use test && myeconfargs+=( --enable-parallel-tests )
	fi
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test -j1
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
