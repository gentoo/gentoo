# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="WordPerfect Document import/export library"
HOMEPAGE="http://libwpd.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0.10"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ~ppc64 x86"
IUSE="doc +tools"

RDEPEND="dev-libs/librevenge"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}/${P}-gcc-4.8.patch" )

src_configure() {
	local myeconfargs=(
		--program-suffix=-${SLOT}
		--disable-static
		$(use_with doc docs)
		$(use_enable tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
