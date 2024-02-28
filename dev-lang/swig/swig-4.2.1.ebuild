# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simplified Wrapper and Interface Generator"
HOMEPAGE="http://www.swig.org/ https://github.com/swig/swig"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
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
	# TODO: add USE for various langs? (https://bugs.gentoo.org/921504#c3)
	econf \
		PKGCONFIG="$(tc-getPKG_CONFIG)" \
		--without-maximum-compile-warnings \
		$(use_enable ccache) \
		$(use_with pcre)
}

src_test() {
	# The tests won't get run w/o an explicit call, broken Makefiles?
	# java skipped for bug #921504
	emake skip-java=true check
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r Doc/{Devel,Manual}
	fi
}
