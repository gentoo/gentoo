# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/abe/abe-1.1.ebuild,v 1.8 2015/01/03 12:57:17 tupone Exp $

EAPI=4
inherit eutils toolchain-funcs games

DESCRIPTION="A scrolling, platform-jumping, key-collecting, ancient pyramid exploring game"
HOMEPAGE="http://abe.sourceforge.net/"
SRC_URI="mirror://sourceforge/abe/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl
	x11-libs/libXi
	media-libs/sdl-mixer[vorbis]"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./images/images.tar
}

src_prepare() {
	sed -i \
		-e "/^TR_CFLAGS/d" \
		-e "/^TR_CXXFLAGS/d" \
		configure \
		|| die "sed failed"
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
