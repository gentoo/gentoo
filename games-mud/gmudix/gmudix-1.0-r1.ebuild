# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="GTK+ MUD client with many features and an easy scripting language"
HOMEPAGE="http://dw.nl.eu.org/mudix.html"
SRC_URI="http://dw.nl.eu.org/gmudix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-format.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	rm -f missing || die
	eautoreconf
}

src_install() {
	dobin src/${PN}
	dodoc AUTHORS ChangeLog README TODO doc/*txt
}
