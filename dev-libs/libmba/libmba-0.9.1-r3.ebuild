# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A library of generic C modules"
LICENSE="MIT"
HOMEPAGE="http://www.ioplex.com/~miallen/libmba/"
SRC_URI="http://www.ioplex.com/~miallen/libmba/dl/${P}.tar.gz"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

src_prepare() {
	use static-libs && export STATIC="1"

	epatch "${FILESDIR}"/${P}-qa.patch
	epatch "${FILESDIR}"/${P}-glibc-2.20.patch

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
	dohtml -r docs/*.html docs/www/* docs/ref

	insinto /usr/share/doc/${PF}/examples
	doins examples/*
}
