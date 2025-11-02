# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Port Forwarding Daemon"
HOMEPAGE="https://portfwd.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.29-build-system.patch
	"${FILESDIR}"/${PN}-0.29-fix_c23.patch
)

src_prepare() {
	default

	# bug 945521, use header from glibc/musl instead
	rm getopt/getopt.h || die

	mv configure.in configure.ac || die # bug 822075

	eautoreconf
}

src_install() {
	default

	dodoc cfg/*

	newinitd "${FILESDIR}"/${PN}-2.init ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
