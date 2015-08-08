# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Microchip PIC Programmer using ICD hardware"
HOMEPAGE="http://icdprog.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

src_compile() {
	tc-export CC

	cd "${S}"/src
	emake CFLAGS="${CFLAGS}"
	cd "${S}"/src/icddump
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin src/icdprog
	dobin src/icddump/icddump
	dohtml readme.html
	dodoc src/README.coders
}

pkg_postinst() {
	elog "Please see readme.html if the ICD seems to be very slow."
}
