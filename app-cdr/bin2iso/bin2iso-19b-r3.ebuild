# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Convert CD images from bin/cue to iso+wav"
HOMEPAGE="http://web.archive.org/web/20070308130803/users.andara.com/~doiron/bin2iso"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

PATCHES=( "${FILESDIR}/${P}-sanity-checks.patch" )

S="${WORKDIR}/${PN}"

src_prepare() {
	edos2unix *.c
	append-cflags -ansi
	default
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${PN}${PV}_linux.c" -o ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
