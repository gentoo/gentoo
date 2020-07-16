# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Library to support the Open Financial eXchange XML format"
HOMEPAGE="https://github.com/libofx/libofx"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/7"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	test? ( app-crypt/gnupg )
"
RDEPEND="
	>=dev-cpp/libxmlpp-2.40.1:2.6
	>=net-misc/curl-7.9.7
	virtual/libiconv
"
DEPEND="${RDEPEND}
	>app-text/opensp-1.5
"

PATCHES=( "${FILESDIR}/${P}-docdir-nothanks.patch" )

# workaround needed for ofxconnect to compile
MAKEOPTS="-j1"

src_prepare() {
	default
	eautoreconf
	append-cxxflags -std=c++14 # bug #566456
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
	if ! use static-libs; then
		find "${D}" -name '*.a' -type f -delete || die
	fi
}
