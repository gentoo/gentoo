# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib

DESCRIPTION="Report faked system time to programs"
HOMEPAGE="http://www.code-wizards.com/projects/libfaketime/ https://github.com/wolfcw/libfaketime/"
SRC_URI="http://www.code-wizards.com/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa x86"

src_prepare() {
	tc-export CC
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIRNAME="/$(get_libdir)" PREFIX=/usr
}

src_install() {
	dobin src/faketime
	doman man/faketime.1
	exeinto /usr/$(get_libdir)
	doexe src/${PN}*.so.*
	dosym ${PN}.so.1 /usr/$(get_libdir)/${PN}.so
	dosym ${PN}MT.so.1 /usr/$(get_libdir)/${PN}MT.so
	dodoc NEWS README TODO
}
