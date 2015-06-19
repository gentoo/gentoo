# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/powernowd/powernowd-1.00-r3.ebuild,v 1.4 2015/04/19 09:30:42 pacho Exp $

EAPI=5
inherit eutils linux-info systemd toolchain-funcs

DESCRIPTION="Daemon to control the speed and voltage of CPUs"
HOMEPAGE="http://www.deater.net/john/powernowd.html https://github.com/clemej/powernowd"
SRC_URI="http://www.deater.net/john/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"

pkg_setup() {
	CONFIG_CHECK="~CPU_FREQ"
	WARNING_CPU_FREQ="Powernowd needs CPU_FREQ turned on!"
	linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-buf.patch
	rm -f Makefile
	tc-export CC
}

src_compile() {
	emake powernowd
}

src_install() {
	dosbin powernowd
	dodoc README

	newconfd "${FILESDIR}"/powernowd.confd powernowd
	newinitd "${FILESDIR}"/powernowd.initd powernowd
	systemd_dounit "${FILESDIR}"/${PN}.service
}
