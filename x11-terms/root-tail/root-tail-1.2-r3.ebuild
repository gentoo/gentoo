# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/root-tail/root-tail-1.2-r3.ebuild,v 1.8 2012/05/15 15:36:23 hasufell Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Terminal to display (multiple) log files on the root window"
HOMEPAGE="http://oldhome.schmorp.de/marc/root-tail.html"
SRC_URI="http://oldhome.schmorp.de/marc/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="kde debug"

RDEPEND="x11-libs/libXext
	x11-libs/libX11"
DEPEND="x11-misc/imake
	app-text/rman
	x11-misc/gccmakedep
	x11-libs/libX11
	x11-proto/xproto"

src_prepare() {
	use kde && epatch "${FILESDIR}"/${P}-kde.patch
}

src_configure() {
	xmkmf -a
}

src_compile() {
	sed -i 's:/usr/X11R6/bin:/usr/bin:' Makefile || die "sed Makefile failed"
	use debug && append-flags -DDEBUG
	emake \
		CC=$(tc-getCC) \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install install.man || die "make install failed"
	dodoc Changes README
}
