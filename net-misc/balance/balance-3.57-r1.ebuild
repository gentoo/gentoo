# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps flag-o-matic toolchain-funcs

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="https://balance.inlab.net"
SRC_URI="https://download.inlab.net/Balance/${PV}/${P}.tar"

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

src_compile() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861599
	# https://sourceforge.net/p/balance/bugs/13/
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	default
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
