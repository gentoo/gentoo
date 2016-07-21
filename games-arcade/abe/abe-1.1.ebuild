# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs games

DESCRIPTION="A scrolling, platform-jumping, key-collecting, ancient pyramid exploring game"
HOMEPAGE="http://abe.sourceforge.net/"
SRC_URI="mirror://sourceforge/abe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	x11-libs/libXi
	media-libs/sdl-mixer[vorbis]"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./images/images.tar
}

src_prepare() {
	sed -i \
		-e "/^TR_CFLAGS/d" \
		-e "/^TR_CXXFLAGS/d" \
		configure || die
	epatch "${FILESDIR}"/${P}-settings.patch
}

src_configure() {
	egamesconf --with-data-dir="${GAMES_DATADIR}"/${PN}
}

src_install() {
	dogamesbin src/abe
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images sounds maps
	newicon tom1.bmp abe.bmp
	make_desktop_entry abe "Abe's Amazing Adventure" /usr/share/pixmaps/abe.bmp
	dodoc AUTHORS ChangeLog README
	prepgamesdirs
}
