# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/tcmplex-panteltje/tcmplex-panteltje-0.4.7.ebuild,v 1.6 2011/03/20 14:19:39 hd_brummy Exp $

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
