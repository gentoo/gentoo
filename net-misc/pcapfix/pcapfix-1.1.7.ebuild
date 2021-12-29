# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Repair and fix broken pcap files"
HOMEPAGE="https://f00l.de/pcapfix/"
SRC_URI="https://f00l.de/pcapfix/${P}.tar.gz"

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

src_configure() {
	tc-export CC
}

src_install() {
	doman pcapfix.1
	dobin pcapfix
	einstalldocs
}
