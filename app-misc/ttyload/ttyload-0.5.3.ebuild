# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="color-coded graph of load averages over time"
HOMEPAGE="https://www.daveltd.com/src/util/ttyload https://github.com/lindes/ttyload"
SRC_URI="https://www.daveltd.com/src/util/${PN}/${P}.tar.bz2"

KEYWORDS="amd64 x86"
LICENSE="ISC"
SLOT="0"

DEPEND="sys-libs/ncurses:0="

RESTRICT="test"

DOCS=( BUGS HISTORY LICENSE README.md TODO )

src_prepare() {
	default
	sed -i '10i#include <time.h>' "${PN}.h" || die

	sed -e "s#make#$\(MAKE\)#" \
		-e "s#^CFLAGS.*#CFLAGS=\$(INCLUDES) ${CFLAGS} \$(VERSION)#" \
		-i Makefile || die
}

src_compile() {
	emake CC=$(tc-getCC) LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
