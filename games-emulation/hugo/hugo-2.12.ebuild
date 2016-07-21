# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="PC-Engine (Turbografx16) emulator for linux"
HOMEPAGE="http://www.zeograd.com/"
SRC_URI="http://www.zeograd.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/libsdl[video]
	media-libs/libvorbis"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}"-gcc41.patch
	append-cppflags $(pkg-config sdl --cflags)

}

src_install() {
	dogamesbin hugo
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r pixmaps
	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml doc/*html
	prepgamesdirs
}
