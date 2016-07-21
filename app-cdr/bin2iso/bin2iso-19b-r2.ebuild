# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="converts RAW format (.bin/.cue) files to ISO/WAV format"
HOMEPAGE="http://users.andara.com/~doiron/bin2iso/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	edos2unix *.c
	epatch "${FILESDIR}"/${P}-sanity-checks.patch
}

src_compile() {
	$(tc-getCC) bin2iso19b_linux.c -o ${PN} ${CFLAGS} ${LDFLAGS} || die "compile failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"
	dodoc readme.txt
}
