# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Library to support the Open Financial eXchange XML format"
HOMEPAGE="https://github.com/libofx/libofx"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/10"
KEYWORDS="~amd64 ~arm64 ppc ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	test? ( app-crypt/gnupg )
"
RDEPEND="
	>app-text/opensp-1.5
	>=dev-cpp/libxmlpp-2.40.1:2.6
	>=net-misc/curl-7.9.7
	virtual/libiconv
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Not included in the tarball
	sed -i -e '/INSTALL/d' Makefile.am || die
	# Use correct location for docs
	sed -i -e 's:doc/libofx:doc/${PF}:' Makefile.am doc/Makefile.am || die

	eautoreconf
	append-cxxflags -std=c++14 # bug #566456
}

src_configure() {
	econf --disable-static
}

src_compile() {
	emake -j1
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
	find "${ED}" -name '*.a' -type f -delete || die
}
