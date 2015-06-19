# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gifshuffle/gifshuffle-2.0.ebuild,v 1.2 2009/02/04 15:25:37 drizzt Exp $

inherit toolchain-funcs

DESCRIPTION="GIF colourmap steganography"
HOMEPAGE="http://www.darkside.com.au/gifshuffle/"
SRC_URI="http://www.darkside.com.au/gifshuffle/${PN}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${PN}

src_compile() {
	echo $(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} *.c
	$(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} *.c || die "Cannot compile ${PN}"
}

src_install() {
	dobin ${PN} || die "Cannot install ${PN}"
	dodoc gshuf.txt
}
