# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps toolchain-funcs

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="http://www.inlab.de/balance.html"
SRC_URI="http://www.inlab.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

FILECAPS=(
	CAP_NET_BIND_SERVICE usr/sbin/balance
)

src_prepare() {
	default

	tc-export CC
}

src_install() {
	default

	# Autocreated on program start, if missing
	rm -rv "${ED}/var/run" || die
}

pkg_postinst() {
	fcaps_pkg_postinst
	elog "To run as non-root, be sure to have rendezvous directory created"
	elog "with either 'mkdir -m 01777 ${EROOT}/var/run/balance' or using tmpfiles."
}
