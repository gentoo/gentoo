# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="friendly GUI version of xmahjongg"
HOMEPAGE="http://www.lcdf.org/xmahjongg/"
SRC_URI="http://www.lcdf.org/xmahjongg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_prepare() {
	sed -i \
		-e '/X_PRE_LIBS/s:-lSM -lICE::' \
		configure || die
}

src_install() {
	default
	newicon share/tiles/small.gif ${PN}.gif
	make_desktop_entry xmahjongg "Xmahjongg" /usr/share/pixmaps/${PN}.gif
	prepgamesdirs
}
