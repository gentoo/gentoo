# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE=""

DESCRIPTION="The ultimate lightweight window manager"
SRC_URI="http://www.jfc.org.uk/files/lwm/${P}.tar.gz"
HOMEPAGE="http://www.jfc.org.uk/software/lwm.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86 ~x86-fbsd"

RDEPEND="x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-misc/imake"

src_compile() {
	xmkmf || die
	emake lwm || die
}

src_install() {

	dobin lwm

	newman lwm.man lwm.1
	dodoc AUTHORS BUGS ChangeLog INSTALL README TODO
}
