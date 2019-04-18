# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Repair and fix broken pcap files"
HOMEPAGE="http://f00l.de/pcapfix/"
SRC_URI="http://f00l.de/pcapfix/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( Changelog README )

src_prepare() {
	default
	sed -e 's/gcc/$(CC) $(CFLAGS)/g' -i Makefile || die
	use debug || sed -e 's/DEBUGFLAGS = -g/DEBUGFLAGS =/g' -i Makefile || die
}

src_install() {
	doman pcapfix.1
	dobin pcapfix
	einstalldocs
}
