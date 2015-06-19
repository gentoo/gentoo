# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/mac-robber/mac-robber-1.02.ebuild,v 1.2 2012/02/16 17:35:50 phajdan.jr Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="mac-robber is a digital forensics and incident response tool that collects data"
HOMEPAGE="http://www.sleuthkit.org/mac-robber/index.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

src_prepare() {
	sed -i -e 's:$(GCC_CFLAGS):\0 $(LDFLAGS):' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" GCC_OPT="${CFLAGS}"
}

src_install() {
	dobin mac-robber
	dodoc CHANGES README
}
