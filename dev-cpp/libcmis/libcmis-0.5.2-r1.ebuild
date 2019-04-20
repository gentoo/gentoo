# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/tdf/libcmis.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tdf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi
inherit autotools flag-o-matic

DESCRIPTION="C++ client library for the CMIS interface"
HOMEPAGE="https://github.com/tdf/libcmis"

LICENSE="|| ( GPL-2 LGPL-2 MPL-1.1 )"
SLOT="0.5"

IUSE="man static-libs test tools"

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
DEPEND="
	dev-libs/boost:=
	dev-libs/libxml2
	net-misc/curl
"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 618778
	append-cxxflags -std=c++14

	local myeconfargs=(
		--program-suffix=-$(ver_cut 1-2)
		--disable-werror
		$(use_with man)
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_enable tools client)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
