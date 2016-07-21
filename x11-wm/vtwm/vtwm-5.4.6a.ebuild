# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="one of many TWM descendants and implements a Virtual Desktop"
HOMEPAGE="http://www.vtwm.org/"
SRC_URI="ftp://ftp.visi.com/users/hawkeyd/X/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-misc/imake
	app-text/rman
	x11-proto/xproto
	x11-proto/xextproto"

src_compile() {
	xmkmf || die "xmkmf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make BINDIR=/usr/bin \
		LIBDIR=/etc/X11 \
		MANPATH=/usr/share/man \
		DESTDIR="${D}" install || die "make install failed"

	echo "#!/bin/sh" > vtwm
	echo "xsetroot -cursor_name left_ptr &" >> vtwm
	echo "/usr/bin/vtwm" >> vtwm
	exeinto /etc/X11/Sessions
	doexe vtwm || die
	dodoc doc/{4.6.*,CHANGELOG,BUGS,DEVELOPERS,HISTORY,SOUND,WISHLIST} || die
}
