# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="client for the french tarot game maitretarot"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="https://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot
	dev-games/libmt_client
	sys-libs/ncurses:0"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
	"${FILESDIR}"/${PN}-0.1.98-libdir.patch
)

src_configure() {
	export LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
	default
}
