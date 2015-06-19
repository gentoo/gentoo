# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/ctwm/ctwm-3.8.2.ebuild,v 1.1 2014/08/25 14:39:03 jer Exp $

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A clean, light window manager"
HOMEPAGE="http://ctwm.org/"
SRC_URI="${HOMEPAGE}dist/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	app-text/rman
	virtual/jpeg
	x11-misc/imake
	x11-proto/xextproto
	x11-proto/xproto
"

src_prepare() {
	# overflow bug 338180
	sed -i menus.c -e "/char modStr/ s/5/6/" || die

	# implicit 'isspace'
	sed -i parse.c -e "/<stdio.h>/ a#include <ctype.h>" || die

	sed -i Imakefile -e "/^CONFDIR/s@=.*@= /etc/X11/twm@g" || die

	cp Imakefile.local-template Imakefile.local

	# TODO: Add GNOME support
	sed -i Imakefile.local -e '/^#define GNOME/d' || die
}

src_configure() {
	append-cppflags -DXPM -DJPEG
	xmkmf || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		TWMDIR=/usr/share/${PN}
}

src_install() {
	emake BINDIR=/usr/bin \
		MANPATH=/usr/share/man \
		TWMDIR=/usr/share/${PN} \
		DESTDIR="${D}" install

	emake MANPATH=/usr/share/man \
		DOCHTMLDIR=/usr/share/doc/${PF}/html \
		DESTDIR="${D}" install.man

	echo "#!/bin/sh" > ${T}/ctwm
	echo "/usr/bin/ctwm" >> ${T}/ctwm

	exeinto /etc/X11/Sessions
	doexe "${T}"/ctwm

	dodoc CHANGES README* TODO* PROBLEMS
	dodoc *.ctwmrc*
}
