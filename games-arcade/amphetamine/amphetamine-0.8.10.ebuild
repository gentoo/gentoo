# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
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
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-64bit.patch
	sed -i -e '55d' src/ObjInfo.cpp || die
}

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
