# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A library for storing voxel data"
HOMEPAGE="http://opensource.imageworks.com/?p=field3d"
SRC_URI="https://github.com/imageworks/Field3D/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mpi"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/boost-1.62:=
	>=media-libs/ilmbase-2.2.0:=
	sci-libs/hdf5:=
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-Use-PkgConfig-for-IlmBase.patch" )

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOCS=OFF # Docs are not finished yet.
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
		$(cmake_use_find_package mpi MPI)
	)
	cmake_src_configure
}
