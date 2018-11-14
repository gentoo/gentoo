# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Small utility for making a poster from an EPS file or a one-page PS document"
SRC_URI="mirror://kde/printing/${P}.tar.bz2"
HOMEPAGE="https://printing.kde.org/downloads"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-fix_gs_crash.patch"
	"${FILESDIR}/${P}-fix_duplicate_DocumentMedia.patch"
	"${FILESDIR}/${P}-fix_cutmarks.patch"
)

src_compile(){
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} ${PN}.c -lm -o ${PN} || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README ChangeLog
}
