# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Canon raw image (CRW) information and thumbnail extractor"
HOMEPAGE="http://freshmeat.net/projects/crwinfo/"
SRC_URI="http://neuemuenze.heim1.tu-clausthal.de/~sven/crwinfo/CRWInfo-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 alpha ia64 hppa ppc64"
IUSE=""

S="${WORKDIR}/CRWInfo-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
	sed \
		-e '/gcc/s:^.*$:\t$(CC) $(CFLAGS) -Wall -c crwinfo.c\n\t$(CC) $(LDFLAGS) -o crwinfo crwinfo.o:g' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	dobin crwinfo
	dodoc README spec
}
