# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A clean, light window manager"
HOMEPAGE="http://ctwm.free.lp.se/"
SRC_URI="http://ctwm.free.lp.se/dist/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
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

src_prepare() {
	sed -e "/char modStr/ s/5/6/" -i menus.c || die #overflow bug 338180
	sed -e "/<stdio.h>/ a#include <ctype.h>" -i parse.c || die #implicit 'isspace'
	sed -i Imakefile \
		-e "s@\(CONFDIR =\).*@\1 /etc/X11/twm@g" \
		|| die

	cp Imakefile.local-template Imakefile.local

	# TODO: Add GNOME support
	sed -i Imakefile.local \
		-e '/^#define GNOME/d' \
		|| die
}

src_compile() {
	xmkmf || die
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		TWMDIR=/usr/share/${PN} \
		|| die
}

src_install() {
	make BINDIR=/usr/bin \
		MANPATH=/usr/share/man \
		TWMDIR=/usr/share/${PN} \
		DESTDIR="${D}" install || die

	make MANPATH=/usr/share/man \
		DOCHTMLDIR=/usr/share/doc/${PF}/html \
		DESTDIR="${D}" install.man || die

	echo "#!/bin/sh" > ${T}/ctwm
	echo "/usr/bin/ctwm" >> ${T}/ctwm

	exeinto /etc/X11/Sessions
	doexe "${T}"/ctwm || die

	dodoc CHANGES README* TODO* PROBLEMS || die
	dodoc *.ctwmrc* || die
}
