# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="uu, xx, base64, binhex decoder"
HOMEPAGE="http://www.fpx.de/fp/Software/UUDeview/"
SRC_URI="http://www.fpx.de/fp/Software/UUDeview/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${P}-bugfixes.patch
	"${FILESDIR}"/${P}-CVE-2004-2265.patch
	"${FILESDIR}"/${P}-CVE-2008-2266.patch
	"${FILESDIR}"/${P}-man.patch
	"${FILESDIR}"/${P}-rename.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fix-append_signature.patch
	"${FILESDIR}"/${P}-string_format_issue.patch
	"${FILESDIR}"/${P}-format-string-warning-inews.patch
	"${FILESDIR}"/${P}-fix-function-definitions-clang16.patch
	"${FILESDIR}"/${P}-fix-implicit.diff
)

DOCS=( HISTORY INSTALL README )

src_prepare() {
	sed -i "s:^\tar r:\t$(tc-getAR) r:" uulib/Makefile.in || die

	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-tcl \
		--disable-tk
}
