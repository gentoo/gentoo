# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="GIF colourmap steganography"
HOMEPAGE="https://darkside.com.au/gifshuffle/"
SRC_URI="https://darkside.com.au/gifshuffle/${PN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	echo $(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} *.c || die
	$(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} *.c || die "Cannot compile ${PN}"
}

src_install() {
	dobin ${PN}
	dodoc gshuf.txt
}
