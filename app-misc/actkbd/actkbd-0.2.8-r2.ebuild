# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info eutils toolchain-funcs

DESCRIPTION="A keyboard shortcut daemon"
HOMEPAGE="http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/"
SRC_URI="http://users.softlab.ece.ntua.gr/~thkala/projects/actkbd/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

CONFIG_CHECK="~INPUT_EVDEV"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.2.7-amd64.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin actkbd
	dodoc AUTHORS ChangeLog FAQ README TODO
	docinto samples
	dodoc samples/actkbd.conf
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}

pkg_postinst() {
	elog
	elog "System-wide configuration file is /etc/actkbd.conf."
	elog "Use actkbd.conf from usr/share/doc/${PF}/samples as a template."
	elog "You need to create the config and set right input device from"
	elog "/dev/input/event* in /etc/conf.d/actkbd"
	elog
	elog "To obtain keycodes for pressed combinations/keys just run:"
	elog "  # actkbd -s -d /dev/input/event<MYDEVICENUMBER>"
}
