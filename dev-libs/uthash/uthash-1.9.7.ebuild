# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/uthash/uthash-1.9.7.ebuild,v 1.7 2013/06/26 17:08:12 blueness Exp $

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
