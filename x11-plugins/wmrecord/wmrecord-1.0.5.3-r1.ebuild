# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A Dockable General Purpose Recording Utility"
HOMEPAGE="http://ret009t0.eresmas.net/other_software/wmrecord/"
SRC_URI="http://ret009t0.eresmas.net/other_software/wmrecord/${PN}-1.0.5_20040218_0029.tgz"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=sys-apps/sed-4.1.5-r1"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

S=${WORKDIR}/${PN}-1.0.5

src_unpack() {
	unpack ${A}

	#prevent auto-stripping of binaries. Closes bug #252112
	sed -i 's/install -s -o/install -o/' "${S}/Makefile"

	#Honour Gentoo LDFLAGS. Closes bug #336753.
	sed -i 's/-o $@ wmrecord.o/$(LDFLAGS) -o $@ wmrecord.o/' "${S}/Makefile"

	#Fix buffer overflow. Closes bug #336754.
	sed -i 's/sprintf(cse, "000");/snprintf(cse, "000", 3);/' "${S}/wmrecord.c"
}

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall" || die "make failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	einstall BINDIR="${D}/usr/bin" MANDIR="${D}/usr/share/man/man1" || die "make install failed"

	dodoc Changelog README TODO

	domenu "${FILESDIR}"/${PN}.desktop
}
