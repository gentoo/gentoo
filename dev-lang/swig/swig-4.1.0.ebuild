# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/ https://github.com/swig/swig"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="ccache doc pcre test"
RESTRICT="!test? ( test )"

RDEPEND="
	pcre? ( dev-libs/libpcre2 )
	ccache? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/boost )
"
BDEPEND="virtual/pkgconfig"

DOCS=( ANNOUNCE CHANGES CHANGES.current README TODO )

src_configure() {
	econf \
		PKGCONFIG="$(tc-getPKG_CONFIG)" \
		$(use_enable ccache) \
		$(use_with pcre)
}

src_test() {
	# The tests won't get run w/o an explicit call, broken Makefiles?
	emake check
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r Doc/{Devel,Manual}
	fi
}
