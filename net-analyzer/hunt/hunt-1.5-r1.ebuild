# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="tool for checking well known weaknesses in the TCP/IP protocol"
HOMEPAGE="http://lin.fsid.cvut.cz/~kra/index.html"
SRC_URI="http://lin.fsid.cvut.cz/~kra/hunt/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

src_prepare() {
	sed -i Makefile \
		-e 's:^CFLAGS=:CFLAGS += -I. :g' \
		-e '/^LDFLAGS=/d' \
		-e 's:${LDFLAGS}:$(LDFLAGS):g' \
		-e 's:-O2 -g::' \
		|| die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin hunt
	doman man/hunt.1
	dodoc CHANGES README* TODO tpsetup/transproxy
}
