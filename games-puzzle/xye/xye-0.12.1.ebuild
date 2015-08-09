# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="Free version of the classic game Kye"
HOMEPAGE="http://xye.sourceforge.net/"
SRC_URI="mirror://sourceforge/xye/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	media-fonts/dejavu"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
	sed -i -e '/^xye_LDFLAGS/d' Makefile.am || die
	eautoreconf
}

src_install() {
	dogamesbin "${PN}"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r levels res
	rm -f "${D}${GAMES_DATADIR}/${PN}"/res/DejaVuSans*
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}/${PN}"/res/DejaVuSans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf "${GAMES_DATADIR}/${PN}"/res/DejaVuSans-Bold.ttf
	dodoc AUTHORS ChangeLog README NEWS
	dohtml ReadMe.html
	doicon xye.svg
	make_desktop_entry ${PN} Xye
	prepgamesdirs
}
