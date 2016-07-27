# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Transparent Print Utility for terminals"
HOMEPAGE="https://sourceforge.net/projects/tprint/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

src_prepare() {
	sed -i Makefile \
		-e 's:cc:$(CC):g' \
		-e 's:-g -O2:$(CFLAGS) $(LDFLAGS):g' \
		|| die "sed failed"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	insinto /etc/tprint
	doins tprint.conf
	dobin tprint

	dodoc INSTALL README
}
