# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Unpacks BioZip archives"
HOMEPAGE="http://biounzip.sourceforge.net/"
SRC_URI="mirror://sourceforge/biounzip/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND=${DEPEND}

S=${WORKDIR}/${P/a/}

src_prepare() {
	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} *.c -lz || die
}

src_install() {
	dobin ${PN}
	dodoc biozip.txt
}
