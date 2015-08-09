# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Console Mixer Program for OSS"
HOMEPAGE="http://www.fh-worms.de/~inf222"
SRC_URI="http://www.Fh-Worms.DE./~inf222/code/c/gom/released/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="examples"

DEPEND=">=sys-libs/ncurses-5.2"

src_compile() {
	econf
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed."
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS NEWS ChangeLog README

	if use examples; then
		docinto examples
		dodoc README
		docinto examples/default
		dodoc examples/default/*
		docinto examples/two-mixers
		dodoc examples/two-mixers/*
	fi
}
