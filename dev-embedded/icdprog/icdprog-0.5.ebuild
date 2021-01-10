# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Microchip PIC Programmer using ICD hardware"
HOMEPAGE="http://icdprog.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

src_configure() {
	tc-export CC
}

src_compile() {
	emake CFLAGS="${CFLAGS}" -C src
	emake CFLAGS="${CFLAGS}" -C src/icddump
}

src_install() {
	dobin src/icdprog
	dobin src/icddump/icddump

	DOCS=( src/README.coders )
	HTML_DOCS=( readme.html )
	einstalldocs
}

pkg_postinst() {
	elog "Please see readme.html if the ICD seems to be very slow."
}
