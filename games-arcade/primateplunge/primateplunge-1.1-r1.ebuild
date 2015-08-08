# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

DESCRIPTION="Help poor Monkey navigate his way down through treacherous areas"
HOMEPAGE="http://www.aelius.com/primateplunge/"
SRC_URI="http://www.aelius.com/${PN}/${P}.tar.gz"

LICENSE="Primate-Plunge"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""
RESTRICT="mirror bindist" #465850

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-AC_SUBST.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README TIPS
	newicon graphics/idle.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Primate Plunge" /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
