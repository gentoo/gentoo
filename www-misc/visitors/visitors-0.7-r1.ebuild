# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Fast web log analyzer"
HOMEPAGE="http://www.hping.org/visitors/"
SRC_URI="http://www.hping.org/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

S="${WORKDIR}/${P/-/_}"

src_prepare() {
	sed -i doc.html \
		-e 's:graph\.gif:graph.png:' \
		|| die "sed doc.html"
	sed -i Makefile \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile"
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} -Wall -W" \
		DEBUG="" \
		|| die "emake failed"
}

src_install() {
	dobin visitors
	dodoc AUTHORS Changelog README TODO
	dohtml doc.html visitors.css visitors.png
}
