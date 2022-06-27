# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library parsing QuarkXpress documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libqxp"
SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 ~riscv x86"
IUSE="debug doc test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( dev-util/cppunit )
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
	find "${D}" -name '*.la' -type f -delete || die
}
