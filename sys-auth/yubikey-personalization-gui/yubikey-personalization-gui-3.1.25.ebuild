# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop flag-o-matic qmake-utils

DESCRIPTION="GUI for personalization of Yubico's YubiKey"
SRC_URI="https://github.com/Yubico/yubikey-personalization-gui/archive/${P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization-gui"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="BSD-2"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sys-auth/libyubikey-1.6
	>=sys-auth/ykpers-1.14.0
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-qt/qttest:5 )"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	if ! use test ; then
		sed -i YKPersonalization.pro \
			-e 's/src \\/src/' \
			-e '/tests/d' || die
	fi
}

src_configure() {
	append-cxxflags -std=c++11

	eqmake5 "CONFIG+=nosilent" YKPersonalization.pro
}

src_install() {
	dobin build/release/yubikey-personalization-gui
	doman resources/lin/yubikey-personalization-gui.1
	domenu resources/lin/yubikey-personalization-gui.desktop
	doicon resources/lin/yubikey-personalization-gui.xpm
	doicon -s 128 resources/lin/yubikey-personalization-gui.png
}
