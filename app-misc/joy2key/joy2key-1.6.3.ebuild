# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/joy2key/joy2key-1.6.3.ebuild,v 1.5 2009/10/24 11:40:53 nixnut Exp $

DESCRIPTION="An application that translates joystick events to keyboard events"
HOMEPAGE="http://sourceforge.net/projects/joy2key"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11
	x11-apps/xwininfo )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

src_compile() {
	econf --disable-dependency-tracking $(use_enable X)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog joy2keyrc.sample rawscancodes README TODO
}
