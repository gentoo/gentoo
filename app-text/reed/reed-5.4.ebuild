# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="This is a text pager (text file viewer), used to display etexts"
# Homepage http://www.sacredchao.net/software/reed/index.shtml does not exist.
HOMEPAGE="http://web.archive.org/web/20040217010815/www.sacredchao.net/software/reed/"
SRC_URI="http://www.sacredchao.net/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

BDEPEND="virtual/pkgconfig"
DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS NEWS README )

src_prepare() {
	default

	sed -e 's;-O2;$(CFLAGS) $(LDFLAGS);' \
		-e 's: wrap::' \
		-e 's:-s reed:reed:' \
		-e "s:-lcurses:$($(tc-getPKG_CONFIG) --libs ncurses):g" \
		-i Makefile.in || die

	# Collision with talkfilters, bug #247396
	rm wrap.1 || die

	tc-export CC
}

src_configure() {
	./configures --prefix=/usr || die
}
