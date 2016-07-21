# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="A 3D Voronoi cell software library"
HOMEPAGE="http://math.lbl.gov/voro++/"
SRC_URI="${HOMEPAGE}/download/dir/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

src_configure() {
	mycmakeargs=( -DLIB=$(get_libdir) )
	cmake-utils_src_configure
}
