# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="An extremely configurable ftp client"
HOMEPAGE="https://www.ncftp.com/"
SRC_URI="
	https://ftp.mirrorservice.org/sites/ftp.${PN}.com/${PN}/${P}-src.tar.xz
"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="pch"

DEPEND="
	sys-libs/ncurses:*
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.2.6-fno-common.patch
)

src_prepare() {
	default

	AT_M4DIR=autoconf_local/ eautoreconf
}

src_configure() {
	tc-export CC
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
