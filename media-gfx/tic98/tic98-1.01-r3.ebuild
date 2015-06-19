# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tic98/tic98-1.01-r3.ebuild,v 1.6 2012/10/04 15:57:42 ottxor Exp $

EAPI=4

inherit eutils

DESCRIPTION="compressor for black-and-white images, in particular scanned documents"
HOMEPAGE="http://membled.com/work/mirror/tic98/"
SRC_URI="http://membled.com/work/mirror/tic98/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RESTRICT="test"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-macos.patch
	epatch "${FILESDIR}"/${P}-gentoo.diff
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch

	# respect CFLAGS and LDFLAGS
	sed -i -e "s:CFLAGS= -O -Wall -Wno-unused:CFLAGS=${CFLAGS}:" \
		-e "s:LIBS=   -lm #-L/home/singlis/linux/lib -lccmalloc -ldl:LIBS= -lm ${LDFLAGS}:" \
		-e "s:CC=	gcc -pipe :CC=$(tc-getCC):" \
		-e "s:CPP=	gcc -pipe:CPP=$(tc-getCPP):" \
		Makefile || die
}

src_compile() {
	emake all
	emake all2
}

src_install() {
	dodir /usr/bin
	emake BIN="${ED}"usr/bin install

	# collision with media-gfx/netpbm, see bug #207534
	rm "${ED}"/usr/bin/pbmclean || die
}
