# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Library to support the Open Financial eXchange XML format"
HOMEPAGE="https://github.com/libofx/libofx"
SRC_URI="https://github.com/libofx/libofx/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/10"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( app-crypt/gnupg )
"
RDEPEND="
	>app-text/opensp-1.5
	app-text/openjade
	>=dev-cpp/libxmlpp-2.40.1:2.6
	>=net-misc/curl-7.9.7
	virtual/libiconv
"
DEPEND="${RDEPEND}"

src_configure() {
	# bug #566456
	append-cxxflags -std=c++14

	econf $(use_enable doc html-docs)
}

src_compile() {
	emake all $(usev doc)
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die
	find "${ED}" -name '*.a' -type f -delete || die
}
