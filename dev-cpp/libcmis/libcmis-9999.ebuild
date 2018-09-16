# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/tdf/libcmis.git"
	inherit git-r3
elif [[ ${PV} = *_pre* ]]; then
	COMMIT=738528d790b2b1d52d9b72d673842969a852815d
	SRC_URI="https://github.com/tdf/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
else
	SRC_URI="https://github.com/tdf/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi
inherit autotools flag-o-matic

DESCRIPTION="C++ client library for the CMIS interface"
HOMEPAGE="https://github.com/tdf/libcmis"

LICENSE="|| ( GPL-2 LGPL-2 MPL-1.1 )"
SLOT="0.5"

# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

IUSE="man static-libs test"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libxml2
	net-misc/curl
"
DEPEND="${RDEPEND}
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

RESTRICT="test"

[[ ${PV} = *_pre* ]] && S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	[[ ${PV} = *_pre* || ${PV} = 9999 ]] && eautoreconf
}

src_configure() {
	# bug 618778
	append-cxxflags -std=c++14

	econf \
		--program-suffix=-${SLOT} \
		--disable-werror \
		$(use_with man) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		--enable-client
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
