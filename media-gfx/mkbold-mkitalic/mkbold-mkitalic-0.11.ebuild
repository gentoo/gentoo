# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

DESCRIPTION="Make BDF fonts bold and/or italic"
HOMEPAGE="https://hp.vector.co.jp/authors/VA013651/freeSoftware/mkbold-mkitalic.html"
SRC_URI="https://hp.vector.co.jp/authors/VA013651/lib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~sparc ~x86"

DEPEND=""
RDEPEND=""

DOCS="ALGORITHM* README*"

src_prepare() {
	default

	sed -i \
		-e "/^MAKE/,/^CC/d" \
		-e "/^CFLAGS/s|= .* \\$|= ${CFLAGS} $|" \
		-e "/^LDFLAGS/s|= .*|= ${LDFLAGS}|" \
		-e "/^prefix/s|= .*|= ${EPREFIX}|" \
		Makefile
	tc-export CC
}

src_install() {
	dobin mk{bold,italic,bolditalic}
	einstalldocs
}
