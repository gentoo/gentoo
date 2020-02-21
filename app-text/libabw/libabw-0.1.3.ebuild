# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Library parsing abiword documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libabw"
SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="doc static-libs"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	sys-devel/libtool
"

src_configure() {
	# bug 619470
	append-cxxflags -std=c++14

	local myeconfargs=(
		$(use_with doc docs)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
