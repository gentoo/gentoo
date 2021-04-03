# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A library of generic C modules"
LICENSE="MIT"
HOMEPAGE="http://www.ioplex.com/~miallen/libmba/"
SRC_URI="http://www.ioplex.com/~miallen/libmba/dl/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-qa.patch
	"${FILESDIR}"/${P}-glibc-2.20.patch
)

src_prepare() {
	default

	tc-export CC
	sed -i -e "s:gcc:${CC}:g" mktool.c || die

	# prevent reinventing strdup(), wcsdup() and strnlen()
	append-cflags -D_XOPEN_SOURCE=500
}

src_compile() {
	emake LIBDIR="$(get_libdir)"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install

	dodoc README.txt docs/*.txt
	docinto html
	dodoc -r docs/*.html docs/www/* docs/ref

	docinto examples
	doins examples/*

	gunzip -v $(find "${ED}" -name '*.[0-9]*.gz') || die
}
