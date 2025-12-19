# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools toolchain-funcs

DESCRIPTION="An extremely configurable ftp client"
HOMEPAGE="https://www.ncftp.com/"
SRC_URI="https://www.ncftp.com/public_ftp/${PN}/${P}-src.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="pch"

DEPEND="
	sys-libs/ncurses:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default

	sed \
		-e '/^AR=/d' \
		-e 's/STRIP=".*"/STRIP=":"/' \
		-e 's/\<AC_LANG\>/_AC_LANG/' \
		-i autoconf_local/aclocal.m4 || die

	AT_M4DIR=autoconf_local/ eautoreconf
}

src_configure() {
	tc-export AR CC
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
