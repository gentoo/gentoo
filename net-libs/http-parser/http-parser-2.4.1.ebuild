# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/http-parser/http-parser-2.4.1.ebuild,v 1.1 2015/01/23 00:25:43 mrueg Exp $

EAPI=5

SONAME="libhttp_parser.so.${PV}"

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="http request/response parser for c"
HOMEPAGE="https://github.com/joyent/http-parser"
SRC_URI="https://github.com/joyent/http-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="static-libs"

src_prepare() {

	sed -i  -e 's: -Werror::' \
		-e 's:-O3 ::' \
		Makefile || die
	tc-export CC AR
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
