# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Implementation of a C++ SDK for DAP 2.0 and 3.2"
HOMEPAGE="http://opendap.org/"
SRC_URI="http://www.opendap.org/pub/source/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 URI )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

RDEPEND="
	dev-libs/libxml2:2
	net-misc/curl
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	test? ( dev-util/cppunit )"

PATCHES=(
	"${FILESDIR}/${PN}-3.18.1-fix-buildsystem.patch"
	"${FILESDIR}/${PN}-3.18.1-fix-c++14.patch"
	"${FILESDIR}/${PN}-3.18.1-disable-cache-test.patch"
	"${FILESDIR}/${PN}-3.18.1-disable-dmr-tests.patch"
	"${FILESDIR}/${PN}-3.18.1-disable-net-tests.patch"
	"${FILESDIR}/${PN}-3.18.1-disable-broken-tests.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 619144
	append-cxxflags -std=c++14

	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
