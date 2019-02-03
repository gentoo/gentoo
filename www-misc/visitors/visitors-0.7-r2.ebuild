# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Fast web log analyzer"
HOMEPAGE="http://www.hping.org/visitors/"
SRC_URI="http://www.hping.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"

S="${WORKDIR}/${P/-/_}"

DOCS=( AUTHORS Changelog README TODO )
HTML_DOCS=( doc.html visitors.css visitors.png )

src_prepare() {
	default
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
		DEBUG=""
}

src_install() {
	einstalldocs
	dobin visitors
}
