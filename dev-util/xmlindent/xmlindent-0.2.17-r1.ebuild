# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="XML Indent is an XML stream reformatter written in ANSI C, analogous to GNU indent"
HOMEPAGE="http://xmlindent.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlindent/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
DEPEND="sys-devel/flex"
RDEPEND=""

src_prepare() {
	sed -i Makefile \
		-e 's|gcc|$(CC)|g' \
		-e 's|-g|$(CFLAGS) $(LDFLAGS) |g' \
		|| die "sed failed"
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dobin xmlindent || die "dobin failed"
	doman *.1
}
