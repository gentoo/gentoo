# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Microsoft Works file word processor format import filter library"
HOMEPAGE="https://sourceforge.net/p/libwps/wiki/Home/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="debug doc tools"

DEPEND="dev-libs/librevenge"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with doc docs)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
