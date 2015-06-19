# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/amphetamine/amphetamine-0.8.10.ebuild,v 1.12 2015/01/03 13:16:41 tupone Exp $

EAPI=4
inherit eutils games

DESCRIPTION="a cool Jump'n Run game offering some unique visual effects"
HOMEPAGE="http://homepage.hispeed.ch/loehrer/amph/amph.html"
SRC_URI="http://homepage.hispeed.ch/loehrer/amph/files/${P}.tar.bz2
	http://homepage.hispeed.ch/loehrer/amph/files/${PN}-data-0.8.6.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	x11-libs/libXpm"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-64bit.patch
)

src_compile() {
	emake INSTALL_DIR="${GAMES_DATADIR}"/${PN}
}

src_install() {
	newgamesbin amph ${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ../amph/*
	newicon amph.xpm ${PN}.xpm
	make_desktop_entry ${PN} Amphetamine ${PN}
	dodoc BUGS ChangeLog NEWS README
	prepgamesdirs
}
