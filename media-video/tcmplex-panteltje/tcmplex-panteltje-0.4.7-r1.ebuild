# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Audio video multiplexer for 8 audio channels"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	sed -e "s:CFLAGS = -O2:CFLAGS +=:" \
		-e "s:\$(LIBRARY):\$(LIBRARY) \$(LDFLAGS):" \
		-i Makefile || die
	default
}

src_install() {
	dobin tcmplex-panteltje
	dodoc CHANGES COPYRIGHT README
}
