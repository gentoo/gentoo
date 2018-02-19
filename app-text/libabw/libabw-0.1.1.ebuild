# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Library parsing abiword documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libabw"
SRC_URI="https://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	sys-devel/libtool
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	# from git master
	"${FILESDIR}/${PN}-0.1.1-dereference-before-null-check.patch"
	"${FILESDIR}/${PN}-0.1.1-do-not-let-AbiDocument_parse-throw.patch"
	"${FILESDIR}/${PN}-0.1.1-boost-1.59.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 619470
	append-cxxflags -std=c++14

	econf \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
