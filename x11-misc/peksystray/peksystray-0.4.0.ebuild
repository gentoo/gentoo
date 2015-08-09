# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils

DESCRIPTION="A system tray dockapp for window managers supporting docking"
HOMEPAGE="http://peksystray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXt"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	eautoreconf
}

src_install() {
	dobin src/peksystray || die
	dodoc AUTHORS ChangeLog NEWS README REFS THANKS TODO
}
