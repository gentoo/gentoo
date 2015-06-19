# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cxfe/cxfe-0.9.2.ebuild,v 1.5 2014/08/10 20:57:46 slyfox Exp $

inherit eutils

DESCRIPTION="A command line interface for xine"
HOMEPAGE="http://people.iola.dk/anders/cxfe/"

SRC_URI="http://people.iola.dk/anders/cxfe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="lirc"

RDEPEND=">=media-libs/xine-lib-1_rc1
	   x11-libs/libX11
	   x11-libs/libXext
	   lirc? ( app-misc/lirc )
	   sys-libs/ncurses"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-asneeded.patch"
}

src_install() {
	dobin cxfe
	dodoc README TODO lircrc-example
}
