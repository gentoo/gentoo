# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/balloonchase/balloonchase-0.9.6.ebuild,v 1.10 2015/01/03 14:37:00 tupone Exp $

EAPI=4
inherit eutils toolchain-funcs games

DESCRIPTION="Fly a hot air balloon and try to blow the other player out of the screen"
HOMEPAGE="http://koti.mbnet.fi/makegho/c/bchase/"
SRC_URI="http://koti.mbnet.fi/makegho/c/bchase/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	sed -i "s:g++:$(tc-getCXX):" Makefile || die "sed failed"
	sed -i \
		-e "s:GENTOODIR:${GAMES_DATADIR}/${PN}:" src/main.c \
		|| die 'sed failed'
}

src_install() {
	dogamesbin ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r images
	newicon images/kp2b.bmp ${PN}.bmp
	make_desktop_entry ${PN} "Balloon Chase" /usr/share/pixmaps/${PN}.bmp
	dodoc README
	prepgamesdirs
}
