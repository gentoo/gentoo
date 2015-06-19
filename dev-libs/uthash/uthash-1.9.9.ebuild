# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/uthash/uthash-1.9.9.ebuild,v 1.1 2014/07/02 05:51:34 dlan Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="An easy-to-use hash implementation for C programmers"
HOMEPAGE="http://troydhanson.github.io/uthash/index.html"
SRC_URI="https://github.com/troydhanson/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

DEPEND="sys-apps/sed
	test? ( dev-lang/perl )"
RDEPEND=""

src_test() {
	cd tests || die
	sed -i "/CFLAGS/s/-O3/${CFLAGS}/" Makefile || die
	emake CC="$(tc-getCC)"
}

src_install() {
	insinto /usr/include
	doins src/*.h

	dodoc doc/{ChangeLog,todo,userguide,ut*}.txt
}
