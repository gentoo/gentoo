# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Tool for recovering passwords and content from PDF-files"
HOMEPAGE="http://pdfcrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-0.14-cflags.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin pdfcrack
	dodoc changelog README
}
