# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="An OpenGL PNG image library"
HOMEPAGE="https://repo.or.cz/w/glpng.git"
SRC_URI="https://repo.or.cz/w/glpng.git/snapshot/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

RDEPEND="
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	virtual/glu[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
"
DEPEND=${RDEPEND}

S=${WORKDIR}/${PN}

src_configure() {
	local mycmakeargs=( -DBUILD_STATIC_LIBS=$(usex static-libs) )
	cmake-multilib_src_configure
}
