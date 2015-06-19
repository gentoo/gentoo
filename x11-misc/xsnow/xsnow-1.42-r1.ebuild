# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsnow/xsnow-1.42-r1.ebuild,v 1.7 2012/11/18 14:16:53 xarthisius Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="snow, reindeer, and santa on the root window"
HOMEPAGE="http://dropmix.xs4all.nl/rick/Xsnow/"
SRC_URI="http://dropmix.xs4all.nl/rick/Xsnow/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake
	x11-misc/gccmakedep
	x11-proto/xextproto
	x11-proto/xproto"

src_compile() {
	xmkmf || die
	make depend || die
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin xsnow || die
	rman -f HTML < xsnow._man > xsnow.1-html || die
	newman xsnow._man xsnow.1 || die
	newdoc xsnow.1-html xsnow.1.html || die
	dodoc README || die
}
