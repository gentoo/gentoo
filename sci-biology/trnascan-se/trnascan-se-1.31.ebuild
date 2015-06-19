# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/trnascan-se/trnascan-se-1.31.ebuild,v 1.1 2015/01/08 07:42:51 jlec Exp $

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no

inherit eutils perl-module toolchain-funcs

DESCRIPTION="tRNA detection in large-scale genome sequences"
HOMEPAGE="http://lowelab.ucsc.edu/tRNAscan-SE/"
SRC_URI="http://lowelab.ucsc.edu/software/tRNAscan-SE.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/tRNAscan-SE-1.3.1/

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed \
		-e "s:BINDIR  = \$(HOME)/bin:BINDIR = ${EPREFIX}/usr/bin:" \
		-e "s:LIBDIR  = \$(HOME)/lib/tRNAscan-SE:LIBDIR = ${EPRFIX}/usr/share/${PN}:" \
		-e "s:MANDIR  = \$(HOME)/man:MANDIR = ${EPREFIX}/usr/share/man:" \
		-e "s:CC = gcc:CC = $(tc-getCC):" \
		-e "s:CFLAGS = -O:CFLAGS = ${CFLAGS}:" \
		-i Makefile || die

	perl_set_version
}

src_test() {
	emake PATH="${S}:${PATH}" testrun
}

src_install() {
	dobin covels-SE coves-SE eufindtRNA tRNAscan-SE trnascan-1.4

	newman tRNAscan-SE.man tRNAscan-SE.man.1

	dodoc MANUAL README Release.history

	insinto /usr/share/${PN}/
	doins *.cm gcode.* Dsignal TPCsignal

	dodoc Manual.ps

	insinto ${VENDOR_LIB}
	doins -r tRNAscanSE
}
