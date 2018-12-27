# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs multilib-minimal

HP_COMMIT="350258965909f249f9c59823aac240313e0d0120"
DESCRIPTION="HTTP request/response parser for C"
HOMEPAGE="https://github.com/nodejs/http-parser"
SRC_URI="https://github.com/nodejs/http-parser/archive/${HP_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/2.8.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x64-macos ~x64-solaris"
IUSE="static-libs"

S=${WORKDIR}/${PN}-${HP_COMMIT}

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
