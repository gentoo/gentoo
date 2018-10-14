# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A 3D Voronoi cell software library"
HOMEPAGE="http://math.lbl.gov/voro++/"
SRC_URI="${HOMEPAGE}/download/dir/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}
