# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils toolchain-funcs

DESCRIPTION="An extremely configurable ftp client"
HOMEPAGE="http://www.ncftp.com/"
SRC_URI="
	ftp://ftp.${PN}.com/${PN}/${P}-src.tar.xz -> ${P}.tar.xz
"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="pch"

DEPEND="
	sys-libs/ncurses:*
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default

	tc-export CC

	sed -i \
		-e "s:CC=gcc:CC ?= ${CC}:" \
		-e 's:@SFLAG@::' \
		-e 's:@STRIP@:true:' \
		Makefile.in */Makefile.in || die

	AT_M4DIR=autoconf_local/ eautoreconf
}

src_configure() {
	LC_ALL="C" \
	LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses)" \
		econf \
		$(use_enable pch precomp) \
		--disable-ccdv \
		--disable-universal
}

src_install() {
	default
	dodoc README.txt doc/*.txt
	docinto html
	dodoc doc/html/*.html
}
