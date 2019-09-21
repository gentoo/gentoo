# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A small, stable MUD client for the console"
HOMEPAGE="http://dw.nl.eu.org/mudix.html"
SRC_URI="http://dw.nl.eu.org/mudix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake O_FLAGS="${CFLAGS}"
}

src_install () {
	dobin mudix
	dodoc README sample.usr
}
