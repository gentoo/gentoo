# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cgnslib/cgnslib-3.2.1.ebuild,v 1.1 2014/07/25 11:23:17 slis Exp $

EAPI=5

FORTRAN_NEEDED="fortran"

inherit cmake-utils fortran-2 versionator

MY_P="${PN}_$(replace_version_separator 3 '-')"
MY_S="${PN}_$(get_version_component_range 1-2)"

DESCRIPTION="The CFD General Notation System (CGNS) is a standard for CFD data"
HOMEPAGE="http://www.cgns.org/"
SRC_URI="mirror://sourceforge/project/cgns/${MY_S}/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran hdf5 legacy mpi szip zlib"

DEPEND="
	hdf5? ( >=sci-libs/hdf5-1.8[mpi=] )
	szip? ( sci-libs/szip )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}_${PV}

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
)

pkg_setup() {
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCGNS_ENABLE_64BIT=ON
		$(usex x86 -DCGNS_ENABLE_LFS=ON)
		$(cmake-utils_use fortran CGNS_ENABLE_FORTRAN)
		$(cmake-utils_use hdf5 CGNS_ENABLE_HDF5)
		$(cmake-utils_use legacy CGNS_ENABLE_LEGACY)
		$(cmake-utils_use mpi HDF5_NEED_MPI)
	)
	cmake-utils_src_configure
}
