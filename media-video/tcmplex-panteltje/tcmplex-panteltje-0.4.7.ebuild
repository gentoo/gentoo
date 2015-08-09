# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils

DESCRIPTION="audio video multiplexer for 8 audio channels"
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	sed -e "s:CFLAGS = -O2:CFLAGS +=:" \
		-e "s:\$(LIBRARY):\$(LIBRARY) \$(LDFLAGS):" \
		-i Makefile
}

src_install() {
	dobin tcmplex-panteltje
	dodoc CHANGES COPYRIGHT README
}
