# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="XML stream reformatter for ASCII text, but not UTF-8, written in ANSI C"
HOMEPAGE="http://xmlindent.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlindent/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="app-alternatives/lex"

src_prepare() {
	default
	sed -i Makefile \
		-e 's|gcc|$(CC)|g' \
		-e 's|-g|$(CFLAGS) $(LDFLAGS) |g' \
		|| die "sed failed"
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin "${PN}"
	doman *.1
}
