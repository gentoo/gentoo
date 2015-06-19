# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/grande-KXL/grande-KXL-0.6.ebuild,v 1.13 2015/01/04 15:10:18 tupone Exp $
EAPI=5
inherit autotools eutils games

DESCRIPTION="ZANAC type game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-games/KXL"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{configure.in,cflags}.patch
	mv configure.{in,ac}
	rm aclocal.m4
	eautoreconf
}

src_install() {
	dodir "${GAMES_STATEDIR}"
	default
	newicon src/bmp/boss1.bmp ${PN}.bmp
	make_desktop_entry grande Grande /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
