# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library parsing QuarkXpress documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/${PN}"
SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="debug doc test tools"

RDEPEND="
	dev-libs/librevenge
	dev-libs/icu:=
"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		--disable-weffc \
		$(use_enable debug) \
		$(use_with doc docs) \
		$(use_enable test tests) \
		$(use_enable tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
