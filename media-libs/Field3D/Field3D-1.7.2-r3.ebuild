# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="A library for storing voxel data"
HOMEPAGE="http://opensource.imageworks.com/?p=field3d"
SRC_URI="https://github.com/imageworks/Field3D/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="mpi"

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/imath-3.1.4-r2:=
	>=media-libs/openexr-3:0=
	sci-libs/hdf5:=
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.2-openexr-3-imath.patch
)

src_configure() {
	# Needed for now ("fix" compatibility with >=sci-libs/hdf5-1.12)
	# bug #808731
	append-cppflags -DH5_USE_110_API

	local mycmakeargs=(
		-DINSTALL_DOCS=OFF # Docs are not finished yet.
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
		$(cmake_use_find_package mpi MPI)
	)

	cmake_src_configure
}
