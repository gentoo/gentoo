# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/yubikey-personalization-gui/yubikey-personalization-gui-3.1.20.ebuild,v 1.2 2015/05/04 06:52:27 jlec Exp $

EAPI=5

inherit eutils qmake-utils

DESCRIPTION="GUI for personalization of Yubico's YubiKey"
SRC_URI="http://yubico.github.io/yubikey-personalization-gui/releases/${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization-gui"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="BSD-2"
IUSE="debug"

RDEPEND="
	>=sys-auth/ykpers-1.14.0
	>=sys-auth/libyubikey-1.6
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	dev-libs/glib:2
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( NEWS README )

src_configure() {
	eqmake4 YKPersonalization.pro
}

src_install() {
	dobin build/release/yubikey-personalization-gui
	doman resources/lin/yubikey-personalization-gui.1
	domenu resources/lin/yubikey-personalization-gui.desktop
	doicon resources/lin/yubikey-personalization-gui.xpm
	doicon -s 128 resources/lin/yubikey-personalization-gui.png
}
