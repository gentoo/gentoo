# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tools to manipulate BSD TCP/IP stream sockets"
HOMEPAGE="http://web.purplefrog.com/~thoth/netpipes/netpipes.html"
SRC_URI="http://web.purplefrog.com/~thoth/netpipes/ftp/${P}-export.tar.gz"
S="${WORKDIR}/${P}-export"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}/${P}"-string.patch
)

src_prepare() {
	default
	sed -i \
		-e 's;CFLAGS =;CFLAGS +=;' \
		-e '/ -o /s;${CFLAGS};$(CFLAGS) $(LDFLAGS);g' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/share/man
	emake INSTROOT="${ED}"/usr INSTMAN="${ED}"/usr/share/man install
}
