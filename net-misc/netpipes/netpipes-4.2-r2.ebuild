# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dodir /usr/share/man
	emake INSTROOT="${D}"/usr INSTMAN="${D}"/usr/share/man install
}
