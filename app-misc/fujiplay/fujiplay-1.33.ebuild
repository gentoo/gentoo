# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Utility for Fujifilm/Leica digital cameras (via serial port)"
HOMEPAGE="http://topo.math.u-psud.fr/~bousch/fujiplay.html"
SRC_URI="http://topo.math.u-psud.fr/~bousch/${PN}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-unterminated-strings.patch
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin fujiplay yycc2ppm || die
	dodoc README fujiplay.lsm mx700-commands.html
	emake all clean
}

pkg_postinst() {
	ln -s /dev/ttyS0 /dev/fujifilm
	elog "A symbolic link /dev/ttyS0 -> /dev/fujifilm was created."
	elog "You may want to create a serial group to allow non-root"
	elog "members R/W access to the serial device."
	echo
}

pkg_postrm() {
	rm -f /dev/fujifilm
	echo
	elog "The symbolic link /dev/fujifilm was removed."
	echo
}
