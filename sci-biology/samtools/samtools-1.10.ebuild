# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-lang/perl
	=sci-libs/htslib-${PV}*
	sys-libs/ncurses:0=[unicode]
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# remove bundled htslib
	rm -r htslib-* || die

	eautoreconf
}

src_configure() {
	econf \
		--with-ncurses \
		--with-htslib=system \
		CURSES_LIB="$($(tc-getPKG_CONFIG) --libs ncursesw)"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_test() {
	# the tview test diffs expect 80-columns output
	unset COLUMNS

	default
}

src_install() {
	default

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
