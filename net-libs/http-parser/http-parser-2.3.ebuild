# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SONAMEVER="2.3"
SONAME="libhttp_parser.so.${SONAMEVER}"

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="A parser for HTTP messages written in C. It parses both requests and responses"
HOMEPAGE="https://github.com/joyent/http-parser"
SRC_URI="https://github.com/joyent/http-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${SONAMEVER}"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="static-libs"

src_prepare() {
	tc-export CC AR
	epatch "${FILESDIR}"/${P}-flags.patch
	multilib_copy_sources
}

multilib_src_compile() {
	emake library
	use static-libs && emake package
}

multilib_src_install() {
	doheader http_parser.h
	dolib.so ${SONAME}
	dosym ${SONAME} /usr/$(get_libdir)/libhttp_parser.so
	use static-libs && dolib.a libhttp_parser.a
}

multilib_src_install_all() {
	dodoc README.md
}
