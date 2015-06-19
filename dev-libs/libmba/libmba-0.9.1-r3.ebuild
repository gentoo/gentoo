# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmba/libmba-0.9.1-r3.ebuild,v 1.3 2015/04/19 09:32:19 ago Exp $

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A library of generic C modules"
LICENSE="MIT"
HOMEPAGE="http://www.ioplex.com/~miallen/libmba/"
SRC_URI="${HOMEPAGE}dl/${P}.tar.gz"
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
