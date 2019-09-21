# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-funcs

DESCRIPTION="Choice library mostly used by Stratego"
SRC_URI="ftp://ftp.stratego-language.org/pub/stratego/stratego/${P}.tar.gz"
HOMEPAGE="http://www.stratego-language.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ia64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	econf || die "./configure failed"
	emake CC=$(tc-getCC) CC_DBG=$(tc-getCC) CC_GCC=$(tc-getCC)
	CC_PROF=$(tc-getCC)  || die
}

src_install () {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README*
}
