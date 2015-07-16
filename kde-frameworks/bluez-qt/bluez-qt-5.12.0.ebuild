# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/bluez-qt/bluez-qt-5.12.0.ebuild,v 1.1 2015/07/16 20:33:15 johu Exp $

EAPI=5

inherit kde5 udev

DESCRIPTION="Qt wrapper for Bluez 5 DBus API"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
"
RDEPEND="${DEPEND}
	!kde-plasma/bluez-qt
"

src_configure() {
	local mycmakeargs=(
		-DUDEV_RULES_INSTALL_DIR="$(get_udevdir)/rules.d"
	)

	kde5_src_configure
}
