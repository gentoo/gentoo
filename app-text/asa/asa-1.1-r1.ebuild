# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/asa/asa-1.1-r1.ebuild,v 1.1 2013/09/23 12:37:07 jlec Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="ASA Carriage control conversion for ouput by Fortran programs"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/devel/lang/fortran/"
SRC_URI="http://www.ibiblio.org/pub/Linux/devel/lang/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	sed \
		-e "s:-o:${LDFLAGS} -o:g" \
		-e "/^CFLAGS/d" \
		-i Makefile || die
	tc-export CC
}

src_install() {
	dobin asa
	doman asa.1
	dodoc README asa.dat
}
