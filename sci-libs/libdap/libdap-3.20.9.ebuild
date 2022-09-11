# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Implementation of a C++ SDK for DAP 2.0 and 3.2"
HOMEPAGE="https://www.opendap.org"
SRC_URI="https://www.opendap.org/pub/source/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 URI )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2:2
	net-misc/curl
	sys-apps/util-linux
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	sys-devel/flex
	test? ( dev-util/cppunit )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.20.9-disable-net-tests.patch
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
	find "${ED}" -name '*.la' -delete || die
}
