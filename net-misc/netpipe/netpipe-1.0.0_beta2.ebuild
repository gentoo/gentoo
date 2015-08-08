# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="tool to reliably distribute binary data using UDP broadcasting techniques"
HOMEPAGE="http://www.wudika.de/~jan/netpipe/"
SRC_URI="http://www.wudika.de/~jan/netpipe/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "s:^OPT=.*:OPT = ${CFLAGS}:" \
		-e "s:^CC=.*:CC = $(tc-getCC):" \
		Makefile
}

src_install() {
	dobin netpipe || die "dobin failed"
	dodoc DOCUMENTATION INSTALL TECH-NOTES
}
