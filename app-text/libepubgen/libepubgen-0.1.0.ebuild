# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="EPUB generator for librevenge"
HOMEPAGE="https://sourceforge.net/projects/libepubgen/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug doc test"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		--disable-weffc \
		--disable-werror \
		$(use_enable debug) \
		$(use_with doc docs) \
		$(use_enable test tests)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
