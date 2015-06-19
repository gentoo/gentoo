# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xvkbd/xvkbd-3.4a-r1.ebuild,v 1.5 2013/11/01 12:40:24 yac Exp $

EAPI=5
inherit toolchain-funcs eutils

DESCRIPTION="virtual keyboard for X window system"
HOMEPAGE="http://homepage3.nifty.com/tsato/xvkbd/"
SRC_URI="http://homepage3.nifty.com/tsato/xvkbd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXaw3d
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
"

src_prepare() {
	epatch_user
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) LD=$(tc-getCC) \
		XAPPLOADDIR="/etc/X11/app-defaults" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		CDEBUGFLAGS="${CFLAGS}"
}

src_install() {
	emake \
		XAPPLOADDIR="/etc/X11/app-defaults" \
		DESTDIR="${D}" \
		install

	rm -rf "${D}"/usr/lib "${D}"/etc

	dodoc README
	newman ${PN}.man ${PN}.1
}
