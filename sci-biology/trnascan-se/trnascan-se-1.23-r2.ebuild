# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils multilib toolchain-funcs

DESCRIPTION="tRNA detection in large-scale genome sequences"
HOMEPAGE="http://lowelab.ucsc.edu/tRNAscan-SE/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
	sed -e "s%BINDIR  = \$(HOME)/bin%BINDIR = ${EPREFIX}/usr/bin%" \
		-e "s%LIBDIR  = \$(HOME)/lib/tRNAscan-SE%LIBDIR = ${EPRFIX}/usr/$(get_libdir)/${PN}%" \
		-e "s%MANDIR  = \$(HOME)/man%MANDIR = ${EPREFIX}/usr/share/man%" \
		-e "s%CC = gcc%CC = $(tc-getCC)%" \
		-e "s%CFLAGS = -O%CFLAGS = ${CFLAGS}%" \
		-i Makefile || die
}

src_install() {
	mv tRNAscan-SE.man tRNAscan-SE.man.1 || die
	dobin covels-SE coves-SE eufindtRNA tRNAscan-SE trnascan-1.4 || die
	doman tRNAscan-SE.man.1 || die
	dodoc MANUAL README Release.history || die
	insinto /usr/$(get_libdir)/${PN}/
	doins *.cm gcode.* Dsignal TPCsignal || die
	insinto /usr/share/doc/${PF}
	doins Manual.ps || die
}

src_test() {
	make PATH="${S}:${PATH}" testrun || die
}
