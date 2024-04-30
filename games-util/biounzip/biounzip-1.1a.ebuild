# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Unpacks BioZip archives"
HOMEPAGE="https://biounzip.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/biounzip/${P}.tar.bz2"
S="${WORKDIR}"/${P/a/}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-64bit.patch
)

src_compile() {
	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} -o ${PN} *.c -lz || die
}

src_install() {
	dobin ${PN}
	dodoc biozip.txt
}
