# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library parsing QuarkXpress documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/${PN}"
SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86"
IUSE="debug doc test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/librevenge
	dev-libs/icu:=
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local myeconfargs=(
		--disable-weffc
		$(use_enable debug)
		$(use_with doc docs)
		$(use_enable test tests)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
