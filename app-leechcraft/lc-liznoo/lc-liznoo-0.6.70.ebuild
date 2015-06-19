# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-liznoo/lc-liznoo-0.6.70.ebuild,v 1.1 2014/08/03 18:56:35 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="UPower-based power manager for LeechCraft"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug systemd"

DEPEND="~app-leechcraft/lc-core-${PV}
	x11-libs/qwt:6
	dev-qt/qtdbus:4
	virtual/leechcraft-trayarea"
RDEPEND="${DEPEND}
	!systemd? ( || ( >=sys-power/upower-0.99 sys-power/upower-pm-utils ) )
	systemd? ( || ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils ) )"

pkg_postinst() {
	if has_version '>=sys-power/upower-0.99'; then
		ewarn "The new sys-power/upower version you have installed doesn't have hibernate"
		ewarn "and suspend. If you need hibernate and suspend in ${PN}, and you use"
		ewarn "systemd, you should downgrade sys-power/upower to 0.9.23 series. All others"
		ewarn "should switch to sys-power/upower-pm-utils, also to 0.9.23 series."
	fi
}
