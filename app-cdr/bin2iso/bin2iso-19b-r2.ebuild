# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="converts RAW format (.bin/.cue) files to ISO/WAV format"
HOMEPAGE="http://users.andara.com/~doiron/bin2iso/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-sanity-checks.patch )

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} bin2iso19b_linux.c -o ${PN} || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
