# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/tdf/libcmis.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tdf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
fi
inherit autotools

DESCRIPTION="C++ client library for the CMIS interface"
HOMEPAGE="https://github.com/tdf/libcmis"

LICENSE="|| ( GPL-2 LGPL-2 MPL-1.1 )"
SLOT="0/0.6"
IUSE="man test tools"

RESTRICT="test"

DEPEND="
	dev-libs/boost:=
	dev-libs/libxml2
	net-misc/curl
"
RDEPEND="${DEPEND}
	!dev-cpp/libcmis:0.5
"
BDEPEND="
	virtual/pkgconfig
	man? (
		app-text/docbook2X
		dev-libs/libxslt
	)
	test? (
		dev-util/cppcheck
		dev-util/cppunit
	)
"

# https://github.com/tdf/libcmis/pull/52
PATCHES=( "${FILESDIR}/${P}-libxml2-2.12.patch" ) # bug 917523

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_with man)
		$(use_enable test tests)
		$(use_enable tools client)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
