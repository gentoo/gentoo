# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs multilib-minimal

DESCRIPTION="HTTP request/response parser for C"
HOMEPAGE="https://github.com/nodejs/http-parser"
EGIT_REPO_URI="https://github.com/nodejs/http-parser"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

src_prepare() {
	default
	tc-export CC AR
	multilib_copy_sources
}

multilib_src_compile() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" CFLAGS_FAST="${CFLAGS}" library
	use static-libs && emake CFLAGS_FAST="${CFLAGS}" package
}

multilib_src_test() {
	emake CFLAGS_DEBUG="${CFLAGS}" CFLAGS_FAST="${CFLAGS}" test
}

multilib_src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	use static-libs && dolib.a libhttp_parser.a
}
