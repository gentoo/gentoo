# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cpl-stratego/cpl-stratego-0.4.ebuild,v 1.18 2009/09/23 17:17:25 patrick Exp $

inherit toolchain-funcs

DESCRIPTION="Choice library mostly used by Stratego"
SRC_URI="ftp://ftp.stratego-language.org/pub/stratego/stratego/${P}.tar.gz"
HOMEPAGE="http://www.stratego-language.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ppc alpha ia64"
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
