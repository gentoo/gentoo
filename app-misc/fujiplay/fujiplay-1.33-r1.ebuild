# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utility for Fujifilm/Leica digital cameras (via serial port)"
HOMEPAGE="https://www.math.u-psud.fr/~bousch/fujiplay.html"
SRC_URI="https://www.math.u-psud.fr/~bousch/${PN}.tgz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${P}-unterminated-strings.patch )

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin fujiplay yycc2ppm
	dodoc README fujiplay.lsm mx700-commands.html
	emake all clean
}

pkg_postinst() {
	ln -s /dev/ttyS0 /dev/fujifilm || die
	elog "A symbolic link /dev/ttyS0 -> /dev/fujifilm was created."
	elog "You may want to create a serial group to allow non-root"
	elog "members R/W access to the serial device."
	elog
}

pkg_postrm() {
	rm -f /dev/fujifilm || die
	elog
	elog "The symbolic link /dev/fujifilm was removed."
	elog
}
