# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/asa/asa-1.1.ebuild,v 1.1 2011/11/02 18:44:16 floppym Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="ASA Carriage control conversion for ouput by Fortran programs"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/devel/lang/fortran/"
SRC_URI="http://www.ibiblio.org/pub/Linux/devel/lang/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin asa
	doman asa.1
	dodoc README asa.dat
}
