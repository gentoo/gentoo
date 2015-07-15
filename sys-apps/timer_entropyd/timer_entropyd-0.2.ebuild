# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/timer_entropyd/timer_entropyd-0.2.ebuild,v 1.5 2015/07/15 19:35:23 perfinion Exp $

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A timer-based entropy generator"
HOMEPAGE="http://www.vanheusden.com/te/"
SRC_URI="http://www.vanheusden.com/te/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="debug selinux"

RDEPEND="selinux? ( sec-policy/selinux-entropyd )"

src_prepare() {
	sed -i -e 's:-O2::' Makefile || die
	epatch "${FILESDIR}"/${PN}-0.1-syslog.patch
}

src_compile() {
	use debug && append-cppflags -D_DEBUG

	tc-export CC
	emake DEBUG= || die
}

src_install() {
	exeinto /usr/libexec
	doexe ${PN}
	dodoc Changes readme.txt
	newinitd "${FILESDIR}/timer_entropyd.initd.1" ${PN} || die
}

pkg_postinst() {
	elog "To start ${PN} at boot do rc-update add ${PN} default"
	elog "To start ${PN} now do /etc/init.d/${PN} start"
	elog "To check the amount of entropy, cat /proc/sys/kernel/random/entropy_avail"
}
