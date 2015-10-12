# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils eutils games

MY_PN=opensnc
MY_P=${MY_PN}-src-${PV}

DESCRIPTION="A free open-source game based on the Sonic the Hedgehog universe"
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="fetch" # unsure about legality of graphics

DEPEND="media-libs/allegro:0[X,jpeg,png,vorbis]
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libvorbis
	sys-libs/zlib
	virtual/jpeg"

S=${WORKDIR}/${MY_P}

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from:"
	einfo "http://sourceforge.net/projects/opensnc/files/Open%20Sonic/0.1.4/"
	einfo "and move it to ${DISTDIR}"
	echo
}

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
