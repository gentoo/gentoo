# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="libe-book"
MY_P="${MY_PN}-${PV}"

inherit autotools flag-o-matic

DESCRIPTION="Library parsing various ebook formats"
HOMEPAGE="http://www.sourceforge.net/projects/libebook/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc test tools"

RDEPEND="
	app-text/liblangtag
	dev-libs/icu:=
	dev-libs/librevenge
	dev-libs/libxml2
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/gperf
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 618854
	append-cxxflags -std=c++14

	econf \
		--disable-static \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable test tests) \
		$(use_with tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
