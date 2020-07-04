# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic qmake-utils

DESCRIPTION="GUI for personalization of Yubico's YubiKey"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization-gui"
SRC_URI="https://github.com/Yubico/yubikey-personalization-gui/archive/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug test"

RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig"
RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sys-auth/libyubikey-1.6
	>=sys-auth/ykpers-1.14.0
	virtual/libusb:1"
DEPEND="${RDEPEND}
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
