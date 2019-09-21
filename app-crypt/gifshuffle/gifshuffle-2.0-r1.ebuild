# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="GIF colourmap steganography"
HOMEPAGE="http://www.darkside.com.au/gifshuffle/"
SRC_URI="http://www.darkside.com.au/gifshuffle/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_compile() {
	echo $(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} *.c || die
	$(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} *.c || die "Cannot compile ${PN}"
}

src_install() {
	dobin ${PN}
	dodoc gshuf.txt
}
