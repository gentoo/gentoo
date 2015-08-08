# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="An easy-to-use hash implementation for C programmers"
HOMEPAGE="http://uthash.sourceforge.net"
SRC_URI="mirror://sourceforge/uthash/${P}.tar.bz2"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 sparc x86"
IUSE="test"

DEPEND="test? ( dev-lang/perl )"
RDEPEND=""

src_test() {
	cd tests
	sed -i "/CFLAGS/s/-O3/${CFLAGS}/" Makefile || die "sed cflags failed"
	emake CC="$(tc-getCC)"
}

src_install() {
	insinto /usr/include
	doins src/*.h || die "doins failed"

	dodoc doc/txt/{ChangeLog,userguide,ut*}.txt
}
