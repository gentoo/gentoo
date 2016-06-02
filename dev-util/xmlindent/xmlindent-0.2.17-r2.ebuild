# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="XML stream reformatter written in ANSI C"
HOMEPAGE="http://xmlindent.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlindent/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""

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
