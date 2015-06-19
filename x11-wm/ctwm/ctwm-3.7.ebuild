# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/ctwm/ctwm-3.7.ebuild,v 1.12 2014/08/10 19:57:40 slyfox Exp $

inherit eutils

DESCRIPTION="A clean, light window manager"
HOMEPAGE="http://ctwm.free.lp.se/"
SRC_URI="http://ctwm.free.lp.se/dist/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}
	app-text/rman
	virtual/jpeg
	x11-misc/imake
	x11-proto/xextproto
	x11-proto/xproto"

src_compile() {
	sed -i -e "s@\(CONFDIR =\).*@\1 /etc/X11/twm@g" Imakefile \
		|| die "sed failed"

	cp Imakefile.local-template Imakefile.local

	xmkmf || die "xmkmf failed"
	make TWMDIR=/usr/share/${PN} || die "make failed"
}

src_install() {
	make BINDIR=/usr/bin \
		MANPATH=/usr/share/man \
		TWMDIR=/usr/share/${PN} \
		DESTDIR="${D}" install || die "make install failed"

	make MANPATH=/usr/share/man \
		DOCHTMLDIR=/usr/share/doc/${PF}/html \
		DESTDIR="${D}" install.man || die "make install.man failed"

	echo "#!/bin/sh" > ${T}/ctwm
	echo "/usr/bin/ctwm" >> ${T}/ctwm

	exeinto /etc/X11/Sessions
	doexe "${T}"/ctwm

	dodoc CHANGES README* TODO* PROBLEMS
	dodoc *.ctwmrc*
}
