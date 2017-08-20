# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions toolchain-funcs

DESCRIPTION="tRNA detection in large-scale genome sequences"
HOMEPAGE="http://lowelab.ucsc.edu/tRNAscan-SE/"
SRC_URI="http://lowelab.ucsc.edu/software/tRNAscan-SE.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}"/tRNAscan-SE-1.3.1/

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default
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
