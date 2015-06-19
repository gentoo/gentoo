# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xfishtank/xfishtank-2.1.ebuild,v 1.14 2014/08/10 20:04:58 slyfox Exp $

inherit eutils

MY_P=${P}tp

DESCRIPTION="Turns your root window into an aquarium"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/X11/demos/"
SRC_URI="http://www.ibiblio.org/pub/Linux/X11/demos/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="ppc ppc64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-misc/makedepend"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${MY_P}-Makefile.patch"
	cd "${S}"
	sed -i -e 's,INSTPGMFLAGS = -s,INSTPGMFLAGS =,' Makefile || die
}

src_compile() {
	makedepend || die "makedepend failed"
	emake || die "emake failed"
}

src_install() {
	make BINDIR=/usr/bin DESTDIR="${D}" install || die "make install failed"
	dodoc README README.Linux README.TrueColor README.Why.2.1tp
}
