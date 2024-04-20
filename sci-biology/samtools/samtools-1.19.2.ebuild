# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="https://github.com/samtools/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-lang/perl
	=sci-libs/htslib-$(ver_cut 1-2)*:=
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# remove bundled htslib
	rm -r htslib-* || die
}

src_configure() {
	econf \
		--with-ncurses \
		--with-htslib=system \
		CURSES_LIB="$($(tc-getPKG_CONFIG) --libs ncursesw || die)"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}
