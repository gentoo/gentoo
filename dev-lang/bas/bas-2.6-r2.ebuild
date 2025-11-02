# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="An interpreter for the classic dialect of the programming language BASIC"
HOMEPAGE="http://www.moria.de/~michael/bas/"
SRC_URI="http://www.moria.de/~michael/bas/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc64 ~riscv ~x86"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libintl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-alternatives/lex
	sys-devel/gettext
"

PATCHES=( "${FILESDIR}/${PN}-2.1-makefile.patch" )

src_prepare() {
	default

	eautoconf
}

src_configure() {
	tc-export AR

	econf
}

src_install() {
	default
	find "${ED}" -name "*.a" -delete || die "failed to remove static libs"

	docinto pdf
	dodoc ./bas.pdf
}
