# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A library for storing voxel data"
HOMEPAGE="http://opensource.imageworks.com/?p=field3d"
SRC_URI="https://github.com/imageworks/Field3D/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-libs/boost-1.62:=
	>=media-libs/ilmbase-2.2.0:=
	sci-libs/hdf5:=
	virtual/mpi"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/Field3D-1.7.2-Use-PkgConfig-for-IlmBase.patch" )

# Docs are not finished yet.
mycmakeargs=( -DINSTALL_DOCS=OFF )
