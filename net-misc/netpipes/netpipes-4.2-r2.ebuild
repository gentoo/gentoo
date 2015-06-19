# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netpipes/netpipes-4.2-r2.ebuild,v 1.4 2014/07/18 19:53:46 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="a package to manipulate BSD TCP/IP stream sockets"
HOMEPAGE="http://web.purplefrog.com/~thoth/netpipes/"
SRC_URI="http://web.purplefrog.com/~thoth/netpipes/ftp/${P}-export.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"

S=${WORKDIR}/${P}-export

src_prepare() {
	sed -i \
		-e 's:CFLAGS =:CFLAGS +=:' \
		-e '/ -o /s:${CFLAGS}:$(CFLAGS) $(LDFLAGS):g' \
		Makefile || die

	epatch "${FILESDIR}/${P}"-string.patch
}

src_compile () {
	emake CC=$(tc-getCC)
}

src_install() {
	dodir /usr/share/man
	emake INSTROOT="${D}"/usr INSTMAN="${D}"/usr/share/man install
}
