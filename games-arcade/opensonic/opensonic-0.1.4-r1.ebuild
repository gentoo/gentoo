# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils games

MY_PN=opensnc
MY_P=${MY_PN}-src-${PV}

DESCRIPTION="A free open-source game based on the Sonic the Hedgehog universe"
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/opensnc/files/Open%20Sonic/${PV}/opensnc-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror" # unsure about legality of graphics

DEPEND="media-libs/allegro:0[X,jpeg,png,vorbis]
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libvorbis
	sys-libs/zlib
	virtual/jpeg:0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PF}-cmake.patch
}

src_configure() {
	local mycmakeargs=(
		-DGAME_INSTALL_DIR="${GAMES_DATADIR}"/${PN}
		-DGAME_FINAL_DIR="${GAMES_BINDIR}"
		-DGAME_LIBDIR="$(games_get_libdir)/${PN}"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	local i
	for i in $(ls "${D}${GAMES_DATADIR}/${PN}") ; do
		dosym "${GAMES_DATADIR}/${PN}/${i}" \
			"$(games_get_libdir)/${PN}/${i}"
	done
	prepgamesdirs
}
