# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib

DESCRIPTION="An OpenGL PNG image library"
HOMEPAGE="http://repo.or.cz/w/glpng.git"
SRC_URI="http://repo.or.cz/w/glpng.git/snapshot/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

RDEPEND="virtual/opengl[${MULTILIB_USEDEP}]
	virtual/glu[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]"
DEPEND=${RDEPEND}

S=${WORKDIR}/${PN}

src_configure() {
	local mycmakeargs=( "$(cmake-utils_use_build static-libs STATIC_LIBS)" )
	cmake-multilib_src_configure
}
