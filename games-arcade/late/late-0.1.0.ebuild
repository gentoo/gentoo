# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/late/late-0.1.0.ebuild,v 1.16 2015/01/05 11:20:24 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A game, similar to Barrack by Ambrosia Software"
HOMEPAGE="http://late.sourceforge.net/"
SRC_URI="mirror://sourceforge/late/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-image[jpeg]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc46.patch
	sed -i \
		-e "/chown/d" \
		Makefile.in \
		|| die "sed failed"
}

src_install () {
	default
	newicon graphics/latebg2.jpg ${PN}.jpg
	make_desktop_entry late Late /usr/share/pixmaps/${PN}.jpg
	prepgamesdirs
}
