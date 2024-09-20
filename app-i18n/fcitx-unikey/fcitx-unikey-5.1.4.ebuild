# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="fcitx5-unikey"

inherit cmake unpacker xdg

DESCRIPTION="Unikey (Vietnamese Input Method) engine support for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-unikey"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_PN}-${PV}.tar.zst"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-2+ GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+gui +qt5 qt6 test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-i18n/fcitx-5.1.10:5
	>=app-i18n/fcitx-qt-5.0.12[qt5?,qt6?,-onlyplugin]
	gui? (
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5=
			dev-qt/qtwidgets:5
		)
		qt6? (
			dev-qt/qtbase:6[dbus,gui,widgets]
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=( )
	if use gui; then
		mycmakeargs+=(
			-DENABLE_QT=ON
			-DUSE_QT6=$(usex qt6)
		)
	fi
	cmake_src_configure
}
